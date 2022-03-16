#!/bin/bash
#echo $@
#python -c "`awk -f makeFig.awk ${@}`"

awk -f ~/AWK/plotting/makeFig.awk ${@}
open ${1}.pdf
