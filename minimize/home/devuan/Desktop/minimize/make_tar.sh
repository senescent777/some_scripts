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
	echo "${shary} libip4tc2 libip6tc2 libxtables12 netbase libmnl0 libnetfilter-conntrack3 libnfnetlink0 libnftnl11 iptables"
	echo "sudo rm -rf /run/live/medium/live/initrd.img*"
	echo "#csleep 5"

	echo "${shary} init-system-helpers netfilter-persistent iptables-persistent"
	echo "sudo rm -rf /run/live/medium/live/initrd.img*"
	echo "${shary} python3-ntp ntpsec-ntpdate"
	echo "#csleep 5"

	echo "${shary} dnsmasq-base runit-helper"
	echo "sudo rm -rf /run/live/medium/live/initrd.img*"

	echo "${shary} libgetdns10 libbsd0 libidn2-0 libssl1.1 libunbound8 libyaml-0-2 stubby"
	echo "sudo rm -rf /run/live/medium/live/initrd.img*"
	echo "#csleep 5"

#	#some kind of retrovirus
#	#TODO:find /etc -type f -name 'stubby*' | -name 'dns*'
#	echo "sudo tar -cvpf ${tgtfile} /var/cache/apt/archives/*.deb ~/Desktop/minimize /etc/iptables /etc/dnsmasq* /etc/stubby* /etc/network/interfaces*# 
#	echo "sudo tar -rvpf ${tgtfile} /etc/sudoers.d/user_shutdown /etc/sudoers.d/meshuggah /home/stubby#"
#	echo "sudo tar -rvpf ${tgtfile} /etc/init.d/{stubby,networking,dnsmasq,netfilter-persistent}"
#	echo "sudo tar -rvpf ${tgtfile} /etc/rcS.d/{S14netfilter-persistent,S15networking}"
#	echo "sudo tar -rvpf ${tgtfile} /etc/rc2.d/{K01avahi-daemon,K01cups,K01cups-browsed,S03dnsmasq,S03stubby}"
#	echo "sudo tar -rvpf ${tgtfile} /etc/rc3.d/{K01avahi-daemon,K01cups,K01cups-browsed,S03dnsmasq,S03stubby}"	
#	#echo "csleep 5"
}

function make_tar2() {
	echo "#add some stuff from ghub"
	echo "${shary} git"
	echo "#csleep 5"

	echo "local p"
	echo "local q"

	p=$(pwd)
	echo "p=${p}"

	echo "q=$(mktemp -d)"
	q=$(mktemp -d)

	echo "#dqb cd ${q}"
	echo "cd ${q}"
	echo "#csleep 6"

	#olisi kiva jos ei tarvitsisi koko projektia vetää, wget -r tjsp
	echo "git clone https://github.com/senescent777/project.git"
	echo "#csleep 5"
	echo "cd project"
	echo "#[ ${debug} -eq 1 ] && ls -laRs;sleep 10"

	echo "sudo cp /etc/dhcp/dhclient.conf ./etc/dhcp/dhclient.conf.OLD"
	echo "sudo cp /etc/resolv.conf ./etc/resolv.conf.OLD"
	echo "sudo cp /sbin/dhclient-script ./sbin/dhclient-script.OLD"	

	echo "#[ ${debug} -eq 1 ] && ls -laRs ./etc | less"

	echo "${sco} -R root:root ./etc; ${scm} -R a-w ./etc"
	echo "${sco} -R root:root ./sbin; ${scm} -R a-w ./sbin"
	echo "sudo tar -rvpf ${tgtfile} ./etc ./sbin"
	echo "cd ${p}"
	
	echo "sudo tar -tf  ${tgtfile} > MANIFEST"
	echo "sudo tar -rvpf ${tgtfile} ${p}/MANIFEST"
	
#	echo "${sifd} ${iface}	"
#	echo "${sifd} -a"
#	echo "${sip} link set ${iface} down"
#
#	#echo "[ $? -eq 0 ] || echo "PROBLEMS WITH NETWORK CONNECTION"
#	#echo "[ ${debug} -eq 1 ] && /sbin/ifconfig;sleep 5 
}

function make_upgrade() {
	#echo "${sag_u} "
	echo "${sag} upgrade -u"
	echo "sudo tar -cvpf /tmp/upgrade.tar /var/cache/apt/archives "
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