#!/bin/sh

ed "$1" <<EOT
i
BUG: $BUG
.
wq
EOT
