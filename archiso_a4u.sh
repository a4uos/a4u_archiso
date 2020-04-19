mkdir ~/downloads
cd ~/downloads
pacman -S archiso
cp -r /usr/share/archiso/configs/releng/ archlive

mkdir ~/archlive/out/
./build.sh -v