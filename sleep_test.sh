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

if [ $# -ne 1 ] ; then
	echo "Usage: sleep_test.sh s3|s2idle"
	exit 1
fi

# run specific tests from user inputs
if [ $1 == "s3" ] ; then
	SLEEP=deep
elif [ $1 == "s2idle" ] ; then
	SLEEP=s2idle
else
	echo "invalid arguments!"
	exit 1
fi

echo $SLEEP | sudo tee /sys/power/mem_sleep
cat /sys/power/mem_sleep
systemctl suspend
