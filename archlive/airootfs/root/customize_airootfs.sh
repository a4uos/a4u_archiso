#!/bin/bash

set -e -u
sed -i 's/#\(en_US\.UTF-8\)/\1/' /etc/locale.gen
sed -i "s/#\(ru_RU\.UTF-8\)/\1/" /etc/locale.gen
locale-gen
# Vconsole
echo "KEYMAP=ru" > /etc/vconsole.conf
echo "FONT=cyr-sun16" >> /etc/vconsole.conf
ln -sf /usr/share/zoneinfo/UTC /etc/localtime


usermod -s /usr/bin/bash root
cp -aT /etc/skel/ /root/

useradd -m -p "" -g users -G "adm,audio,floppy,log,network,rfkill,scanner,storage,optical,power,wheel" -s /bin/bash liveuser
passwd -d liveuser
echo "liveuser ALL=(ALL) ALL" >> /etc/sudoers

sed -i 's/#\(PermitRootLogin \).\+/\1yes/' /etc/ssh/sshd_config
sed -i "s/#Server/Server/g" /etc/pacman.d/mirrorlist
sed -i 's/#\(Storage=\)auto/\1volatile/' /etc/systemd/journald.conf

sed -i 's/#\(HandleSuspendKey=\)suspend/\1ignore/' /etc/systemd/logind.conf
sed -i 's/#\(HandleHibernateKey=\)hibernate/\1ignore/' /etc/systemd/logind.conf
sed -i 's/#\(HandleLidSwitch=\)suspend/\1ignore/' /etc/systemd/logind.conf

reflector --verbose -l 5 -p http --sort rate --save /etc/pacman.d/mirrorlist

initkeys() {
     pacman-key --init
     pacman-key --populate archlinux
     pacman -Syy --noconfirm
     pacman -Syu
 }

# Удаление тем по умолчанию
# sudo rm -rf /usr/share/themes/*

fixWifi() {
    su -c 'echo "" >> /etc/NetworkManager/NetworkManager.conf'
    su -c 'echo "[device]" >> /etc/NetworkManager/NetworkManager.conf'
    su -c 'echo "wifi.scan-rand-mac-address=no" >> /etc/NetworkManager/NetworkManager.conf'
}

systemctl enable NetworkManager.service
systemctl set-default graphical.target

fixWifi
