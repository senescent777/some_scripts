#!/bin/bash
sudo nano /etc/apt/sources.list
sudo apt-get update
sudo apt-get reinstall git squashfs-tools gpg gpgv #vaiko gpg*
sudo apt-get reinstall genisoimage wodim 
sudo apt-get reinstall grub* #xorriso
sudo tar -cvf ${1} /var/cache/apt/archives/*.deb


#TODO:konftsdton mukaisia hmistoja tulisi luoda jos ei jo olemassa