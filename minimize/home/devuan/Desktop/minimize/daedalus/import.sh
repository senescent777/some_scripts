#!/bin/bash
. ~/Desktop/minimize/doIt6d.sh.conf #voisi nimen muuttaa
install_pkgs=0
debug=1

#function parse_opts_1() {
#	case "${1}" in
#		-v|--v)
#			debug=1
#		;;
#		-i|--i)
#			install_pkgs=1
#		;;
#		*)
#			archive=${1}
#		;;
#	esac
#}

. ~/Desktop/minimize/libd.sh

if [ $# -gt 0 ] ; then
	#for opt in $@ ; do parse_opts_1 ${opt} ; done
	case "${1}" in
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
#
#cd /
#${som} ${part} ${dir} -o ro
#
##gg=$(sudo which gpg)
##
##if [ -x ${gg} ] ; then
##	if [ -s ${dir}/${archive}.sig ] ; then
##		gpg --verify ${dir}/${archive}.sig ${dir}/${archive}
##		[ $? -eq 0 ] || exit 99
##	fi
##fi
#
##		cd /
#
#${srat} -xvpf ${dir}/${archive}
#
#if [ ${install_pkgs} ] ; then 
#	${srat} -xvpf ${tgtfile}
#	#vöib mennä päällekkäin import.sh kanssa
#	${sdi} /var/cache/apt/archives/perl-modules-5.32*.deb
#	[ $? -eq 0 ] && ${smr} -rf ${pkgdir}/perl-modules-5.32*.deb
#
#	part3 ${pkgdir}
#fi
#
#${uom} ${part}
#cd ~/Desktop/minimize
#
##HUOM. tämän olisi kuvakkeen kanssa tarkoitus mennä jatkossa filesystem.squashfs sisälle
##TODO:https://github.com/senescent777/some_scripts/tree/senescent777-alt-version/skripts/export ja https://github.com/senescent777/some_scripts/tree/senescent777-alt-version/lib/export soveLtaen#
