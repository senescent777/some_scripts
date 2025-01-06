#!/bin/bash

#HUOM. ao. rivillä viimeisessä syystä vain core
sudo apt-get remove --purge amd64-microcode iucode-tool arch-test at-spi2-core bubblewrap

sudo apt-get remove --purge atril* coinor* cryptsetup debootstrap
sudo apt-get remove --purge dmidecode discover* dirmngr #tuleeekohan viimeisestä omngelma?
sudo apt-get remove --purge doc-debian docutils* 
sudo apt-get remove --purge efibootmgr exfalso 
sudo apt autoremove --yes

sudo apt-get remove --purge fdisk ftp*
sudo apt-get remove --purge gdisk gcr
sudo apt autoremove --yes

#gnupg poisto täs kohtaa hyvä idea? vai veikö dirmngr mukanaan jo=
sudo apt-get remove --purge ghostscript gir* gnupg*
sudo apt-get remove --purge gpg-* gpgconf gpgsm gsasl-common
sudo apt-get remove --purge shim* grub* 
sudo apt-get remove --purge gsfonts gstreamer*
sudo apt autoremove --yes


#gnome-* poisto veisi myös: task-desktop task-xfce-desktop

#gpg* kanssa: The following packages have unmet dependencies:
# apt : Depends: gpgv but it is not going to be installed or
#                gpgv2 but it is not going to be installed or
#                gpgv1 but it is not going to be installed

#HUOM. grub* poisto voi johtaa shim-pakettien päivitykseen

#gsettings* voi viedä paljon paketteja mukanaan


sudo apt-get remove --purge intel-microcode iucode-tool
sudo apt-get remove --purge htop inetutils-telnet
sudo apt autoremove --yes

#lib-paketteihin ei yleisessä tapakauksessa kande koskea eikä live-
#... libgstreamerja libgsm uutena (060125)
sudo apt-get remove --purge libpoppler* libuno* libreoffice* libgsm* libgstreamer*

#HUOM! PAKETIT procps, mtools JA mawk JÄTETTÄVÄ RAUHAAN!!!
sudo apt-get remove --purge lvm2 mdadm  
sudo apt-get remove --purge mailcap mlocate
sudo apt-get remove --purge mokutil mariadb-common mysql-common
sudo apt-get remove --purge netcat-traditional openssh*
sudo apt-get remove --purge os-prober #orca saattaa poistua jo aiemmina
sudo apt autoremove --yes

sudo apt-get remove --purge ppp procmail ristretto 
sudo apt-get remove --purge screen po* refracta*
#samba poistunee jo aiemmin?
sudo apt-get remove --purge squashfs-tools samba* system-config*
sudo apt autoremove --yes

sudo apt-get remove --purge telnet 
sudo apt-get remove --purge tex*
sudo apt autoremove --yes

sudo apt-get remove --purge uno* ure*
sudo apt-get remove --purge upower vim* # udisks* saattaa poistua jo aiemmin
sudo apt autoremove --yes

sudo apt-get remove --purge xorriso xfburn
sudo apt autoremove --yes

#whack xfce so that the ui is reset
sudo pkill --signal 9 xfce*


