#!/bin/bash
sudo nano /etc/apt/sources.list
sudo apt-get update
sudo apt-get reinstall git squashfs-tools gpg gpgv 
sudo apt-get reinstall genisoimage #xorriso
sudo tar -cvf ${1} /var/cache/apt/archives/*.deb
