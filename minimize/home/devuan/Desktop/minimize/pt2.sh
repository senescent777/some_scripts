#!/bin/bash
. ./lib

#==============================================================
#HUOM! PAKETIT procps, mtools JA mawk JÄTETTÄVÄ RAUHAAN!!!
#==============================================================

${smr} -rf /run/live/medium/live/initrd.img*
${sharpy} amd64-microcode atril* at-spi2-core coinor*
${sa} autoremove --yes

${smr} -rf /run/live/medium/live/initrd.img*

${sharpy} dirmngr discover* distro-info-data efibootmgr exfalso ftp gcr
${sa} autoremove --yes

${smr} -rf /run/live/medium/live/initrd.img*
${sharpy} ghostscript gir* gdisk gpg-* gpgconf gpgsm gparted
${sa} autoremove --yes

${smr} -rf /run/live/medium/live/initrd.img*
${sharpy} gsasl* gsfonts* gstreamer*
${sa} autoremove --yes

${smr} -rf /run/live/medium/live/initrd.img*
${sharpy} htop intel-microcode
${sa} autoremove --yes

#HUOM.240624:mawk ja mtools uutena, takas pois jos qsee
${smr} -rf /run/live/medium/live/initrd.img*
${sharpy} lvm2 mdadm
${sa} autoremove --yes
sleep 6

${smr} -rf /run/live/medium/live/initrd.img*
${sharpy} mailcap mariadb-common
${sa} autoremove --yes
${smr} -rf /run/live/medium/live/initrd.img*

${sharpy} mokutil mysql-common orca openssh*
${sa} autoremove --yes
${smr} -rf /run/live/medium/live/initrd.img*

${sharpy} speech* system-config* telnet tex* udisks2 uno* ure* upower
${sa} autoremove --yes

${smr} -rf /run/live/medium/live/initrd.img*
${sharpy} vim* xorriso xfburn
${sa} autoremove --yes

${sharpy} iucode-tool libgstreamer* os-prober po*
${sa} autoremove --yes

#240625 näytti siltä wettä ppp tau procmail ei poistunut, kts toistuuko
${smr} -rf /run/live/medium/live/initrd.img*
${sharpy} ppp 
${sa} autoremove --yes
sleep 1

${smr} -rf /run/live/medium/live/initrd.img*
${sharpy} ristretto
${sa} autoremove --yes 
sleep 1

${sharpy} screen shim* samba* 
${sa} autoremove --yes
sleep 1

${smr} -rf /run/live/medium/live/initrd.img*
${sharpy} procmail
${sa} autoremove --yes
sleep 1

${smr} -rf /run/live/medium/live/initrd.img*
${sharpy} squashfs-tools
${sa} autoremove --yes
sleep 6

#uutena 250624, pois jos qsee
${smr} -rf /run/live/medium/live/initrd.img*
${sharpy} grub*
${sa} autoremove --yes
sleep 6

#uutena 250624, pois jos qsee
${smr} -rf /run/live/medium/live/initrd.img*
${sharpy} libgsm*
${sa} autoremove --yes
sleep 6

${smr} -rf /run/live/medium/live/initrd.img*
sudo shred -fu /var/cache/apt/archives/*.deb
df
#mimimize-hmiston siivous kanssa?