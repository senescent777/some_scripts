#!/bin/bash

#HUOM. ao. rivillä viimeisessä syystä vain core
sudo apt-get remove --purge amd64-microcode iucode-tool arch-test  at-spi2-core

sudo apt-get remove --purge atril* coinor* #cryptsetup debootstrap
sudo apt-get remove --purge dmidecode discover* dirmngr #tuleeekohan viimeisestä omngelma?
sudo apt-get remove --purge doc-debian docutils* 
sudo apt-get remove --purge efibootmgr exfalso ftp
sudo apt autoremove --yes

