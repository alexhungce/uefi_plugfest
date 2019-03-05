#!/bin/bash
shopt -s -o nounset

sudo apt update && sudo apt -y upgrade

sudo apt install -y acpica-tools vim git git-email gitk openssh-server tree \
		    meld ibus-chewing unp p7zip-full pastebinit tilix

# disable crash report / apport
sudo rm /var/crash/*
sudo sed -i -e s/^enabled\=1$/enabled\=0/ /etc/default/apport

# setup for tilix
if which tilix > /dev/null ; then
	sudo ln -s /etc/profile.d/vte-2.91.sh /etc/profile.d/vte.sh
	wget -qO $HOME"/.config/tilix/schemes/argonaut.json" https://git.io/v7QV5
fi

# download source code and setup dependency
[ -e fwts ] || git clone git://kernel.ubuntu.com/hwe/fwts.git
[ -e acpica ] || git clone git://github.com/acpica/acpica
sudo apt -y build-dep fwts

