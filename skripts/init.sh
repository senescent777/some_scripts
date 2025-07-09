#!/bin/bash
sudo nano /etc/apt/sources.list
sudo apt-get update
sudo apt-get reinstall git squashfs-tools squashfs-utils gpg gpgv #vaiko gpg*
sudo apt-get reinstall genisoimage wodim grub* #xorriso
sudo tar -cvf ${1} /var/cache/apt/archives/*.deb
