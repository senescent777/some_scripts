#!/bin/bash
. ./lib

#==============================================================
#HUOM! PAKETIT procps, mtools JA mawk JÄTETTÄVÄ RAUHAAN!!!
#==============================================================

${smr} -rf /run/live/medium/live/initrd.img*
${sharpy} amd64-microcode atril* at-spi2-core coinor*
${asy} 

${smr} -rf /run/live/medium/live/initrd.img*

${sharpy} dirmngr discover* distro-info-data efibootmgr exfalso ftp gcr
${asy}

${smr} -rf /run/live/medium/live/initrd.img*
${sharpy} ghostscript gir* gdisk gpg-* gpgconf gpgsm gparted
${asy}

${smr} -rf /run/live/medium/live/initrd.img*
${sharpy} gsasl* gsfonts* gstreamer*
${asy}

${smr} -rf /run/live/medium/live/initrd.img*
${sharpy} htop intel-microcode
${asy}

${smr} -rf /run/live/medium/live/initrd.img*
${sharpy} lvm2 mdadm
${asy}
sleep 6

${smr} -rf /run/live/medium/live/initrd.img*
${sharpy} mailcap mariadb-common
${asy}
${smr} -rf /run/live/medium/live/initrd.img*

${sharpy} mokutil mysql-common orca openssh*
${asy}
${smr} -rf /run/live/medium/live/initrd.img*

${sharpy} speech* system-config* telnet tex* udisks2 uno* ure* upower
${sa} autoremove --yes

${smr} -rf /run/live/medium/live/initrd.img*
${sharpy} vim* xorriso xfburn
${asy}

${sharpy} iucode-tool libgstreamer* os-prober po*
${asy}

${smr} -rf /run/live/medium/live/initrd.img*
${sharpy} ppp 
${asy}
sleep 1

${smr} -rf /run/live/medium/live/initrd.img*
${sharpy} ristretto
${asy}
sleep 1

${sharpy} screen shim* samba* 
${asy}
sleep 1

${smr} -rf /run/live/medium/live/initrd.img*
${sharpy} procmail
${asy}
sleep 1

${smr} -rf /run/live/medium/live/initrd.img*
${sharpy} squashfs-tools
${asy}
sleep 6

${smr} -rf /run/live/medium/live/initrd.img*
${sharpy} grub*
${asy}
sleep 6

${smr} -rf /run/live/medium/live/initrd.img*
${sharpy} libgsm*
${asy} 
sleep 6

${smr} -rf /run/live/medium/live/initrd.img*
sudo shred -fu /var/cache/apt/archives/*.deb
df
#mimimize-hmiston siivous kanssa?