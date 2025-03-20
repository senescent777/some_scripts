##!/bin/bash
#d=$(dirname $0)
#[ -s ${d}/conf ] && . ${d}/conf
#HUOM. distro-kohtaiset e ja i voinee poistaa qhan testannut että d kanssa pelaa
#. ~/Desktop/minimize/common_lib.sh
#
#if [ -s ${d}/lib.sh ] ; then
#	. ${d}/lib.sh
#else
#	srat="sudo /bin/tar"
#	som="sudo /bin/mount"
#	uom="sudo /bin/umount"
#	scm="sudo /bin/chmod"
#
#	dir=/mnt
#	odio=$(which sudo)
#	
#	function dqb() {
#		[ ${debug} -eq 1 ] && echo ${1}
#	}
#
#	function csleep() {
#		[ ${debug} -eq 1 ] && sleep ${1}
#	}
#	
#fi
#
##debug=1
#echo "TODO: ~/Desktop/minimize/import2.sh"
#
#olddir=$(pwd)
##HUOM.120325: onkohan tässä kohdassa jotain ongelmaa vai ei?
#part=/dev/disk/by-uuid/${part0}
#[ -b ${part} ] || dqb "no such thing as ${part}"
#dqb "b3f0r3 0ld.tar"
#csleep 5
#
#if [ ! -s /OLD.tar ] ; then #HUOM.260125: -p wttuun varm. vuoksi   
#	${srat} -cf /OLD.tar /etc /sbin /home/stubby /home/devuan/Desktop
#fi
#
#dqb "b3f0r3 par51ng tha param5"
#csleep 5
#
#if [ $# -gt 0 ] ; then
#	function common_part() {
#		[ y"${1}" == "y" ] && exit 1
#		[ -s ${1} ] || exit 2
#		dqb "paramz_0k"
#
#		cd /
#		dqb "DEBUG:${srat} -xf ${1} "
#		csleep 3
#		${srat} -xf ${1} #HUOM.260125: -p wttuun varm. vuoksi  
#		csleep 3
#
#		${scm} -R a-wx ~/Desktop/minimize/*
#		for f in $(find ~/Desktop/minimize -type d) ; do ${scm} a-wx ${f}/* ; done 
#		csleep 4
#
#		#HUOM. kuinkahan taropeellinen mja tuo distro jatkossa?
#		${scm} 0755 ~/Desktop/minimize;${scm} 0755 ~/Desktop/minimize/${distro}
#		${scm} a+x ~/Desktop/minimize/${distro}/*.sh
#
#		#HUOM.280125:uutena seur rivit, poista jos pykii
#		${scm} 0777 /tmp
#		${sco} root:root /tmp #oik. o=rwt mutta rwx kai tarpeeksi hyvä useimpiin tarkoituksiin
#		dqb "common_part_done"
#	}
#
#	case "${1}" in
#		-1)
#			${som} -o ro ${part} ${dir}
#			csleep 5
#			${som} | grep ${dir}
#
#			echo "NEXT: $0 0 <source> (unpack AND install) | $0 1 <source> (just unpacks the archive)"
#		;;
#		0)
#			[ x"${2}" == "x" ] && exit #voisi kai toisin,in tehdä
#			dqb "KL"
#			csleep 3
#
#			[ -s ${2} ] || exit
#			
#			dqb "${2} IJ"
#			csleep 3
#			common_part ${2}
#			
#			pre_part3 ~/Desktop/minimize/${distro} 
#			pr4 ~/Desktop/minimize/${distro} 
#			part3 ~/Desktop/minimize/${distro} 
#			csleep 3
#			cd ${olddir}
#			echo "NEXT: $0 2"
#		;;
#		1)
#			[ x"${2}" == "x" ] && exit 
#			[ -s ${2} ] || exit
#
#			common_part ${2}
#			csleep 3
#			cd ${olddir}
#			echo "NEXT: $0 2"
#		;;
#		2)
#			${uom} ${dir}
#			csleep 3
#			${som} | grep ${dir}
#
#			echo "NEXT: ${d}/doIt6.sh (maybe)"
#		;;
#		*)
#			dqb "-h"
#		;;
#	esac
#else
#	echo "$0 <mode> [other_params]"
#fi
#
##HUOM. tämän olisi kuvakkeen kanssa tarkoitus mennä jatkossa filesystem.squashfs sisälle
##https://github.com/senescent777/some_scripts/tree/senescent777-alt-version/skripts/export ja https://github.com/senescent777/some_scripts/tree/senescent777-alt-version/lib/export soveLtaen?
