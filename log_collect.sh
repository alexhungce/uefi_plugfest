#!/bin/bash
# Copyright (C) 2010-2016 Canonical
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

RECOMMEND_TESTS="version cpufreq maxfreq msr mtrr nx virt aspm dmicheck apicedge klog oops esrt --uefitests --acpitests --log-level=medium"

if ! ping www.google.com -c 1 > /dev/null ; then
	echo "Please connect to Internet"
	exit 1
fi

echo ""
echo "installing acpidump, iasl and fwts..."

sudo add-apt-repository -y ppa:firmware-testing-team/ppa-fwts-stable
sudo apt-get update
sudo apt-get install acpidump iasl fwts -y

DATE=$(wget -qSO- --max-redirect=0 google.com 2>&1 | grep Date: | awk -F ' ' '{ printf $3 $4; }') 
mkdir $DATE
cd $DATE

VENDOR=$(sudo dmidecode --string bios-vendor | awk -F ' ' '{ printf $1; }')
mkdir $VENDOR
cd $VENDOR

PRODUCT=$(sudo dmidecode --string system-product-name | awk -F ' ' '{ printf $1; }')
mkdir $PRODUCT
cd $PRODUCT

echo ""
echo "collecting logs..."

sudo dmesg > dmesg.log
sudo acpidump > acpi.log
sudo dmidecode > dmi.log
sudo lspci -vvnn > lspci_vvnn.log
sudo lspci -xxx > lspci_xxx.log


echo ""
echo "running fwts tests..."
sudo fwts $RECOMMEND_TESTS
