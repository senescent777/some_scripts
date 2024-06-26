#!/bin/bash
. ./conf

echo "part= $part , dir=$dir"
cd /
sudo mount $part $dir -o rw
[ $? -eq 0 ] || exit 1
sleep 3

[ -f $dir/$archive ] && sudo cp $dir/$archive $dir/$archive.OLD
[ $? -eq 0 ] || exit 2
[ -f /tmp/archive ] && sudo cp /tmp/$archive $dir

sleep 3
sudo tar -uvpf $dir/$archive /opt/bin ~/Desktop/minimize
ls -las $dir;sleep 5
sleep 6

sudo umount $part
cd ~/Desktop/minimize
