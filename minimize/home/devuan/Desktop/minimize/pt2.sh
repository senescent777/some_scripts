#!/bin/sh
#lib jatqssa käyttöön?

sudo rm -rf /run/live/medium/live/initrd.img*
sudo apt-get remove --purge --yes amd64-microcode atril* at-spi2-core coinor*
sudo apt autoremove --yes

sudo rm -rf /run/live/medium/live/initrd.img*

sudo apt-get remove --purge --yes dirmngr discover* distro-info-data efibootmgr exfalso ftp gcr
sudo apt autoremove --yes

sudo rm -rf /run/live/medium/live/initrd.img*
sudo apt-get remove --purge --yes ghostscript gir* gdisk gpg-* gpgconf gpgsm gparted
sudo apt autoremove --yes

sudo rm -rf /run/live/medium/live/initrd.img*
sudo apt-get remove --purge --yes gsasl* gsfonts* gstreamer*
sudo apt autoremove --yes

sudo rm -rf /run/live/medium/live/initrd.img*
sudo apt-get remove --purge --yes htop intel-microcode
sudo apt autoremove --yes

#HUOM.240624:mawk ja mtools uutena, takas pois jos qsee
sudo rm -rf /run/live/medium/live/initrd.img*
sudo apt-get remove --purge --yes lvm2 mdadm
sudo apt autoremove --yes
sleep 6

#josko ohittaisi ," This should NOT be done unless you know exactly what you are doing!"
#sudo rm -rf /run/live/medium/live/initrd.img*
#sudo apt-get remove --purge --yes mawk
#sudo apt autoremove --yes
#sleep 6
#
#sudo rm -rf /run/live/medium/live/initrd.img*
#sudo apt-get remove --purge --yes mtools
#sudo apt autoremove --yes

sudo rm -rf /run/live/medium/live/initrd.img*
sudo apt-get remove --purge --yes mailcap mariadb-common
sudo apt autoremove --yes
sudo rm -rf /run/live/medium/live/initrd.img*

sudo apt-get remove --purge --yes mokutil mysql-common orca openssh*
sudo apt autoremove --yes
sudo rm -rf /run/live/medium/live/initrd.img*

sudo apt-get remove --purge --yes speech* system-config* telnet tex* udisks2 uno* ure* upower
sudo apt autoremove --yes

sudo rm -rf /run/live/medium/live/initrd.img*
sudo apt-get remove --purge --yes vim* xorriso xfburn
sudo apt autoremove --yes

sudo apt-get remove --purge --yes iucode-tool libgstreamer* os-prober po*
sudo apt autoremove --yes

#=================================================
#sudo apt-get remove --purge --yes proc* liikaa? jos tyytyisi procmailiin
#=================================================

#240625 näytti siltä wettä ppp tau procmail ei poistunut, kts toistuuko
sudo rm -rf /run/live/medium/live/initrd.img*
sudo apt-get remove --purge --yes ppp 
sudo apt autoremove --yes
sleep 1

sudo rm -rf /run/live/medium/live/initrd.img*
sudo apt-get remove --purge --yes ristretto
sudo apt autoremove --yes 
sleep 1

sudo apt-get remove --purge --yes screen shim* samba* 
sudo apt autoremove --yes
sleep 1

sudo rm -rf /run/live/medium/live/initrd.img*
sudo apt-get remove --purge --yes procmail
sudo apt autoremove --yes
sleep 1

sudo rm -rf /run/live/medium/live/initrd.img*
sudo apt-get remove --purge --yes squashfs-tools
sudo apt autoremove --yes
sleep 6

#uutena 250624, pois jos qsee
sudo rm -rf /run/live/medium/live/initrd.img*
sudo apt-get remove --purge --yes grub*
sudo apt autoremove --yes
sleep 6

#uutena 250624, pois jos qsee
sudo rm -rf /run/live/medium/live/initrd.img*
sudo apt-get remove --purge --yes libgsm*
sudo apt autoremove --yes
sleep 6

sudo rm -rf /run/live/medium/live/initrd.img*
sudo shred -fu /var/cache/apt/archives/*.deb
df
#mimimize-hmiston siivous kanssa?