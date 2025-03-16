#!/bin/bash

d=$(dirname $0)
[ -s ${d}/conf ] && . ${d}/conf
. ~/Desktop/minimize/common_lib.sh
[ -s ${d}/lib.sh ] && . ${d}/lib.sh

${fib}
g=$(date +%F)

if [ $# -gt 0 ] ; then  
	if [ "${1}" == "-v" ] ; then
		debug=1
	fi
fi

#HUOM.120325:mitäköhän tämän kanssa tekee? ehkä oltava distro-kohtainen

#==============================================================
#HUOM! PAKETIT procps, mtools JA mawk JÄTETTÄVÄ RAUHAAN!!!
#==============================================================

${smr} -rf /run/live/medium/live/initrd.img*
${odio} apt --fix-broken install #${fib}
${sharpy} amd64-microcode atril* at-spi2-core coinor*
${asy} 

${smr} -rf /run/live/medium/live/initrd.img*
${odio} apt --fix-broken install #${fib}
${sharpy} dirmngr discover* distro-info-data efibootmgr exfalso ftp gcr
${asy}

${odio} which dhclient; ${odio} which ifup; csleep 3

${smr} -rf /run/live/medium/live/initrd.img* #{lftr}
${odio} apt --fix-broken install  #${fib}
${sharpy} ghostscript gir* gdisk gpg-* gpgconf gpgsm gparted
${asy}
${odio} which dhclient; ${odio} which ifup; csleep 3

${smr} -rf /run/live/medium/live/initrd.img*
${odio} apt --fix-broken install #${fib}
${sharpy} gsasl* gsfonts* gstreamer*
${asy}
${odio} which dhclient; ${odio} which ifup; csleep 3 #tulostuksetkin dbg taakse?

${smr} -rf /run/live/medium/live/initrd.img* #{lftr}
${odio} apt --fix-broken install #${fib}
${sharpy} htop intel-microcode
${asy}
${odio} which dhclient; ${odio} which ifup; csleep 3

${smr} -rf /run/live/medium/live/initrd.img* #lftr
${sharpy} lvm2 mdadm
${asy}
csleep 6
${odio} which dhclient; ${odio} which ifup; csleep 3

${smr} -rf /run/live/medium/live/initrd.img*
${sharpy} mailcap mariadb-common
${asy}
${smr} -rf /run/live/medium/live/initrd.img* #lftr
${odio} which dhclient; ${odio} which ifup; csleep 3
${odio} apt --fix-broken install #fib

${sharpy} mokutil mysql-common orca openssh*
${asy}
${smr} -rf /run/live/medium/live/initrd.img* #lftr

${sharpy} speech* system-config* telnet tex* udisks2 uno* ure* upower
${sa} autoremove --yes
${odio} which dhclient; ${odio} which ifup; csleep 3
${odio} apt --fix-broken install #fub

${smr} -rf /run/live/medium/live/initrd.img* #lftr
${sharpy} vim* xorriso xfburn
${asy}

${sharpy} iucode-tool libgstreamer* os-prober po*
${asy}

${odio} which dhclient; ${odio} which ifup; csleep 3
${odio} apt --fix-broken install #fib

${smr} -rf /run/live/medium/live/initrd.img* #lftr
${sharpy} ppp 
${asy}
csleep 1

${smr} -rf /run/live/medium/live/initrd.img* #lftr
${sharpy} ristretto
${asy}
csleep 1

${sharpy} screen shim* samba* 
${asy}
csleep 1

${smr} -rf /run/live/medium/live/initrd.img* #lftr
${sharpy} procmail
${asy}
csleep 1

${smr} -rf /run/live/medium/live/initrd.img* #lftr
${sharpy} squashfs-tools
${asy}
csleep 6

${smr} -rf /run/live/medium/live/initrd.img* #lftr
${sharpy} grub*
${asy}
csleep 6

${smr} -rf /run/live/medium/live/initrd.img* #lftr
${sharpy} libgsm*
${asy} 
csleep 6

${smr} -rf /run/live/medium/live/initrd.img* #lftr
${odio} shred -fu /var/cache/apt/archives/*.deb
${odio} shred -fu ${d}/*.deb 
${odio} shred -fu /tmp/*.tar 
${odio} rm -rf /tmp/tmp.* #smr

df
#mimimize-hmiston siivous kanssa?
${odio} which dhclient; ${odio} which ifup; csleep 3