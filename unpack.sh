#!/bin/sh
cp rootfs.img rootfs.img.bak
mkdir ./rootfs
cp ./rootfs.img ./rootfs
cd ./rootfs
cpio -idm < ./rootfs.img
rm rootfs.img
cd -
