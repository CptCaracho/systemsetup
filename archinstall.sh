#!/bin/bash

CURRENT_DIR="$(cd "$(dirname "$0")"; pwd)"

echo -e '\n\nUUID=9726d2c5-fbb0-4697-8cd4-bbe4d0f802da /mnt/nvme ext4 defaults,noatime,rw,user,uid=1000,gid=1000,x-gvfs-show 0 2' | sudo tee -a /etc/fstab > /dev/null

# Add chaotic repo
sudo pacman-key --recv-key 3056513887B78AEB --keyserver keyserver.ubuntu.com
sudo pacman-key --lsign-key 3056513887B78AEB
sudo pacman -U 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst'
sudo pacman -U 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst'
echo -e '\n\n[chaotic-aur]\nInclude = /etc/pacman.d/chaotic-mirrorlist' | sudo tee -a /etc/pacman.conf > /dev/null
yay -Syu

# Delete .config and .local etc
rm -rf $HOME/.cache/yay

cd $HOME
rm -rf \
.ssh \
Bilder \
Dokumente \
.bash_history \
.bash_profile \
.bashrc \
.fzf.bash \
.profile \
.Xauthority \
.Xresources

cd $HOME/.config
rm -rf \
BraveSoftware \
chromium \
discord \
dunst \
espanso \
espansoGUI \
evolution \
filezilla \
fish \
flameshot \
fzf \
gh \
GIMP \
Google \
google-chrome \
gpick \
Heynote \
i3 \
JetBrains \
keepassxc \
kitty \
libreoffice \
libvirt \
lsd \
"MongoDB Compass" \
nano \
navi \
neofetch \
obsidian \
Pinta \
pulse \
rclone \
resticprofile \
rofi \
simple-scan \
skypeforlinux \
Slack \
systemd \
tabby \
Thunar \
vlc \
xed \
yay \
yazi \
yt-dlp \
KeePassXCrc \
keymapper.conf \
starship.toml \
TelegramDesktoprc

cd $HOME/.local/share
rm -rf \
data \
evolution \
fish \
rofi \
systemd \
TelegramDesktop \
vlc

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
rclone \
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
