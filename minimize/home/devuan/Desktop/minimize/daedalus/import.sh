#!/bin/bash
. ~/Desktop/minimize/doIt6d.sh.conf #voisi nimen muuttaa
install_pkgs=0
debug=1
. ~/Desktop/minimize/libd.sh

if [ $# -gt 0 ] ; then
	#for opt in $@ ; do parse_opts_1 ${opt} ; done
	case "${1}" in
		-1)
			${som} -o ro ${part} ${dir}
			echo "NEXT: $0 0 <source> | $0 1 <source>"
		;;
		0)
			#jatkossa fktioon tämä
			[ x"${2}" == "x" ] && exit #voisi kai toisin,in tehdä
			dqb "KL"
			csleep 3

			[ -s ${2} ] || exit
			
			dqb "${2} IJ"
			csleep 3

			cd /
			${srat} -xvpf ${2}  #-f ${2} -xvp ${pkgdir}
			csleep 3

			#daedaluksen kanssa pre ei vaikuttaisi olevan tarpeellinen, chimaeran kanssa vöib olla toinen juttu
			pre_part3 ${pkgdir}
			part3 ${pkgdir}
			csleep 3

			${odio} shred -fu  ${pkgdir}/*.deb
			csleep 3
			echo "NEXT: $0 2"
		;;
		1)
			cd /
			${srat} -xvpf ${2} 
			csleep 3
			echo "NEXT: $0 2"
		;;
		2)
			${uom} $part
			echo "NEXT: ~/Desktop/minimize/doIt6d.sh (maybe)"
		;;
		*)
			dqb "-h"
		;;
	esac
else
	echo "$0 <mode> [other_params]"
fi

#if [ ! -s /OLD.tar ] ; then 
#	${srat} -cvpf /OLD.tar /etc /sbin /opt/bin /home/stubby /home/devuan/Desktop
#fi

##HUOM. tämän olisi kuvakkeen kanssa tarkoitus mennä jatkossa filesystem.squashfs sisälle
##TODO:https://github.com/senescent777/some_scripts/tree/senescent777-alt-version/skripts/export ja https://github.com/senescent777/some_scripts/tree/senescent777-alt-version/lib/export soveLtaen#
