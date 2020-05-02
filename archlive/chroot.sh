#!/bin/bash

script_path=$(readlink -f ${0%/*})
work_dir=work

arch_chroot(){
   arch-chroot $script_path/${work_dir}/airootfs /bin/bash -c "${1}"
}

chroo_ter(){
arch_chroot "pacman-key --init
pacman-key --refresh-keys
reflector --verbose -a1 -f10 -l70 -phttps --sort rate --save /etc/pacman.d/mirrorlist
pacman -Syy"
}

chroo_ter