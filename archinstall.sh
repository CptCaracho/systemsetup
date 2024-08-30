#!/bin/bash

set -v

CURRENT_DIR="$(cd "$(dirname "$0")"; pwd)"

if [ ! -d "/mnt/nvme" ]; then
	sudo mkdir -p /mnt/nvme
	echo -e 'UUID=9726d2c5-fbb0-4697-8cd4-bbe4d0f802da /mnt/nvme ext4 defaults,noatime,rw,user,x-gvfs-show 0 2' | sudo tee -a /etc/fstab > /dev/null &&
	sleep 2
	sudo systemctl daemon-reload &&
	sleep 2
	sudo mount -a &&
	sleep 2

	# Add chaotic repo
	sudo pacman-key --recv-key 3056513887B78AEB --keyserver keyserver.ubuntu.com
	sudo pacman-key --lsign-key 3056513887B78AEB
	sudo pacman -U --noconfirm 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst'
	sudo pacman -U --noconfirm 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst'
	echo -e '\n\n[chaotic-aur]\nInclude = /etc/pacman.d/chaotic-mirrorlist' | sudo tee -a /etc/pacman.conf > /dev/null
	yay -Syu
fi

# Update mirrorlist
sudo cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.backup
sudo reflector --verbose --country DE,FR,DK,BE --protocol https --sort rate --latest 30 --download-timeout 20 --save /etc/pacman.d/mirrorlist

# install rclone and setup $HOME
sudo rm -rf $HOME/**
sudo pacman -Syu --noconfirm rclone
rclone sync -v /mnt/nvme/backup/rclone $HOME

# Install all packages
yay -Syu --needed --noconfirm \
autotiling \
bash-language-server \
bat \
brave-bin \
breeze \
breeze-gtk \
brother-dcpj572dw \
brscan4 \
buku \
buttercup-desktop \
cargo \
cups \
davfs2 \
deno \
discord \
distrobox \
dmenu \
docker \
docker-compose \
espanso-x11 \
evince \
evolution \
fd \
feh \
filezilla \
firefox-i18n-de \
fish \
fisher \
flameshot \
gimp \
github-cli \
gnome-disk-utility \
gpick \
gvfs \
gvfs-dnssd \
heynote-bin \
jetbrains-toolbox \
jgmenu \
jq \
just \
keepassxc \
keymapper \
kitty \
lib32-gcc-libs \
libreoffice-still \
libguestfs \
libvirt \
lightdm-settings \
lsd \
luckybackup \
man-db \
man-pages \
megasync-bin \
mongodb-bin \
mongodb-compass \
mullvad-vpn-bin \
nano-syntax-highlighting \
navi \
neofetch \
neovim \
npm \
noto-color-emoji-fontconfig-no-binding \
obsidian \
oil-search \
otf-monaspace-nerd \
picom \
pinta \
podman \
python-pipenv \
python-pipx \
qemu-emulators-full \
qemu-full \
qmk \
restic \
resticprofile \
ristretto \
rofi \
simple-scan \
simplescreenrecorder \
skypeforlinux-bin \
slack-desktop \
starship \
syncthing \
tabby \
telegram-desktop \
unrar \
unzip \
virt-manager \
virt-viewer \
vlc \
watchexec \
wmctrl \
xbindkeys \
xclip \
xdg-utils \
xdotool \
xorg \
yad \
yazi \
yt-dlp \
zellij \
zenity

curl -s https://raw.githubusercontent.com/jhuckaby/Cronicle/master/bin/install.js | sudo node
sudo /opt/cronicle/bin/control.sh setup
sudo /opt/cronicle/bin/control.sh start

# enable services
sudo systemctl enable --now docker.service
sudo systemctl enable --now keymapperd.service
sudo systemctl enable --now cups.service

# Add user excessivemedia to group docker
sudo usermod -aG docker $USER

# Install from pip systemwide
sudo rm -rf /usr/lib/python3.12/EXTERNALLY-MANAGED

pip install buku
pip install "buku[server]"
pip install questionary

find $HOME/.scripts/ -type f -exec chmod +x {} +
find $HOME/.config/i3/scripts/ -type f -exec chmod +x {} +

# Register espanso as a systemd service (required only once)
espanso service register
espanso start

#sudo reboot
