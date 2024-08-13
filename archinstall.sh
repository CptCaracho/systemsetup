#!/bin/bash

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

# Install all packages
yay -Syu --needed --noconfirm \
autotiling \
bash-language-server \
bat \
brave-bin \
brother-dcpj572dw \
buku \
cargo \
cups \
deno \
discord \
distrobox \
dmenu \
docker \
docker-compose \
espanso-x11 \
evolution \
fd \
feh \
filezilla \
firefox-i18n-de \
fish \
fisher \
flameshot \
github-cli \
gnome-disk-utility \
gpick \
heynote-bin \
jetbrains-toolbox \
jq \
just \
keepassxc \
keymapper \
kitty \
lib32-gcc-libs \
libreoffice-still \
libguestfs \
libvirt \
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
podman \
python-pipenv \
python-pipx \
qemu-emulators-full \
qemu-full \
qmk \
restic \
rofi \
simple-scan \
simplescreenrecorder \
skypeforlinux-bin \
slack-desktop \
starship \
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

# Rclone $HOME
sudo rm -rf $HOME
rclone sync -vv /mnt/nvme/backup/rclone $HOME

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

sudo reboot
