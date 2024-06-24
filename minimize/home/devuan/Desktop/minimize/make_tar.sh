#!/bin/bash

tgtfile=/tmp/out.tar 
. ./lib

check_binaries #jos lib hoitaisi tän+seur...
check_binaries2
mode=0

function parse_opts_1 () {
	case ${1} in
		-v|--v)
			debug=1
		;;
		*)
			mode=${1}
		;;
	esac
}

function parse_opts_2() {
	case "${1}" in
		-o|--o)
			tgtfile=${2}
		;;
	esac
}

function check_params() {
	[ -s ${tgtfile} ] && echo "${tgtfile} alr3ady 3x1st5"
	local d
	
	d=$(dirname ${tgtfile})
	[ -d ${d} ] || echo "no such dir as ${d}"
}

function make_tar() {
	dqb "#make_tar (demo)"
#	dqb "${sifu} ${iface}"
#
#	echo "${sip} link set ${iface} up"
#	echo "${sifu} ${iface}	"
#	echo "${sifu} -a"
#	
#	#echo "[ $? -eq 0 ] || echo  \"PROBLEMS WITH NETWORK CONNECTION\""
#	echo "#csleep 5"
#
#	echo ""
	${shary} libip4tc2 libip6tc2 libxtables12 netbase libmnl0 libnetfilter-conntrack3 libnfnetlink0 libnftnl11 iptables
	sudo rm -rf /run/live/medium/live/initrd.img*
	csleep 5

	${shary} init-system-helpers netfilter-persistent iptables-persistent
	sudo rm -rf /run/live/medium/live/initrd.img*
	${shary} python3-ntp ntpsec-ntpdate
	csleep 5

	${shary} dnsmasq-base runit-helper
	sudo rm -rf /run/live/medium/live/initrd.img*

	${shary} libgetdns10 libbsd0 libidn2-0 libssl1.1 libunbound8 libyaml-0-2 stubby
	sudo rm -rf /run/live/medium/live/initrd.img*
	csleep 5

	#some kind of retrovirus
	sudo tar -cvpf ${tgtfile} /var/cache/apt/archives/*.deb ~/Desktop/minimize /etc/iptables /etc/network/interfaces*
	sudo tar -rvpf ${tgtfile} /etc/sudoers.d/user_shutdown /etc/sudoers.d/meshuggah /home/stubby
	local f;for f in $(find /etc -type f -name 'stubby*') ; do tar -rvpf /tmp/out.tar $f ; done
	for f in $(find /etc -type f -name 'dns*') ; do tar -rvpf /tmp/out.tar $f ; done
	sudo tar -rvpf ${tgtfile} /etc/init.d/net*
	sudo tar -rvpf ${tgtfile} /etc/rcS.d/S*net*

#HUOM. on kai joitain komentoja joilla nuo K01-linkit voisi luoda
#	sudo tar -rvpf ${tgtfile} /etc/rcS.d/{S14netfilter-persistent,S15networking}
	sudo tar -rvpf ${tgtfile} /etc/rc2.d/{K01avahi-daemon,K01cups,K01cups-browsed,S03dnsmasq,S03stubby}
	sudo tar -rvpf ${tgtfile} /etc/rc3.d/{K01avahi-daemon,K01cups,K01cups-browsed,S03dnsmasq,S03stubby}	
	csleep 5
}

function make_tar2() {
	echo "#add some stuff from ghub"

	local p
	local q	
	local tig
	tig=$(sudo which git)
	
	if [ x"${tig}" == "x" ] ; then
		${shary} git
	fi

	echo "#csleep 5"
	tig=$(sudo which git)

	p=$(pwd)
	dqb "p=${p}"

	dqb "q=$(mktemp -d)"
	q=$(mktemp -d)

	echo "#dqb cd ${q}"
	cd ${q}
	echo "#csleep 6"

	#olisi kiva jos ei tarvitsisi koko projektia vetää, wget -r tjsp
	${tig} clone https://github.com/senescent777/project.git
	echo "#csleep 5"
	cd project
	echo "#[ ${debug} -eq 1 ] && ls -laRs;sleep 10"

	sudo cp /etc/dhcp/dhclient.conf ./etc/dhcp/dhclient.conf.OLD
	sudo cp /etc/resolv.conf ./etc/resolv.conf.OLD
	sudo cp /sbin/dhclient-script ./sbin/dhclient-script.OLD

	echo "#[ ${debug} -eq 1 ] && ls -laRs ./etc | less"

	${sco} -R root:root ./etc; ${scm} -R a-w ./etc
	${sco} -R root:root ./sbin; ${scm} -R a-w ./sbin
	sudo tar -rvpf ${tgtfile} ./etc ./sbin
	cd ${p}
	
	sudo tar -tf  ${tgtfile} > MANIFEST
	sudo tar -rvpf ${tgtfile} ${p}/MANIFEST
	
#	echo "${sifd} ${iface}	"
#	echo "${sifd} -a"
#	echo "${sip} link set ${iface} down"
#
#	#echo "[ $? -eq 0 ] || echo "PROBLEMS WITH NETWORK CONNECTION"
#	#echo "[ ${debug} -eq 1 ] && /sbin/ifconfig;sleep 5 
}

function make_upgrade() {
	${sag} upgrade -u
	sudo tar -cvpf /tmp/upgrade.tar /var/cache/apt/archives 
}

if [ $# -gt 0 ] ; then
	#parse_opts_2 ${1} ${2}
	for opt in $@ ; do parse_opts_1 ${opt} ; done
	${sag_u}
	[ $? -eq 0 ] || echo "/o/b/clouds.sh <mode> | ${sifu} -a | ${sifu} ${iface}"
else
	echo "$0 -h"
fi

#main()
case ${mode} in
	0)
		check_params
		make_tar
		make_tar2
	;;
	1)
		make_upgrade
	;;
	*)
		echo "-h"
	;;
esac