#!/bin/bash

part=/dev/sdax
dir=/mnt/y
archive=arhcive.tar

cd /
sudo mount $part $dir -o ro
sudo tar -xvpf $dir/$archive
sudo umount $part
cd ~/Desktop/minimize

#HUOM. tämän olisi kuvakkeen kanssa tarkoitus mennä jatkossa filesystem.squashfs sisälle
#TODO:make_tar:ista gpgtar-jutut
#TODO:https://github.com/senescent777/some_scripts/tree/senescent777-alt-version/skripts/export ja https://github.com/senescent777/some_scripts/tree/senescent777-alt-version/lib/export soveötaen
