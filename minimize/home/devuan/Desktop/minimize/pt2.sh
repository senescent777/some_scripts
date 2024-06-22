#!/bin/sh
echo "NOT YET READY FOR PRODUCTION USE"
exit

sudo rm -rf /run/live/medium/live/initrd.img*
#amd-mc+at-spi ic, coinor poistui
sudo apt-get remove --purge --yes amd64-microcode atril* at-spi2-core coinor*
sudo apt autoremove --yes

sudo rm -rf /run/live/medium/live/initrd.img*
#ao. rivi ok
sudo apt-get remove --purge --yes dirmngr discover* distro-info-data 
#ao. rivi ok
sudo apt-get remove --purge --yes efibootmgr exfalso ftp gcr

sudo apt autoremove --yes

sudo rm -rf /run/live/medium/live/initrd.img*
#seur 2 riviä ok minimoitu 
sudo apt-get remove --purge --yes ghostscript gir* gdisk gpg-*
#gpg-juttujen kanssa samalla kertaa voisi poistaa:libreoffice
sudo apt-get remove --purge --yes gpg-agent gpgconf gpgsm gparted
sudo apt autoremove --yes

sudo rm -rf /run/live/medium/live/initrd.img*
#gsasl+gstreamer+gsfonts poistui

sudo apt-get remove --purge --yes gsasl* 
sudo rm -rf /run/live/medium/live/initrd.img*
sudo apt-get remove --purge --yes gsfonts* 

sudo apt autoremove --yes
sudo apt-get remove --purge --yes gstreamer*
sudo apt autoremove --yes
#HUOM.210624:näillä main saattaa olla vielä jotain ongelmaa

#htop poistui, mikrokoodi rc , iucode ii , libgtreamer-paketteja jäi pari ii-tilaan
sudo rm -rf /run/live/medium/live/initrd.img*
sudo apt-get remove --purge --yes htop intel-microcode

sudo apt autoremove --yes
sudo rm -rf /run/live/medium/live/initrd.img*

#lms pois, mariadb, lvm2 ja mailcap ic
#The following additional packages will be installed:
#  blt libtcl8.6 libtk8.6 python3-tk tk8.6-blt2.5
#mikä aiheuttaa?

#sudo apt-get remove --purge --yes lm-sensors #löytyykö tätä enää asennetuista?

sudo apt-get remove --purge --yes lvm2 mdadm #mdadm mukaan?
sudo apt autoremove --yes

sudo rm -rf /run/live/medium/live/initrd.img*
sudo apt-get remove --purge --yes mailcap #poistuiko jo aiemmin?

sudo apt-get remove --purge --yes mariadb-common
sudo apt autoremove --yes
sudo rm -rf /run/live/medium/live/initrd.img*

#nämäkin jäivät

#shim, ristretto ja screen ainakin jäivät ii-tilaan
#mikä yrittää poistaa kerneliä?
#sudo apt autoremove --yes

sudo rm -rf /run/live/medium/live/initrd.img*

#ao. jutut poistuneet + seur rivi kanssa
sudo apt-get remove --purge --yes speech* system-config* telnet tex*
sudo apt-get remove --purge --yes udisks2 uno* ure* upower
sudo apt autoremove --yes

sudo rm -rf /run/live/medium/live/initrd.img*
sudo apt-get remove --purge --yes vim*
sudo apt autoremove --yes

#seuraavat vielä jäivät dpkg -l listaan
sudo apt-get remove --purge --yes xorriso xfburn

sudo apt autoremove --yes

sudo apt-get remove --purge --yes iucode-tool 
sudo apt-get remove --purge --yes libgstreamer*
#sudo apt autoremove --yes
sudo apt-get remove --purge --yes os-prober po*

#echo "NOT YET READY FOR PRODUCTION USE"
#exit

#=================================================
#sudo apt-get remove --purge --yes proc* liikaa? jos tyytyisi procmailiin
#=================================================
sudo rm -rf /run/live/medium/live/initrd.img*
sudo apt-get remove --purge --yes ppp ristretto screen 
sudo apt autoremove --yes
sleep 6

sudo rm -rf /run/live/medium/live/initrd.img*
sudo apt-get remove --purge --yes shim* samba*
sudo apt autoremove --yes
sleep 6

sudo rm -rf /run/live/medium/live/initrd.img*
sudo shred -fu /var/cache/apt/archives/*.deb

#sudo shred -fu /tmp/*


df