#!/bin/bash

#HUOM. ao. rivillä viimeisessä syystä vain core
sudo apt-get remove --purge amd64-microcode iucode-tool arch-test at-spi2-core bubblewrap

sudo apt-get remove --purge atril* coinor* #cryptsetup debootstrap
sudo apt-get remove --purge dmidecode discover* dirmngr #tuleeekohan viimeisestä omngelma?
sudo apt-get remove --purge doc-debian docutils* 
sudo apt-get remove --purge efibootmgr exfalso ftp
sudo apt autoremove --yes

sudo apt-get remove --purge fdisk ftp gdisk gcr
sudo apt autoremove --yes

#gnupg poisto täs kohtaa hyvä idea? vai veikö dirmngr mukanaan jo=
sudo apt-get remove --purge ghostscript gir* gnupg*
#gnome-* poisto veisi myös: task-desktop task-xfce-desktop

#gpg* kanssa: The following packages have unmet dependencies:
# apt : Depends: gpgv but it is not going to be installed or
#                gpgv2 but it is not going to be installed or
#                gpgv1 but it is not going to be installed

sudo apt-get remove --purge gpg-* gpgconf gpgsm gsasl-common
#HUOM. grub* poisto voi johtaa shim-pakettien päivitykseen
sudo apt-get remove --purge shim* grub* 

#gsettings* voi viedä paljon paketteja mukanaan
sudo apt-get remove --purge gsfonts gstreamer*
sudo apt autoremove --yes