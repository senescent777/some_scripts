#!/bin/bash
d=$(dirname $0)
#[ -s ${d}/conf ] && . ${d}/conf
debug=0

if [ $# -gt 2 ] ; then #täössä voisi olla case
	if [ -d ~/Desktop/minimize/${3} ] ; then
		distro=${3}
		. ~/Desktop/minimize/${3}/conf
	fi
fi

. ~/Desktop/minimize/common_lib.sh

#if  [ -s ${d}/lib.sh ] ; then
#	. ${d}/lib.sh

#HUOM.120325.x:hmiston olemassaolokin olisi hyvä varmistaa
#HUOM.120325.y:miel $distro kuin $3 jatkossa
if [ -x ~/Desktop/minimize/${3}/lib.sh ] ; then
	.  ~/Desktop/minimize/${3}/lib.sh 
else
	srat="sudo /bin/tar"
	som="sudo /bin/mount"
	uom="sudo /bin/umount"
	scm="sudo /bin/chmod"
	sco="sudo /bin/chown"
	dir=/mnt
	odio=$(which sudo)
	debug=1
	
	function dqb() {
		[ ${debug} -eq 1 ] && echo ${1}
	}

	function csleep() {
		[ ${debug} -eq 1 ] && sleep ${1}
	}

	dqb "FALLBACK"
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

#VAIH:tätä kohtaa sietäisi miettiä, esim case $# jatkossa?
#if [ $# -gt 0 ] ; then
#HUOM. $sidtro voisi olla $2 jatkossa
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
	${scm} 0755  ~/Desktop/minimize/*.sh
	for f in $(find ~/Desktop/minimize -type d) ; do ${scm} a-wx ${f}/* ; done 
	
	#jos nyt olisi hyvä...	
	${scm} 0755 ~/Desktop/minimize
	${scm} 0755 ~/Desktop/minimize/${distro}
	${scm} a+x ~/Desktop/minimize/${distro}/*.sh
	${scm} 0444 ~/Desktop/minimize/${distro}/conf*

	${scm} 0777 /tmp
	${sco} root:root /tmp #oik. o=rwt mutta rwx kai tarpeeksi hyvä useimpiin tarkoituksiin
}

case "${1}" in
	-1)
		#HUOM.120325: saattaa toimia qhan tuo distro
		#HUOM.120325.2: tässä tap $2 voisi olla $distro
		distro=${2}
		[ -s ~/Desktop/minimize/${distro}/conf ] && . ~/Desktop/minimize/${distro}/conf
		part=/dev/disk/by-uuid/${part0}		
		[ -b ${part} ] || dqb "no such thing as ${part}"

		${som} -o ro ${part} ${dir}
		csleep 5
		${som} | grep ${dir}

		echo "NEXT: $0 0 <source> <distro> (unpack AND install) | $0 1 <source> (just unpacks the archive)"
	;;
	2)
		#HUOM.120325: saattaa toimia qhan tuo distro
		#HUOM.120325.2: tässä tap $2 voisi olla $distro
		distro=${2}
		[ -s ~/Desktop/minimize/${distro}/conf ] && . ~/Desktop/minimize/${distro}/conf
		part=/dev/disk/by-uuid/${part0}		
		[ -b ${part} ] || dqb "no such thing as ${part}"

		${uom} ${dir}
		csleep 3
		${som} | grep ${dir}

		echo "NEXT: ${d}/doIt6.sh (maybe)"
	;;
	1)
		file=${2}

		#HUOM.120325: näköjään toimii jo
		[ x"${file}" == "x" ] && exit 44
		[ -s ${file} ] || exit 55

		common_part ${file}
		csleep 3
		cd ${olddir}
		echo "NEXT: $0 2"
	;;
	-h)
		echo "$0 <mode> [file] [distro]"
	;;
	0)
		file=${2}
		distro=${3}

		[ x"${file}" == "x" ] && exit 55 #voisi kai toisin,in tehdä
		dqb "KL"
		csleep 2

		[ -s ${file} ] || exit 66
		dqb "${file} IJ"
		csleep 2

		[ z"{distro}" == "z" ] && exit 77
		dqb " ${3} ${distro} MN"
		csleep 2

		common_part ${file}		
		pre_part3 ~/Desktop/minimize/${distro}
		pr4 ~/Desktop/minimize/${distro}
		part3 ~/Desktop/minimize/${distro}
		csleep 2

		#HUOM. BARMISTA ETTÄ ÅPOSTUUKO PAKETIT $dtstro:n alta VAIKO ERI
		#090325: stubbyn kanssa oli jotain... (onko vielä?)
		#csleep 3

		cd ${olddir}
		echo "NEXT: $0 2"
	;;
	*)
		echo "-h"
	;;
esac

#else
#	
#fi

#HUOM. tämän olisi kuvakkeen kanssa tarkoitus mennä jatkossa filesystem.squashfs sisälle
