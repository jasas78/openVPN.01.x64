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
    exit
else
    echo
    echo " umount all succeed."
fi

if [ "${1}" = 'm' ]
then
    echo
    mount /ov          
    mount /ov/tmp      
    mount /ov/dev      
    mount /ov/proc     
    echo
    mount |grep \ /ov 
fi
