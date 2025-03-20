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

#onkohan hyvä näin?
if [ ${removepkgs} -eq 1 ] ; then
	dqb "kö"
else
	${sharpy} libblu* network* libcupsfilters* libgphoto* libopts25
	${sharpy} avahi* blu* cups* exim*
	${sharpy} rpc* nfs* 
	${sharpy} modem* wireless* wpa* iw lm-sensors
fi

#==============================================================
#HUOM! PAKETIT procps, mtools JA mawk JÄTETTÄVÄ RAUHAAN!!!
#==============================================================

${lftr}
${fib}
${sharpy} amd64-microcode atril* at-spi2-core coinor*
${asy} 

${lftr}
${fib}
${sharpy} dirmngr discover* distro-info-data efibootmgr exfalso ftp gcr
${asy}

${odio} which dhclient; ${odio} which ifup; csleep 3

${lftr}
${fib}
${sharpy} ghostscript gir* gdisk gpg-* gpgconf gpgsm gparted
${asy}
${odio} which dhclient; ${odio} which ifup; csleep 3

${lftr}
${fib}
${sharpy} gsasl* gsfonts* gstreamer*
${asy}
${odio} which dhclient; ${odio} which ifup; csleep 3 #tulostuksetkin dbg taakse?

${lftr}
${fib}
${sharpy} htop 
${asy}
${odio} which dhclient; ${odio} which ifup; csleep 3
csleep 5

${lftr}
${fib}
${sharpy} intel-microcode
${asy}
${odio} which dhclient; ${odio} which ifup; csleep 3
csleep 5

${lftr}
${sharpy} mdadm 
${asy}
csleep 6
${odio} which dhclient; ${odio} which ifup; csleep 3
csleep 5

${lftr}
${sharpy} lvm2
${asy}
csleep 6
${odio} which dhclient; ${odio} which ifup; csleep 3
csleep 5

${lftr}
${sharpy} mailcap mariadb-common
${asy}
${lftr}
${odio} which dhclient; ${odio} which ifup; csleep 3
${fib}

${sharpy} mokutil mysql-common orca openssh*
${asy}
${lftr}

${sharpy} speech* system-config* telnet tex* udisks2 uno* ure* upower
${sa} autoremove --yes
${odio} which dhclient; ${odio} which ifup; csleep 3
${fib}

${lftr}
${sharpy} vim* xorriso xfburn
${asy}

${sharpy} iucode-tool libgstreamer* os-prober po*
${asy}

${odio} which dhclient; ${odio} which ifup; csleep 3
${fib}

${lftr}
${sharpy} ppp 
${asy}
csleep 1

${lftr}
${sharpy} ristretto
${asy}
csleep 1

${sharpy} screen shim* samba* 
${asy}
csleep 1

${lftr}
${sharpy} procmail
${asy}
csleep 1

${lftr}
${sharpy} squashfs-tools
${asy}
csleep 6

${lftr}
${sharpy} grub*
${asy}
csleep 6

${lftr}
${sharpy} libgsm*
${asy} 
csleep 6

${lftr}
${NKVD} /var/cache/apt/archives/*.deb
${NKVD} ${d}/*.deb 
${NKVD} /tmp/*.tar 
${smr} -rf /tmp/tmp.*
${smr} /usr/share/doc #rikkookohan jotain nykyään?
df
#mimimize-hmiston siivous kanssa?
${odio} which dhclient; ${odio} which ifup; csleep 3