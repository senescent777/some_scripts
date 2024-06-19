#!/bin/sh

sudo rm -rf /run/live/medium/live/initrd.img*
sudo apt-get remove --purge --yes amd64-microcode atril* at-spi2-core coinor*
sudo apt autoremove --yes

sudo rm -rf /run/live/medium/live/initrd.img*
sudo apt-get remove --purge --yes dirmngr discover* distro-info-data 
sudo apt-get remove --purge --yes efibootmgr exfalso ftp gcr
sudo apt autoremove --yes

sudo rm -rf /run/live/medium/live/initrd.img*
sudo apt-get remove --purge --yes ghostscript gir* gdisk gpg-*
sudo apt-get remove --purge --yes gpg-agent gpgconf gpgsm gparted
sudo apt autoremove --yes

sudo rm -rf /run/live/medium/live/initrd.img*
sudo apt-get remove --purge --yes gsasl* gstreamer* gsfonts* 
sudo apt-get remove --purge --yes htop intel-microcode iucode-tool libgstreamer*
sudo apt autoremove --yes

sudo rm -rf /run/live/medium/live/initrd.img*
sudo apt-get remove --purge --yes lm-sensors lvm2 mailcap mariadb-common
sudo apt-get remove --purge --yes mokutil mysql-common openssh* orca
sudo apt autoremove --yes

sudo rm -rf /run/live/medium/live/initrd.img*
sudo apt-get remove --purge --yes os-prober po* ppp proc*
sudo apt-get remove --purge --yes ristretto screen shim* samba*
sudo apt autoremove --yes

sudo rm -rf /run/live/medium/live/initrd.img*
sudo apt-get remove --purge --yes speech* system-config* telnet tex*
sudo apt-get remove --purge --yes udisks2 uno* ure* upower
sudo apt autoremove --yes

sudo rm -rf /run/live/medium/live/initrd.img*
sudo apt-get remove --purge --yes vim* xorriso
sudo apt autoremove --yes

sudo rm -rf /run/live/medium/live/initrd.img*
sudo shred -fu /var/cache/apt/archives/*.deb
sudo shred -fu /tmp/*