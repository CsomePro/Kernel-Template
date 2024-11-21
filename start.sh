#!/bin/sh
qemu-system-x86_64 \
    -m 256M \
    -kernel ~/kernel/linux-6.1.62/arch/x86/boot/bzImage \
    -initrd ./rootfs.img \
    -monitor /dev/null \
    -append "root=/dev/ram console=ttyS0 oops=panic quiet panic=1 nokaslr" \
    -cpu kvm64,+smep,+smap\
    -netdev user,id=t0, -device e1000,netdev=t0,id=nic0 \
    -nographic \
    -no-reboot -s
