mkdir ~/downloads
cd ~/downloads
sudo pacman -S archiso
sudo cp -r /usr/share/archiso/configs/releng/ archlive
wget https://github.com/a4uos/a4u_archiso/raw/master/archlive.tar.gz
tar -xzf archlive.tar.gz -C ~/
sudo mkdir ~/archlive/out/
sudo ./build.sh -v
