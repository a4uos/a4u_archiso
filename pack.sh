#!/bin/bash
# Сборка пакетов из AUR
read -p "Введите имя пакета: " packname
tar -xvzf $packname.tar.gz
cd $packname
makepkg -s
