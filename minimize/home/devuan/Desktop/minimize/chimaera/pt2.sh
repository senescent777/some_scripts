#!/bin/bash
#. ./lib
d=$(dirname $0)
debug=0

[ -s ${d}/lib.sh ] && . ${d}/lib.sh
${fib}
g=$(date +%F)

if [ $# -gt 0 ] ; then  
	if [ "${1}" == "-v" ] ; then
		debug=1
	fi
fi


#==============================================================
#HUOM! PAKETIT procps, mtools JA mawk JÄTETTÄVÄ RAUHAAN!!!
#==============================================================

${smr} -rf /run/live/medium/live/initrd.img*
sudo apt --fix-broken install
${sharpy} amd64-microcode atril* at-spi2-core coinor*
${asy} 

${smr} -rf /run/live/medium/live/initrd.img*
sudo apt --fix-broken install
${sharpy} dirmngr discover* distro-info-data efibootmgr exfalso ftp gcr
${asy}

sudo which dhclient; sudo which ifup; sleep 3

${smr} -rf /run/live/medium/live/initrd.img*
sudo apt --fix-broken install
${sharpy} ghostscript gir* gdisk gpg-* gpgconf gpgsm gparted
${asy}
sudo which dhclient; sudo which ifup; sleep 3

${smr} -rf /run/live/medium/live/initrd.img*
sudo apt --fix-broken install
${sharpy} gsasl* gsfonts* gstreamer*
${asy}
sudo which dhclient; sudo which ifup; sleep 3


${smr} -rf /run/live/medium/live/initrd.img*
sudo apt --fix-broken install
${sharpy} htop intel-microcode
${asy}
sudo which dhclient; sudo which ifup; sleep 3

${smr} -rf /run/live/medium/live/initrd.img*
${sharpy} lvm2 mdadm
${asy}
sleep 6
sudo which dhclient; sudo which ifup; sleep 3


${smr} -rf /run/live/medium/live/initrd.img*
${sharpy} mailcap mariadb-common
${asy}
${smr} -rf /run/live/medium/live/initrd.img*
sudo which dhclient; sudo which ifup; sleep 3
sudo apt --fix-broken install

${sharpy} mokutil mysql-common orca openssh*
${asy}
${smr} -rf /run/live/medium/live/initrd.img*

${sharpy} speech* system-config* telnet tex* udisks2 uno* ure* upower
${sa} autoremove --yes
sudo which dhclient; sudo which ifup; sleep 3
sudo apt --fix-broken install


${smr} -rf /run/live/medium/live/initrd.img*
${sharpy} vim* xorriso xfburn
${asy}

${sharpy} iucode-tool libgstreamer* os-prober po*
${asy}

sudo which dhclient; sudo which ifup; sleep 3
sudo apt --fix-broken install

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
sudo which dhclient; sudo which ifup; sleep 3