#!/bin/bash

set -e -u

localeGen() {
    sed -i 's/#\(en_US\.UTF-8\)/\1/' /etc/locale.gen
    sed -i "s/#\(ru_RU\.UTF-8\)/\1/" /etc/locale.gen
    locale-gen
}

setTimeZoneAndClock() {
    ln -sf /usr/share/zoneinfo/UTC /etc/localtime
    hwclock --systohc --utc
}

editOrCreateConfigFiles() {
    # Locale
    echo "LANG=ru_RU.UTF-8" > /etc/locale.conf
    echo "LC_COLLATE=C" >> /etc/locale.conf

    # Vconsole
    echo "KEYMAP=ru" > /etc/vconsole.conf
    echo "FONT=cyr-sun16" >> /etc/vconsole.conf

    # Hostname
    echo "liveuser" > /etc/hostname

    sed -i "s/#Server/Server/g" /etc/pacman.d/mirrorlist
    sed -i 's/#\(Storage=\)auto/\1volatile/' /etc/systemd/journald.conf
}

fixPermissions() {
    #add missing /media directory
    mkdir -p /media
    chmod 755 -R /media

    #fix permissions
    chown root:root /
    chown root:root /etc
    chown root:root /etc/default
    chown root:root /usr
    chmod 755 /etc

}

configRootUser() {
    usermod -s /usr/bin/zsh root
    chmod 700 /root
}

setDefaults() {
    export _BROWSER=firefox
    echo "BROWSER=/usr/bin/${_BROWSER}" >> /etc/environment
    echo "BROWSER=/usr/bin/${_BROWSER}" >> /etc/profile

    export _EDITOR=nano
    echo "EDITOR=${_EDITOR}" >> /etc/environment
    echo "EDITOR=${_EDITOR}" >> /etc/profile

    echo "QT_QPA_PLATFORMTHEME=qt5ct" >> /etc/environment
}

fontFix() {
    rm -rf /etc/fonts/conf.d/10-scale-bitmap-fonts.conf
}

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
 }

# Удаление тем по умолчанию
# sudo rm -rf /usr/share/themes/*
sudo rm -rf /usr/share/backgrounds/

fixWifi() {
    su -c 'echo "" >> /etc/NetworkManager/NetworkManager.conf'
    su -c 'echo "[device]" >> /etc/NetworkManager/NetworkManager.conf'
    su -c 'echo "wifi.scan-rand-mac-address=no" >> /etc/NetworkManager/NetworkManager.conf'
}

systemctl enable NetworkManager.service
systemctl set-default graphical.target

localeGen
setTimeZoneAndClock
editOrCreateConfigFiles
fixPermissions
configRootUser
setDefaults
fontFix
fixWifi

sudo pacman -Syu