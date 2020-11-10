#!/bin/bash
make clean
make
#cp test.imx /tftpboot/ 
dd if=/dev/zero of=/dev/sdb bs=1k seek=4 count=10
dd if=main.imx of=/dev/sdb bs=1k seek=4 conv=fsync
