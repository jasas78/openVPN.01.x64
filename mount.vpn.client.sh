#!/bin/bash

umount /ov/c/tmp      &> /dev/null
umount /ov/c/dev      &> /dev/null
umount /ov/c/proc     &> /dev/null
umount /ov/c          &> /dev/null

mount |grep \ /ov/c

aa1=`mount |grep \ /ov/c |wc -l`

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
    mount /ov/c          
    mount /ov/c/tmp      
    mount /ov/c/dev      
    mount /ov/c/proc     
    echo
    mount |grep \ /ov|sort
    echo
fi
