#!/bin/bash
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

#[ ${debug} -eq 1 ] && ${spd} > ${d}/pkgs-${g}.txt.1
#[ ${debug} -eq 1 ] && ${scm} a-wx ${d}/pkgs*
#
#for f in $(find ~/Desktop/minimize/ -name '*.txt') ; do ${scm} a-wx ${f} ; done
#for f in $(find ~/Desktop/minimize/ -name '*.conf') ; do ${scm} a-wx ${f} ; done
#for f in $(find ~/Desktop/minimize/ -name 'conf') ; do ${scm} a-wx ${f} ; done
#csleep 5

dqb "a-e"
csleep 5

#HUOM. ao. rivillä viimeisessä syystä vain core
${sharpy} amd64-microcode iucode-tool arch-test at-spi2-core bubblewrap

${sharpy} atril* coinor* cryptsetup debootstrap
${sharpy} dmidecode discover* dirmngr #tuleeekohan viimeisestä ongelma? vissiin ei
${sharpy} doc-debian docutils* 
${sharpy} efibootmgr exfalso 
${asy} 
${lftr}
csleep 5

dqb "f1"
csleep 5
${sharpy} fdisk ftp*
${sharpy} gdisk gcr
${asy} 
${lftr}
csleep 5

#gnupg poisto täs kohtaa hyvä idea? vai veikö dirmngr mukanaan jo?
dqb "g2"
csleep 5
${sharpy} ghostscript gir* gnupg*
${sharpy} gpg-* gpgconf gpgsm gsasl-common
${sharpy} shim* grub* 
${sharpy} gsfonts gstreamer*
${asy} 
${lftr}
csleep 5

#gnome-* poisto veisi myös: task-desktop task-xfce-desktop
#gpg* kanssa: The following packages have unmet dependencies:
# apt : Depends: gpgv but it is not going to be installed or
#                gpgv2 but it is not going to be installed or
#                gpgv1 but it is not going to be installed
#HUOM. grub* poisto voi johtaa shim-pakettien päivitykseen
#gsettings* voi viedä paljon paketteja mukanaan

dqb "iii"
csleep 5
${sharpy} intel-microcode iucode-tool
${sharpy} htop inetutils-telnet
${asy} 
${lftr}
csleep 5

#lib-paketteihin ei yleisessä tapauksessa kande koskea eikä live-
#... libgstreamer ja libgsm uutena (060125)
${sharpy} libpoppler* libuno* libreoffice* libgsm* libgstreamer*

#HUOM! PAKETIT procps, mtools JA mawk JÄTETTÄVÄ RAUHAAN!!!
dqb "l-o"
csleep 5
${sharpy} lvm2 mdadm  
${sharpy} mailcap mlocate
${sharpy} mokutil mariadb-common mysql-common
${sharpy} netcat-traditional openssh*
${sharpy} os-prober #orca saattaa poistua jo aiemmin
${asy} 
${lftr}
csleep 5

dqb "p"
csleep 5
${sharpy} ppp procmail ristretto 
${sharpy} screen
${asy} 
${lftr}
csleep 5
#HUOM.080125 screen ei suostunut poistumaan yänään, joten...

${sharpy} pkexec po* refracta*
#samba poistunee jo aiemmin?
${sharpy} squashfs-tools samba* system-config*
${asy} 
${lftr}
csleep 5

dqb "t"
csleep 5
${sharpy} telnet 
${sharpy} tex*
${asy} 
${lftr}
csleep 5

dqb "u"
csleep 5
${sharpy} uno* ure*
${sharpy} upower vim* # udisks* saattaa poistua jo aiemmin
${asy} 
${lftr}
csleep 5

dqb "x"
csleep 5
${sharpy} xorriso xfburn
${asy} 
${sharpy} xorriso 
${asy} 
csleep 5
 
dqb "y"
csleep 5
${sharpy} xfburn
${asy} 
csleep 5

#dqb "å"
#csleep 5
#${sharpy} perl* #tämän kanssa aina jotain härdelliä
#${asy} 
#csleep 5

${lftr}
${odio} shred -fu ${pkgdir}/*.deb 
df
${odio} which dhclient; ${odio} which ifup; sleep 6

#g=$(date +%F)
#[ ${debug} -eq 1 ] && ${spd} > ${d}/pkgs-${g}.txt.2

dqb "${scm} a-wx $0 in 6 secs "
csleep 6
${scm} a-wx $0 

#whack xfce so that the ui is reset
${whack} xfce*
#sössön sössön


