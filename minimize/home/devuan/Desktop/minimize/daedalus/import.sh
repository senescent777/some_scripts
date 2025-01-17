#!/bin/bash
d=$(dirname $0)

if [ -s ${d}/conf ] && [ -s ${d}/lib.sh ] ; then
	. ${d}/conf
	#debug=1
	. ${d}/lib.sh

	#echo "${scm} a-wx ~/Desktop/minimize/*.sh"
else
	srat="sudo /bin/tar"
	som="sudo /bin/mount"
	uom="sudo /bin/umount"
	dir=/mnt
	odio=$(which sudo)
	debug=1
	
	function dqb() {
		[ ${debug} -eq 1 ] && echo ${1}
	}

	function csleep() {
		[ ${debug} -eq 1 ] && sleep ${1}
	}
	
fi

olddir=$(pwd)
dqb "b3f0r3 0ld.tar"
csleep 5

if [ ! -s /OLD.tar ] ; then 
	${srat} -cpf /OLD.tar /etc /sbin /opt/bin /home/stubby /home/devuan/Desktop
fi

dqb "b3f0r3 par51ng tha param5"
csleep 5

if [ $# -gt 0 ] ; then
	case "${1}" in
		-1)
			${som} -o ro ${part} ${dir}
			csleep 5
			${som} | grep ${part}
			echo "NEXT: $0 0 <source> (unpack AND install) | $0 1 <source> (just unpacks the archive)"
		;;
		0)
			#jatkossa fktioon tämä?
			[ x"${2}" == "x" ] && exit #voisi kai toisin,in tehdä
			dqb "KL"
			csleep 3

			[ -s ${2} ] || exit
			
			dqb "${2} IJ"
			csleep 3

			cd /
			${srat} -xpf ${2}  
			csleep 3

			#daedaluksen kanssa pre ei vaikuttaisi olevan tarpeellinen, chimaeran kanssa vöib olla toinen juttu
			pre_part3 ${pkgdir}
			part3 ${pkgdir}
			csleep 3

			#VAIH:jokin validiustark ennenq shred
			#... tai tarvitseeko ko ko shred'iä tässä
			#${odio} shred -fu ${pkgdir}/*.deb
			[ ${debug} -eq 1 ] && ls -las  ${pkgdir}/*.deb			

			csleep 3
			cd ${olddir}
			echo "NEXT: $0 2"
		;;
		1)
			[ x"${2}" == "x" ] && exit 
			[ -s ${2} ] || exit

			dqb "${srat} -xpf ${2} in 3 secs"	
			csleep 3

			cd /
			${srat} -xpf ${2} 
			csleep 3
			cd ${olddir}
			echo "NEXT: $0 2"
		;;
		2)
			${uom} ${part}
			csleep 3
			${som} | grep ${part}

			echo "NEXT: ${d}/doIt6.sh (maybe)"
		;;
		*)
			dqb "-h"
		;;
	esac
else
	echo "$0 <mode> [other_params]"
fi

##HUOM. tämän olisi kuvakkeen kanssa tarkoitus mennä jatkossa filesystem.squashfs sisälle
##https://github.com/senescent777/some_scripts/tree/senescent777-alt-version/skripts/export ja https://github.com/senescent777/some_scripts/tree/senescent777-alt-version/lib/export soveLtaen?
