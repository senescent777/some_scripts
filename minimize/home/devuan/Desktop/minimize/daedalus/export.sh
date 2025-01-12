#!/bin/bash
#VAIH: toimimaan .deb-paketit sisältävien tar-pakettien rakennus 

d=$(dirname $0)
. ${d}/conf
. ${d}/lib.sh

${scm} a-wx ~/Desktop/minimize/*.sh

#HUOM. 120125:seur varmaankin tuo keskeisimpien .deb-pakettien kasaminen, eluksi helpommat lähteet
function make_tar() {
	dqb "make_tar ( ${1} )"
	csleep 1
	[ z"${1}" == "z" ] && exit
	dqb "${srat} -cvpf ${1}"
	${srat} -cvpf ${1} ~/Desktop/*.desktop ~/Desktop/minimize /home/stubby
}

function make_tar_15() {
	dqb "sa= ${sa}"
	csleep 5

	dqb "shary= ${shary}"
	csleep 5

	dqb "${sa} --fix-broken install"
	${fib} 
	${sa} autoremove
	csleep 1
	#dqb "sudo ~/Desktop/minimize/${distro}/clouds.sh ${dnsm}"

	#https://pkginfo.devuan.org/cgi-bin/package-query.html?c=package&q=netfilter-persistent=1.0.20
	${shary} libip4tc2 libip6tc2 libxtables12 netbase libmnl0 libnetfilter-conntrack3 libnfnetlink0 libnftnl11 
	${shary} iptables 	
	${shary} iptables-persistent init-system-helpers netfilter-persistent

	#https://pkginfo.devuan.org/cgi-bin/package-query.html?c=package&q=dnsmasq-base=2.90-4~deb12u1
	${shary} libdbus-1-3 libgmp10  libhogweed6 libidn2-0 libnettle8 
	
	#https://pkginfo.devuan.org/cgi-bin/package-query.html?c=package&q=dnsmasq=2.90-4~deb12u1 	
	${shary} runit-helper

	#https://pkginfo.devuan.org/cgi-bin/package-query.html?c=package&q=dnsutils=1:9.18.28-1~deb12u2
	#${shary} bind9-dnsutils bind9-host libedit2  libjemalloc2 libkrb5-3 libprotobuf-c1 

	${shary} dnsmasq-base dnsmasq dns-root-data #dnsutils

	csleep 1
	dqb "sudo  ~/Desktop/minimize/${distro}/clouds.sh ${dnsm}"
	csleep 1

	[ $? -eq 0 ] || exit 2
	${lftr} 

	csleep 1
	dqb "sudo  ~/Desktop/minimize/${distro}/clouds.sh ${dnsm}"
	csleep 1

	#${shary} adduser lsb-base ntpsec netbase python3 python3-ntp tzdata libbsd0 libcap2 libssl3 
	[ $? -eq 0 ] || exit 3
	
	csleep 1
	dqb "sudo  ~/Desktop/minimize/${distro}/clouds.sh ${dnsm}"
	csleep 1


	${lftr}

	csleep 1
	dqb "sudo  ~/Desktop/minimize/${distro}/clouds.sh ${dnsm}"
	csleep 1

	#${shary} libgetdns10 libbsd0 libidn2-0 libssl1.1 libunbound8 libyaml-0-2 stubby
	#https://pkginfo.devuan.org/cgi-bin/package-query.html?c=package&q=stubby=1.6.0-3+b1
	
	${shary} libgetdns10 libbsd0 libc6 libidn2-0 libssl3 libunbound8  libyaml-0-2
	${shary} stubby
	[ $? -eq 0 ] || exit 6
	${lftr} 
	
	csleep 1
	dqb "sudo ~/Desktop/minimize/${distro}/clouds.sh ${dnsm}"
	csleep 1

	#jos aikoo gpg'n tuoda takaisin ni jotenkin fiksummin kuin aiempi häsläys kesällä
	${srat} -cvpf ${1} /var/cache/apt/archives/*.deb ~/Desktop/minimize #~/.gnupg /opt/bin
}

function make_tar_1_75() {
	echo "sudo  ~/Desktop/minimize/${distro}/clouds.sh ${dnsm}"
	csleep 1

	${srat} -rvpf ${1} /home/stubby /etc/sudoers.d/meshuggah /etc/iptables /etc/network/interfaces*
#	
#	local f;for f in $(find /etc -type f -name 'stubby*') ; do ${srat} -rvpf ${1} ${f} ; done
#	for f in $(find /etc -type f -name 'dns*') ; do ${srat} -rvpf ${1} ${f} ; done
#
#	${srat} -rvpf ${1} /etc/init.d/net*
#	${srat} -rvpf ${1} /etc/rcS.d/S*net*
#	csleep 5
}

##VAIH:tuplavarmistus että validi /e/n/i tulee mukaan
##VAIH:kts uudemman kerran mitä pakettiin tulee yllä, ettei päällekkäisyyksiä ghbin kanssa
#function make_tar2() {
#	dqb "make_tar2 ( ${1} )"
#	csleep 1
#
#	local p
#	local q	
#	local tig
#	tig=$(sudo which git)
#	
#	sudo  ~/Desktop/minimize/${distro}/clouds.sh ${dnsm}
#	csleep 1
#
#	if [ x"${tig}" == "x" ] ; then
#		${shary} git
#		[ $? -eq 0 ] || exit 7
#	fi
#
#	csleep 5
#	tig=$(sudo which git)
#	[ -x ${tig} ] || exit 87
#
#	p=$(pwd)
#	dqb "p=${p}"
#
#	dqb "q=$(mktemp -d)"
#	q=$(mktemp -d)
#
#	echo "#dqb cd ${q}"
#	cd ${q}
#
#	sudo  ~/Desktop/minimize/${distro}/clouds.sh ${dnsm}
#	csleep 1
#
#	#olisi kiva jos ei tarvitsisi koko projektia vetää, wget -r tjsp
#	${tig} clone https://github.com/senescent777/project.git
#
#	sudo  ~/Desktop/minimize/${distro}/clouds.sh ${dnsm}
#	csleep 1
#
#	cd project
#	${spc} /etc/dhcp/dhclient.conf ./etc/dhcp/dhclient.conf.OLD
#	${spc} /etc/resolv.conf ./etc/resolv.conf.OLD
#	${spc} /sbin/dhclient-script ./sbin/dhclient-script.OLD
#
#	sudo mv ./etc/apt/sources.list ./etc/apt/sources.list.tmp
#	sudo mv ./etc/network/interfaces ./etc/network/interfaces.tmp
#
#	${sco} -R root:root ./etc; ${scm} -R a-w ./etc
#	${sco} -R root:root ./sbin; ${scm} -R a-w ./sbin
#	${srat} -rvpf ${1} ./etc ./sbin
#	cd ${p}
#	
#	${srat} -tf ${1} > MANIFEST
#	${srat} -rvpf ${1} ${p}/MANIFEST
#}

function make_upgrade() {
	dqb "make_upgrade(${1} )"
	dqb "${sagu}; ${sag} upgrade -u"

	${odio} shred -fu /var/cache/apt/archives/*
	${odio} ~/Desktop/minimize/${distro}/clouds.sh ${dnsm}
	${sifu} ${iface}	

	sleep 6
	${sag} autoremove
	sleep 4
	echo "${sag_u}"; sleep 4
	${sag_u}
	echo "${sag} upgrade -u";sleep 5
	${sag} upgrade -u
	${srat} -jcvpf ${1} /var/cache/apt/archives 

	#sudo /opt/bin/cloudsd.sh ${dnsm}
	${sifd} ${iface}
	sleep 1
}

mode=0
tgtfile=""

#parsetus josqs käyttöön, ehkä
if [ $# -gt 0 ] ; then
	mode=${1}
	tgtfile=${2}
else
	echo "-h"
fi

case ${mode} in
	0)
		make_tar ${tgtfile}
		make_tar_15  ${tgtfile}
		echo "make_tar2 ${tgtfile}"
	;;
	1|upgrade)
		make_upgrade ${tgtfile}
	;;
	-h)
		echo "$0 0 tgtfile | $0 1 tgtfile"
	;;
	*)
		echo "-h"
	;;
esac

