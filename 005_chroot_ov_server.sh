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
    #echo "nice -n 19 sudo /sbin/chroot --userspec nobody --groups=nogroup /ov/s/ /bin/bash"
    #      nice -n 19 sudo /sbin/chroot --userspec nobody --groups=nogroup /ov/s/ /bin/bash 
    #echo "nice -n 19 sudo /sbin/chroot --userspec nobody --groups=nogroup /ov/s/ /bin/bash"
    echo "nice -n 19 sudo /sbin/chroot --userspec nobody --groups=nogroup /ov/s/ /sbin/openvpn --config /etc/openvpn/server.conf "
          nice -n 19 sudo /sbin/chroot --userspec nobody --groups=nogroup /ov/s/ /sbin/openvpn --config /etc/openvpn/server.conf  
    echo "nice -n 19 sudo /sbin/chroot --userspec nobody --groups=nogroup /ov/s/ /sbin/openvpn --config /etc/openvpn/server.conf "
elif [ "$1" = 'r1' ]
then
    echo "nice -n 19 sudo /sbin/chroot                                    /ov/s/ /sbin/openvpn --config /tmp/conf_server.conf "
          nice -n 19 sudo /sbin/chroot                                    /ov/s/ /sbin/openvpn --config /tmp/conf_server.conf  
    echo "nice -n 19 sudo /sbin/chroot                                    /ov/s/ /sbin/openvpn --config /tmp/conf_server.conf "
elif [ "$1" = 'r2' ]
then
    echo "nice -n 19 sudo /sbin/chroot                                    /ov/s/ /sbin/openvpn --config /etc/openvpn/server.conf "
          nice -n 19 sudo /sbin/chroot                                    /ov/s/ /sbin/openvpn --config /etc/openvpn/server.conf  
    echo "nice -n 19 sudo /sbin/chroot                                    /ov/s/ /sbin/openvpn --config /etc/openvpn/server.conf "
else
    echo "nice -n 19 sudo /sbin/chroot --userspec nobody --groups=nogroup /ov/s/ /sbin/openvpn --config /tmp/conf_server.conf "
          nice -n 19 sudo /sbin/chroot --userspec nobody --groups=nogroup /ov/s/ /sbin/openvpn --config /tmp/conf_server.conf  
    echo "nice -n 19 sudo /sbin/chroot --userspec nobody --groups=nogroup /ov/s/ /sbin/openvpn --config /tmp/conf_server.conf "
fi
  
