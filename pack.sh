#!/bin/sh
./compile.sh
cd ./rootfs
echo "[+] cpio packing ..."
find . -print0 | cpio --null -ov --format=newc > ../rootfs.img
cd ..
echo "[+] done. "
