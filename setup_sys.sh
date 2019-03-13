#!/bin/bash
# Copyright (C) 2019 Canonical
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
shopt -s -o nounset

if ! ping www.google.com -c 1 &> /dev/null ; then
	echo "Please connect to Internet"
	exit 1
fi

sudo apt update && sudo apt -y upgrade

sudo apt install -y acpica-tools vim git git-email gitk openssh-server tree \
		    meld ibus-chewing unp p7zip-full pastebinit tilix

# disable crash report / apport
sudo rm /var/crash/*
sudo sed -i -e s/^enabled\=1$/enabled\=0/ /etc/default/apport

# setup for tilix
if which tilix &> /dev/null ; then
	sudo ln -s /etc/profile.d/vte-2.91.sh /etc/profile.d/vte.sh
	wget -qO $HOME"/.config/tilix/schemes/argonaut.json" https://git.io/v7QV5
fi

# download source code and setup dependency
[ -e fwts ] || git clone git://kernel.ubuntu.com/hwe/fwts.git
[ -e acpica ] || git clone git://github.com/acpica/acpica
sudo apt -y build-dep fwts

