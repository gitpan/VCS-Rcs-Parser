#!/bin/bash

#make these same as in 'test_co_db.pl' and 'test_co_db.sh'
COPLTEST='test_dir/'
COSHTEST='TEST_DIR/'

echo "Removing the test dirs:"

#echo -n "removing whole $COPLTEST are you sure? (y/ctrl-C)"
#read A
#[ "$A" == "y" ] && rm -rf $COPLTEST
rm -rf $COPLTEST

#echo -n "removing whole $COSHTEST are you sure? (y/ctrl-C)"
#read A
#[ "$A" == "y" ] && rm -rf $COSHTEST
rm -rf $COSHTEST


COPL='./test_co_db.pl'
COSH='./test_co_db.sh'
GRPL='./test_co_db_grep.pl'
GRSH='./test_co_db_grep.sh'

for i in $(find RCS)
do
   [ "$i" == "${i%,v}" ] || mv $i ${i%,v}
done

echo -n "doing $COPL..."
if $COPL > /dev/null 2>&1
then
    echo "OK"
else
    echo "NOT OK!!!!!!!!!"
fi

echo -n "doing $COSH..."
if $COSH > /dev/null 2>&1
then
    echo "OK"
else
    echo "NOT OK!!!!!!!!!"
fi


echo -n "diffing..."
if diff $COPLTEST $COSHTEST > /dev/null 2>&1
then
    echo "OK"
else
    echo "NOT OK!!!!!!!!!"
fi


echo -n "doing $GRPL..."
if $GRPL 2> /dev/null | sort > tmp1 
then
    echo "OK"
else
    echo "NOT OK!!!!!!!!!"
fi

echo -n "doing $GRSH..."
if $GRSH 2> /dev/null | sort > tmp2 
then
    echo "OK"
else
    echo "NOT OK!!!!!!!!!"
fi

echo -n "diffing..."
if diff tmp1 tmp2 > /dev/null 2>&1
then
    echo "OK"
else
    echo "NOT OK!!!!!!!!!"
fi


