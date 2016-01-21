#!/bin/bash

export  LD_LIBRARY_PATH=/home/bootH/OpenVZ/i386/lib 

[ -f ./lib/ld-linux.so.2 ] || cp /lib/ld-linux.so.2 ./lib/ld-linux.so.2 

LD_LIBRARY_PATH=/home/bootH/OpenVZ/i386/lib \
    ./lib/ld-linux.so.2 --list ./now_bin
