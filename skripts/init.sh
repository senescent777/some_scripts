#!/bin/bash
sudo nano /etc/apt/sources.list
sudo apt-get update

sudo apt-get reinstall git squashfs-tools gpg gpgv #vaiko gpg*
sudo apt-get reinstall genisoimage wodim 

#https://pkginfo.devuan.org/cgi-bin/package-query.html?c=package&q=grub-common=2.06-13+deb12u1
sudo apt-get reinstall grub-common xorriso #jälkimminen toistaiseksi mukana
sudo tar -cvf ${1} /var/cache/apt/archives/*.deb #tai sit cp

chmod a+x ./*.sh


#TODO:konftsdton mukaisia hmistoja tulisi luoda jos ei jo olemassa?

