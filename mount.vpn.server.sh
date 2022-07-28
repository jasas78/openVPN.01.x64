#!/bin/bash

umount /ov/s/tmp      &> /dev/null
umount /ov/s/dev      &> /dev/null
umount /ov/s/proc     &> /dev/null
umount /ov/s          &> /dev/null

mount |grep \ /ov/s

aa1=`mount |grep \ /ov/s |wc -l`

#echo "aa1=<${aa1}>"
if [ ${aa1} -ne 0 ]
then
    echo 
    echo " umount failed !!! "
    echo 
    exit
else
    echo
    echo " umount all succeed."
fi

if [ "${1}" = 'm' ]
then
    echo
    mount /ov/s          
    mount /ov/s/tmp      
    mount /ov/s/dev      
    mount /ov/s/proc     
    echo
    mount |grep \ /ov|sort
    echo
fi
