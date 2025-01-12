#!/bin/bash
d=$(dirname $0)

#. ~/Desktop/minimize/daedalus/lib.sh #jos jotenkin automaagisemmin jatqssa(VAIH)
. ${d}/lib.sh
${fib}
#exit
debug=0

if [ $# -gt 0 ] ; then  
	if [ "${1}" == "-v" ] ; then
		debug=1
	fi
fi

dqb "a-e"
csleep 5

#HUOM. ao. rivillä viimeisessä syystä vain core
${sharpy} amd64-microcode iucode-tool arch-test at-spi2-core bubblewrap

${sharpy} atril* coinor* cryptsetup debootstrap
${sharpy} dmidecode discover* dirmngr #tuleeekohan viimeisestä omngelma?
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

#gnupg poisto täs kohtaa hyvä idea? vai veikö dirmngr mukanaan jo=
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

#lib-paketteihin ei yleisessä tapakauksessa kande koskea eikä live-
#... libgstreamerja libgsm uutena (060125)
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

${sharpy} pkexec  po* refracta*
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

${lftr}
${odio} shred -fu /var/cache/apt/archives/*.deb
df
${odio} which dhclient; ${odio} which ifup; sleep 6

#whack xfce so that the ui is reset
${whack} xfce*


