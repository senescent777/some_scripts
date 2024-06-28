#!/bin/bash
. ~/Desktop/minimize/conf

mode=0
frist=0
debug=0
proceed=0

function parse_opts_1() {
	case "${1}" in
		-v|--v)
			debug=1
		;;
		*)
			if [ ${frist} -eq 0 ] ; then 
				tgtfile=${1}
				frist=1
			else
				mode=${1}
			fi
		;;
	esac
}

. ./lib

if [ $# -gt 0 ] ; then
	for opt in $@ ; do parse_opts_1 ${opt} ; done
fi

[ ${debug} -eq 1 ] && echo "mode= $mode , tgtfile=$tgtfile part=$part dir=$dir"
#exit

if [ ! -s /OLD.tar ] ; then 
	${srat} -cvpf /OLD.tar /etc /sbin /opt/bin /home/stubby /home/devuan/Desktop
fi

cd /
${som} ${part} ${dir} -o ro
gg=$(sudo which gpg)

if [ -x ${gg} ] ; then
	if [ -s ${dir}/${archive}.sig ] ; then
		gpg --verify ${dir}/${archive}.sig ${dir}/${archive}

		if [ $? -eq 0 ] ; then
			proceed=1
		fi
	fi
else
	proceed=1
fi

if [ ${proceed} -eq 1 ] ; then
	case ${mode} in
		0)
			${srat} -xvpf ${dir}/${archive}
		;;
		1)
			${srat} -xvpf ${dir}/${archive}
			${sdi} /var/cache/apt/archives/perl-modules-5.32*.deb
			[ $? -eq 0 ] && ${smr} -rf ${pkgdir}/perl-modules-5.32*.deb
			part3
		;;
		*)
			echo "$0 -h"
		;;
	esac
fi

${uom} ${part}
cd ~/Desktop/minimize

##HUOM. tämän olisi kuvakkeen kanssa tarkoitus mennä jatkossa filesystem.squashfs sisälle
##TODO:https://github.com/senescent777/some_scripts/tree/senescent777-alt-version/skripts/export ja https://github.com/senescent777/some_scripts/tree/senescent777-alt-version/lib/export soveLtaen