#!/bin/bash
. ./lib

#==============================================================
#HUOM! PAKETIT procps, mtools JA mawk JÄTETTÄVÄ RAUHAAN!!!
#==============================================================

${smr} -rf /run/live/medium/live/initrd.img*
${sharpy} amd64-microcode atril* at-spi2-core coinor*
sudo apt autoremove --yes

${smr} -rf /run/live/medium/live/initrd.img*

${sharpy} dirmngr discover* distro-info-data efibootmgr exfalso ftp gcr
sudo apt autoremove --yes

${smr} -rf /run/live/medium/live/initrd.img*
${sharpy} ghostscript gir* gdisk gpg-* gpgconf gpgsm gparted
sudo apt autoremove --yes

${smr} -rf /run/live/medium/live/initrd.img*
${sharpy} gsasl* gsfonts* gstreamer*
sudo apt autoremove --yes

${smr} -rf /run/live/medium/live/initrd.img*
${sharpy} htop intel-microcode
sudo apt autoremove --yes

#HUOM.240624:mawk ja mtools uutena, takas pois jos qsee
${smr} -rf /run/live/medium/live/initrd.img*
${sharpy} lvm2 mdadm
sudo apt autoremove --yes
sleep 6

${smr} -rf /run/live/medium/live/initrd.img*
${sharpy} mailcap mariadb-common
sudo apt autoremove --yes
${smr} -rf /run/live/medium/live/initrd.img*

${sharpy} mokutil mysql-common orca openssh*
sudo apt autoremove --yes
${smr} -rf /run/live/medium/live/initrd.img*

${sharpy} speech* system-config* telnet tex* udisks2 uno* ure* upower
sudo apt autoremove --yes

${smr} -rf /run/live/medium/live/initrd.img*
${sharpy} vim* xorriso xfburn
sudo apt autoremove --yes

${sharpy} iucode-tool libgstreamer* os-prober po*
sudo apt autoremove --yes

#240625 näytti siltä wettä ppp tau procmail ei poistunut, kts toistuuko
${smr} -rf /run/live/medium/live/initrd.img*
${sharpy} ppp 
sudo apt autoremove --yes
sleep 1

${smr} -rf /run/live/medium/live/initrd.img*
${sharpy} ristretto
sudo apt autoremove --yes 
sleep 1

${sharpy} screen shim* samba* 
sudo apt autoremove --yes
sleep 1

${smr} -rf /run/live/medium/live/initrd.img*
${sharpy} procmail
sudo apt autoremove --yes
sleep 1

${smr} -rf /run/live/medium/live/initrd.img*
${sharpy} squashfs-tools
sudo apt autoremove --yes
sleep 6

#uutena 250624, pois jos qsee
${smr} -rf /run/live/medium/live/initrd.img*
${sharpy} grub*
sudo apt autoremove --yes
sleep 6

#uutena 250624, pois jos qsee
${smr} -rf /run/live/medium/live/initrd.img*
${sharpy} libgsm*
sudo apt autoremove --yes
sleep 6

${smr} -rf /run/live/medium/live/initrd.img*
sudo shred -fu /var/cache/apt/archives/*.deb
df
#mimimize-hmiston siivous kanssa?