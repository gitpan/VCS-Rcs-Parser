#!/bin/bash

RCSTREE='./RCS'
DIFF='diff'
CO='co -q'
RCSPM='perl Rcs.pm'
THERE_IS_ERROR=0
i=0

FIND=$(find $RCSTREE | grep ',v$')

for v in $FIND 
do
    i=$((i+1))

    $($RCSPM $v > tmp)

    v=${v##*/}
    v=${v%,v}
    $($CO -r1.1 $v)

    if $($DIFF tmp $v >&2)
    then
        echo "$i $v OK!";
    else
        echo "$v has some trouble" >&2
        echo "$v has some trouble" 
        THERE_IS_ERROR=1
    fi

done


if [ "$THERE_IS_ERROR" == "1" ]
then
    echo
    echo
    echo PANIC!!!!!!!
    echo
    echo
else
    echo
    echo
    echo YUPPIIII!!! IT WORKS!!!
    echo
    echo    ( surprised ? )
    echo
fi
