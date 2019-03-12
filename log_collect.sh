#!/bin/bash
# Copyright (C) 2015-2019 Canonical
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

RECOMMEND_TESTS="version cpufreq maxfreq msr mtrr nx virt aspm dmicheck apicedge klog oops esrt --uefitests --acpitests"
RECOMMEND_TESTS_IFV="version cpufreq maxfreq msr mtrr nx virt aspm dmicheck apicedge klog oops esrt --uefitests --acpitests --ifv"

readonly IFV_LIST=( American Byosoft INSYDE Intel Phoenix )

if ! ping www.google.com -c 1 > /dev/null ; then
	echo "Please connect to Internet"
	exit 1
fi

echo ""
echo "installing acpidump, iasl and fwts..."

if ! grep -q ppa-fwts-stable /etc/apt/sources.list /etc/apt/sources.list.d/* ; then
	sudo add-apt-repository -y ppa:firmware-testing-team/ppa-fwts-stable
	sudo apt-get update
	sudo apt-get install acpidump iasl fwts -y
fi

# create a topmost folder by date
if ! [ -z "$1" ]; then
	DATE=$1
elif ping www.google.com -c 1 > /dev/null ; then
	DATE=$(wget -qSO- --max-redirect=0 google.com 2>&1 | grep Date: | awk -F ' ' '{ printf $3 $4; }')
else
	echo "Please specify a date (ex. 01Jul):"
	read DATE
fi
[ -d $DATE ] || mkdir $DATE
cd $DATE

VENDOR=$(sudo dmidecode --string bios-vendor | awk -F ' ' '{ printf $1; }')
[ -d $VENDOR ] || mkdir $VENDOR
cd $VENDOR

PRODUCT=$(sudo dmidecode --string system-product-name | awk -F ' ' '{ printf $1; }')
if [ -d $PRODUCT ] ; then
	echo "$PRODUCT exists! Exiting..."
	exit 1
fi
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

VENDOR=$(sudo dmidecode --string bios-vendor | awk -F ' ' '{ printf $1; }')
for i in "${IFV_LIST[@]}"
do
        [ "$VENDOR" = "$i" ] && RECOMMEND_TESTS="$RECOMMEND_TESTS_IFV"
done

sudo fwts $RECOMMEND_TESTS
