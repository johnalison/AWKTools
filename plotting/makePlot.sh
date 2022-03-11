#!/bin/bash
#echo $@
#python -c "`awk -f makeFig.awk ${@}`"

awk -f makeFig.awk ${@}
open ${@}.pdf
