#!/bin/bash

function calc {
    echo "$@" |  awk -f calc3.awk 
    #printf "$@"
    #printf "$@" | 
}
