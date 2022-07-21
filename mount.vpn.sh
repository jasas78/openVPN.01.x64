#!/bin/bash

umount /ov/tmp      &> /dev/null
umount /ov/dev      &> /dev/null
umount /ov/proc     &> /dev/null
umount /ov          &> /dev/null

mount |grep \ /ov

aa1=`mount |grep \ /ov |wc -l`

#echo "aa1=<${aa1}>"
if [ ${aa1} -ne 0 ]
then
    echo 
    echo " umount failed !!! "
    echo 
fi
