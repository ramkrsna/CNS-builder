#!/bin/sh

DRY_RUN_PREFIX=
BUGS=
KERB_USERNAME="changeme"
HEKETI_BUGLIST=""

if [[ $DRY_RUN -eq 1 ]]
then
        DRY_RUN_PREFIX="echo"
fi
echo "please enter password for kinit"
kinit $KERB_USERNAME@REDHAT.COM
echo "please login to bugzilla"
bugzilla login

for BUG_COMMITID in HEKETI_BUGLIST
        BUG=`echo $BUG_COMMITID | cut -d":" -f1`
        COMMIT=`echo $BUG_COMMITID | cut -d":" -f2`
        export GIT_EDITOR="./patch-commit-message.sh" 
        export BUG
        $DRY_RUN_PREFIX  git cherry-pick -x -e $COMMIT
        BUGS+=" ${BUG}"
        SHORT_DESC=`bugzilla query -b ${BUG} --outputformat='%{short_desc}'`
        CHANGELOG+="- Resolves: #${BUG} - $SHORT_DESC\n"
done
echo -e "$CHANGELOG" | fold -s -w 78
