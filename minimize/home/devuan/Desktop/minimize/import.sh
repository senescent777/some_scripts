#!/bin/bash
. ~/Desktop/minimize/conf

function parse_opts_1() {
	case "${1}" in
		-v|--v)
			debug=1
		;;
		*)
			archive=${1}
		;;
	esac
}

. ./lib

if [ $# -gt 0 ] ; then
	for opt in $@ ; do parse_opts_1 ${opt} ; done
fi

#VAIH:oleelllisista hmistoista backup ennen purkua?
${srat} -cvpf /OLD.tar /etc /sbin /opt/bin /home/stubby /home/devuan/Desktop

cd /
${som} ${part} ${dir} -o ro

#gg=$(sudo which gpg)
#
#if [ -x ${gg} ] ; then
#	if [ -s ${dir}/${archive}.sig ] ; then
#		gpg --verify ${dir}/${archive}.sig ${dir}/${archive}
#		[ $? -eq 0 ] || exit 99
#	fi
#fi

#		cd /
#		${srat} -xvpf ${tgtfile}
#		#vöib mennä päällekkäin import.sh kanssa
#		${sdi} /var/cache/apt/archives/perl-modules-5.32*.deb
#		[ $? -eq 0 ] && ${smr} -rf ${pkgdir}/perl-modules-5.32*.deb
#
#		part3


${srat} -xvpf ${dir}/${archive}
${uom} ${part}
cd ~/Desktop/minimize

#HUOM. tämän olisi kuvakkeen kanssa tarkoitus mennä jatkossa filesystem.squashfs sisälle

#VAIH:make_tar:ista gpgtar-jutut
#TODO:https://github.com/senescent777/some_scripts/tree/senescent777-alt-version/skripts/export ja https://github.com/senescent777/some_scripts/tree/senescent777-alt-version/lib/export soveötaen
#VAIH:jatkossa myös pakettien päivitys tänän skriptin kautta?

