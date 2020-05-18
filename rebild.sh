#!/bin/bash
sudo rm -rf archlive
sudo cp -r /usr/share/archiso/configs/releng/ archlive
sudo cp -rf ~/Загрузки/archlive ~/
mkdir ~/archlive/out/
cd ~/archlive
sudo ./build.sh -v
