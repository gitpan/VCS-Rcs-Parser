#!/bin/bash

IFS='
' 

for f in $(ls RCS)
do

    for i in $(rlog $f|grep ^revision)
    do 
        r=${i#revision }
        co -r$r -x $f
        grep ^r $f 
        rm -f $f
        
    done

done
