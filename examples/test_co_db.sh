#!/bin/bash

TEST_DIR='TEST_DIR/'

[ -x $TEST_DIR ] && exit 1

[ -x $TEST_DIR ] || mkdir -p $TEST_DIR


IFS='
' 

for f in $(ls RCS)
do
    echo $f;

    for i in $(rlog $f|grep ^revision)
    do 
        r=${i#revision }
        co -r$r -x  $f;
        mv $f $TEST_DIR$f.$r 
    done

done
