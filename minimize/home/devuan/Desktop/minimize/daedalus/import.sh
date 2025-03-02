#!/bin/bash
d=$(dirname $0)

if [ -s ${d}/conf ] && [ -s ${d}/lib.sh ] ; then
	. ${d}/conf
	. ${d}/lib.sh
else
	srat="sudo /bin/tar"
	som="sudo /bin/mount"
	uom="sudo /bin/umount"
	scm="sudo /bin/chmod"
	#HUOM.190125:part tarttisi myös, tai siis part0
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
part=/dev/disk/by-uuid/${part0} #em. laitetedton olemassaolo kantsisi varmaan testata
dqb "b3f0r3 0ld.tar"
csleep 5

if [ ! -s /OLD.tar ] ; then #HUOM.260125: -p wttuun varm. vuoksi   
	${srat} -cf /OLD.tar /etc /sbin /home/stubby /home/devuan/Desktop
fi

dqb "b3f0r3 par51ng tha param5"
csleep 5

if [ $# -gt 0 ] ; then
	function common_part() {
		[ y"${1}" == "y" ] && exit 1
		[ -s ${1} ] || exit 2
		dqb "paramz_0k"

		cd /
		dqb "DEBUG:${srat} -xf ${1} "
		csleep 3
		${srat} -xf ${1} #HUOM.260125: -p wttuun varm. vuoksi  
		csleep 3

		${scm} -R a-wx ~/Desktop/minimize/*
		${scm} a-wx ~/Desktop/minimize/{daedalus,chimaera}/*
		${scm} 0755 ~/Desktop/minimize;${scm} 0755 ~/Desktop/minimize/${distro}
		${scm} a+x ~/Desktop/minimize/${distro}/*.sh

		#HUOM.280125:uutena seur rivit, poista jos pykii
		${scm} 0777 /tmp
		${sco} root:root /tmp #oik. o=rwt mutta rwx kai tarpeeksi hyvä useimpiin tarkoituksiin
	}

	case "${1}" in
		-1)
			${som} -o ro ${part} ${dir}
			csleep 5
			${som} | grep ${dir}

			echo "NEXT: $0 0 <source> (unpack AND install) | $0 1 <source> (just unpacks the archive)"
		;;
		0)
			[ x"${2}" == "x" ] && exit #voisi kai toisin,in tehdä
			dqb "KL"
			csleep 3

			[ -s ${2} ] || exit
			
			dqb "${2} IJ"
			csleep 3
			common_part ${2}
			
			pre_part3  ~/Desktop/minimize/${distro}
			pr4  ~/Desktop/minimize/${distro}
			part3  ~/Desktop/minimize/${distro}
			csleep 3
			#TODO:asxennuksen jälkeen paketit wttuun stokemasta

			csleep 3
			cd ${olddir}
			echo "NEXT: $0 2"
		;;
		1)
			[ x"${2}" == "x" ] && exit 
			[ -s ${2} ] || exit

			common_part ${2}
			csleep 3
			cd ${olddir}
			echo "NEXT: $0 2"
		;;
		2)
			${uom} ${dir}
			csleep 3
			${som} | grep ${dir}

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
