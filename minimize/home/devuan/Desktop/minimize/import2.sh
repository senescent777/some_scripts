#!/bin/bash
d=$(dirname $0)
#[ -s ${d}/conf ] && . ${d}/conf

if [ $# -gt 2 ] ; then
	if [ -d ~/Desktop/minimize/${3} ] ; then
		distro=${3}
		. ~/Desktop/minimize/${3}/conf
	fi
fi

. ~/Desktop/minimize/common_lib.sh

#if  [ -s ${d}/lib.sh ] ; then
#	. ${d}/lib.sh

#hmiston olemassaolokin olisi hyvä varmistaa
if [ -x ~/Desktop/minimize/${3}/lib.sh ] ; then
	.  ~/Desktop/minimize/${3}/lib.sh 
else
	srat="sudo /bin/tar"
	som="sudo /bin/mount"
	uom="sudo /bin/umount"
	scm="sudo /bin/chmod"
	#sco ainakin pitäisi lisätä (TODO)
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
part=/dev/disk/by-uuid/${part0}
dqb "b3f0r3 0ld.tar"
csleep 5

if [ ! -s /OLD.tar ] ; then #HUOM.260125: -p wttuun varm. vuoksi   
	${srat} -cf /OLD.tar /etc /sbin /home/stubby /home/devuan/Desktop
fi

dqb "b3f0r3 par51ng tha param5"
csleep 5

#TODO:tätä kohtaa sietäisi miettiä, esim case $# jatkossa?
#if [ $# -gt 0 ] ; then
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
		for f in $(find ~/Desktop/minimize -type d) ; do ${scm} a-wx ${f}/* ; done 
		
		${scm} 0755 ~/Desktop/minimize;${scm} 0755 ~/Desktop/minimize/${distro}
		${scm} a+x ~/Desktop/minimize/${distro}/*.sh

		${scm} 0777 /tmp
		${sco} root:root /tmp #oik. o=rwt mutta rwx kai tarpeeksi hyvä useimpiin tarkoituksiin
	}

	case "${1}" in
		-1)
			#HUOM.120325: saattaa toimia qhan tuo distro
			[ -b ${part} ] || dqb "no such thing as ${part}"

			${som} -o ro ${part} ${dir}
			csleep 5
			${som} | grep ${dir}

			echo "NEXT: $0 0 <source> (unpack AND install) | $0 1 <source> (just unpacks the archive)"
		;;
		0)
			[ x"${2}" == "x" ] && exit 55 #voisi kai toisin,in tehdä
			dqb "KL"
			csleep 3

			[ -s ${2} ] || exit 66
			dqb "${2} IJ"
			csleep 3

			[ z"{distro}" == "z" ] && exit 77
			dqb " ${3} ${distro} MN"
			csleep 3
	
			common_part ${2}		
			pre_part3 ~/Desktop/minimize/${distro}
			pr4 ~/Desktop/minimize/${distro}
			part3 ~/Desktop/minimize/${distro}
			csleep 3

			#HUOM. BARMISTA ETTÄ ÅPOSTUUKO PAKETIT $dtstro:n alta VAIKO ERI
			#090325: stubbyn kanssa oli jotain... (onko vielä?)
			#csleep 3

			cd ${olddir}
			echo "NEXT: $0 2"
		;;
		1)
			#HUOM.120325: näköjään toimii jo
			[ x"${2}" == "x" ] && exit 
			[ -s ${2} ] || exit

			common_part ${2}
			csleep 3
			cd ${olddir}
			echo "NEXT: $0 2"
		;;
		2)
			#HUOM.120325: saattaa toimia qhan tuo distro
			${uom} ${dir}
			csleep 3
			${som} | grep ${dir}

			echo "NEXT: ${d}/doIt6.sh (maybe)"
		;;
		*)
			#TODO:case -h
			dqb "-h"
		;;
	esac
#else
#	echo "$0 <mode> [other_params]"
#fi

##HUOM. tämän olisi kuvakkeen kanssa tarkoitus mennä jatkossa filesystem.squashfs sisälle
