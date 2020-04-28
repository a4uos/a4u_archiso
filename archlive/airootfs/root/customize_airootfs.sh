#!/bin/bash

set -e -u

sed -i 's/#\(ru_RU\.UTF-8\)/\1/' /etc/locale.gen
locale-gen
# ! id arch && useradd -m -p "" -g users -G "adm,audio,floppy,log,network,rfkill,scanner,storage,optical,power,wheel" -s /usr/bin/bash arch
ln -sf /usr/share/zoneinfo/UTC /etc/localtime

usermod -s /usr/bin/bash root
cp -aT /etc/skel/ /root/
# chown -R liveuser:users /home/liveuser
#chmod 700 /root

useradd -m -p "" -g users -G "adm,audio,floppy,log,network,rfkill,scanner,storage,optical,power,wheel" -s /bin/bash liveuser
# chown -R liveuser:users /home/liveuser

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
 }


wget https://raw.githubusercontent.com/a4uos/a4u_config/master/img/a4u.png
mv -f a4u.png /usr/share/pixmaps/a4u.png

wget https://raw.githubusercontent.com/a4uos/a4u_config/master/img/bg.jpg
mv -f bg.jpg /usr/share/backgrounds/xfce/bg.jpg

systemctl enable pacman-init.service choose-mirror.service
systemctl set-default graphical.target