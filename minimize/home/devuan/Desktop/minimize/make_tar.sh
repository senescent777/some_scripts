#!/bin/bash

mode=0
frist=0
debug=0
tgtfile=/tmp/out.tar 

function parse_opts_1 () {
	case ${1} in
		-v|--v)
			debug=1
		;;
		-h)
			echo "$0 <mode> [-o ouftile] [-i infile] [-v]"
			exit
		;;
		*)
			if [ ${frist} -eq 0 ] ; then 
				mode=${1}
				frist=1
			fi
		;;
	esac
}

function parse_opts_2() {
	case "${1}" in
		-o|--o|-i|--i)
			tgtfile=${2}
		;;
	esac
}

function check_params() {
	dqb "check_params( ${1} )"
	[ -s ${1} ] && echo "${1} alr3ady 3x1st5"
	local d
	
	d=$(dirname ${1})
	[ -d ${d} ] || echo "no such dir as ${d}"
}

. ./lib
gz=$(sudo which gpgtar)

function make_tar() {
	dqb "make_tar ( ${1} )"
	csleep 1

	${sa} --fix-broken install
	csleep 1

	${shary} libip4tc2 libip6tc2 libxtables12 netbase libmnl0 libnetfilter-conntrack3 libnfnetlink0 libnftnl11 iptables
	${smr} -rf /run/live/medium/live/initrd.img*
	csleep 5

	${shary} init-system-helpers netfilter-persistent iptables-persistent
	${smr} -rf /run/live/medium/live/initrd.img*
	${shary} python3-ntp ntpsec-ntpdate
	csleep 5

	${shary} dnsmasq-base runit-helper
	${smr} -rf /run/live/medium/live/initrd.img*

	${shary} libgetdns10 libbsd0 libidn2-0 libssl1.1 libunbound8 libyaml-0-2 stubby
	${smr} -rf /run/live/medium/live/initrd.img*
	csleep 5

	#some kind of retrovirus
	${srat} -cvpf ${1} /var/cache/apt/archives/*.deb ~/Desktop/minimize /etc/iptables /etc/network/interfaces*
	${srat} -rvpf ${1} /etc/sudoers.d/user_shutdown /etc/sudoers.d/meshuggah /home/stubby
	
	local f;for f in $(find /etc -type f -name 'stubby*') ; do tar -rvpf /tmp/out.tar $f ; done
	for f in $(find /etc -type f -name 'dns*') ; do tar -rvpf /tmp/out.tar $f ; done

	${srat} -rvpf ${1} /etc/init.d/net*
	${srat} -rvpf ${1} /etc/rcS.d/S*net*

#	#HUOM. on kai joitain komentoja joilla nuo K01-linkit voisi luoda (doIt olisi sopiva paikka kutsua)
#	${srat} -rvpf ${1} /etc/rc2.d/{K01avahi-daemon,K01cups,K01cups-browsed,S03dnsmasq,S03stubby}
#	${srat} -rvpf ${1} /etc/rc3.d/{K01avahi-daemon,K01cups,K01cups-browsed,S03dnsmasq,S03stubby}	
	csleep 5
}

function make_tar2() {
	dqb "make_tar2 ( ${1} )"
	csleep 1

	local p
	local q	
	local tig
	tig=$(sudo which git)
	
	if [ x"${tig}" == "x" ] ; then
		${shary} git
	fi

	csleep 5
	tig=$(sudo which git)

	p=$(pwd)
	dqb "p=${p}"

	dqb "q=$(mktemp -d)"
	q=$(mktemp -d)

	echo "#dqb cd ${q}"
	cd ${q}

	#olisi kiva jos ei tarvitsisi koko projektia vetää, wget -r tjsp
	${tig} clone https://github.com/senescent777/project.git

	cd project
	echo "#[ ${debug} -eq 1 ] && ls -laRs;sleep 10"

	${spc} /etc/dhcp/dhclient.conf ./etc/dhcp/dhclient.conf.OLD
	${spc} /etc/resolv.conf ./etc/resolv.conf.OLD
	${spc} /sbin/dhclient-script ./sbin/dhclient-script.OLD

	${sco} -R root:root ./etc; ${scm} -R a-w ./etc
	${sco} -R root:root ./sbin; ${scm} -R a-w ./sbin
	${srat} -rvpf ${1} ./etc ./sbin
	cd ${p}
	
	${srat} -tf ${1} > MANIFEST
	${srat} -rvpf ${1} ${p}/MANIFEST
}

function make_upgrade() {
	dqb "make_upgrade(${1} )"
	dqb "${sag} upgrade -u"

	${sag} upgrade -u
	${srat} -cvpf ${1} /var/cache/apt/archives 
}

if [ $# -gt 0 ] ; then
	parse_opts_2 ${2} ${3}
	for opt in $@ ; do parse_opts_1 ${opt} ; done

	${sag_u} 
	#[ $? -eq 0 ] || echo "/o/b/clouds.sh <mode> | ${sifu} -a | ${sifu} ${iface}";exit
else
	echo "$0 -h";exit
fi

check_params ${tgtfile}

#main()
case ${mode} in
	0)
		make_tar ${tgtfile}
		make_tar2 ${tgtfile}
	;;
	1)
		
		make_upgrade ${tgtfile}
	;;
	2)
		cd /
		${srat} -xvpf ${tgtfile}
		
		${sdi} /var/cache/apt/archives/perl-modules-5.32*.deb
		[ $? -eq 0 ] && ${smr} -rf ${pkgdir}/perl-modules-5.32*.deb

		part3
	;;
	3)
		if [ x"$gz" == "x" ] ; then 
			${sag} install gpg
		fi
	
		[ -d ~/.gnupg ] || gpg --quick-generate-key tester
		#VAIH:joitain gpg:n huomioiva versio make_upgtade():sta tähän
		${gz} --sign --create ${tgtfile}.s /var/cache/apt/archives/
	;;
	4)
		
		if [ x"$gz" == "x" ] ; then 
			${sag} install gpg
		fi

		#VAIH:gpg-allekIRjoitukset huomioiva tar-purku tähän
		#TODO:myös mount ja umount mukaan?
		echo "mount;gpgtar -x"
	;;
	*)
		echo "-h"
	;;
esac