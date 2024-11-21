#!/bin/sh
echo "[+] compile exp.c ..."
gcc exp.c -o ./rootfs/exp -static -g

echo "[+] cpio packing ..."
mkdir ~/rootfs
cp ./rootfs.img.bak ~/rootfs/rootfs.img
cp ./rootfs/exp ~/rootfs
cd ~/rootfs
cpio -idm < ./rootfs.img
rm rootfs.img
find . -print0 | cpio --null -ov --format=newc > ../rootfs.img
cd -
mv ~/rootfs.img ./
rm -r ~/rootfs

echo "[+] done. "
