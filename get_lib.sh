#1/bin/bash

rm -f lib/ld-linux.so.2 lib/lib*.so*

cp     /lib/ld-linux.so.2     lib/

#    `readelf -d now_bin_openvpn  |grep NEEDED |sed -e 's;.* ;;g' |cut -c 2- |sed -e 's;];;g'` 
for aa1 in \
    $( ./test_lib.sh2 )
do 
    echo "cp ${aa1} lib/"
          cp ${aa1} lib/ 
done
