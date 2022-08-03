#!/bin/bash

dstUSER1=dyn
dstUSER2=root
dstUSER3=root


if [ \
    "${dstUSER3}" != "${USER}" -a \
    "${dstUSER2}" != "${USER}" -a \
    "${dstUSER1}" != "${USER}" \
    ]
then
    echo 
    echo 
    echo " you should run <$0> by user ${dstUSER1} , ${dstUSER1} or ${dstUSER3} only. exit. "
    echo 
    echo 
    exit
fi


#if [ 'dyn' = "${USER}" ]
if [ -z "$1" ]
then
    # /etc/sudoers.d/for_dyn
    # dyn v1=        NOPASSWD:/bin/linux32  /sbin/chroot /a3/miniserve/miniserve-v0.20.0/ /bin/su - dyn
    # dyn ALL=(ALL)  NOPASSWD:/bin/linux32  /sbin/chroot /a3/miniserve/miniserve-v0.20.0/ /bin/su - dyn

    # --auth ${pass} 
    #echo "nice -n 19 sudo /sbin/chroot --userspec nobody --groups=nogroup /ov/c/ /bin/bash"
    #      nice -n 19 sudo /sbin/chroot --userspec nobody --groups=nogroup /ov/c/ /bin/bash 
    #echo "nice -n 19 sudo /sbin/chroot --userspec nobody --groups=nogroup /ov/c/ /bin/bash"
    echo "nice -n 19 sudo /sbin/chroot --userspec nobody --groups=nogroup /ov/c/ /sbin/openvpn --config /etc/openvpn/client.conf "
          nice -n 19 sudo /sbin/chroot --userspec nobody --groups=nogroup /ov/c/ /sbin/openvpn --config /etc/openvpn/client.conf  
    echo "nice -n 19 sudo /sbin/chroot --userspec nobody --groups=nogroup /ov/c/ /sbin/openvpn --config /etc/openvpn/client.conf "
elif [ "$1" = 'r1' ]
then
    echo "nice -n 19 sudo /sbin/chroot                                    /ov/c/ /sbin/openvpn --config /tmp/conf_client.conf "
          nice -n 19 sudo /sbin/chroot                                    /ov/c/ /sbin/openvpn --config /tmp/conf_client.conf  
    echo "nice -n 19 sudo /sbin/chroot                                    /ov/c/ /sbin/openvpn --config /tmp/conf_client.conf "
elif [ "$1" = 'r2' ]
then
    echo "nice -n 19 sudo /sbin/chroot                                    /ov/c/ /sbin/openvpn --config /etc/openvpn/client.conf "
          nice -n 19 sudo /sbin/chroot                                    /ov/c/ /sbin/openvpn --config /etc/openvpn/client.conf  
    echo "nice -n 19 sudo /sbin/chroot                                    /ov/c/ /sbin/openvpn --config /etc/openvpn/client.conf "
else
    echo "nice -n 19 sudo /sbin/chroot --userspec nobody --groups=nogroup /ov/c/ /sbin/openvpn --config /tmp/conf_client.conf "
          nice -n 19 sudo /sbin/chroot --userspec nobody --groups=nogroup /ov/c/ /sbin/openvpn --config /tmp/conf_client.conf  
    echo "nice -n 19 sudo /sbin/chroot --userspec nobody --groups=nogroup /ov/c/ /sbin/openvpn --config /tmp/conf_client.conf "
fi
  
