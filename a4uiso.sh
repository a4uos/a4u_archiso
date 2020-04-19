mkdir ~/downloads
cd ~/downloads
pacman -S archiso
cp -r /usr/share/archiso/configs/releng/ archlive
wget https://github.com/a4uos/a4u_archiso/raw/master/archlive.tar.gz
sudo tar -xzf archlive.tar.gz -C ~/
mkdir ~/archlive/out/
./build.sh -v
