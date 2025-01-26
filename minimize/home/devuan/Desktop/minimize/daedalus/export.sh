#!/bin/bash
#HUOM. 190125: vissiin o0ikeat paketit löytyvät mutta jotain muuta kusee make_tar_fktioiden ulosteessa, asia selvitettävä jakorjattava

d=$(dirname $0)
#debug=1

if [ -s ${d}/conf ] && [ -s ${d}/lib.sh ] ; then
	. ${d}/conf
	. ${d}/lib.sh
else
	srat="sudo /bin/tar"
	som="sudo /bin/mount"
	uom="sudo /bin/umount"
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

function make_tar() {
	dqb "make_tar ( ${1} )"
	csleep 1
	[ z"${1}" == "z" ] && exit

	${scm} -R a-wx ~/Desktop/minimize/*
	${scm} 0755 ~/Desktop/minimize;${scm} 0755 ~/Desktop/minimize/${distro}
	${scm} a+x ~/Desktop/minimize/${distro}/*.sh

	dqb "${srat} -cpf ${1}"
	${srat} -cpf ${1} ~/Desktop/*.desktop ~/Desktop/minimize /home/stubby
}

#tässä oli pari potentiaalista ongelmien aiheuttajaa
function make_tar_15() {
	dqb "${fib}; ${asy}"
	${fib} 
	${asy} 
	
	if [ z"${pkgdir}" != "z" ] ; then 
		${odio} shred -fu ${pkgdir}/*.deb
	fi

	${sag_u}
	[ $? -eq 0 ] || exit	
	csleep 1
	#dqb "sudo  ~/Desktop/minimize/${distro}/clouds.sh ${dnsm}"

	#https://pkginfo.devuan.org/cgi-bin/package-query.html?c=package&q=netfilter-persistent=1.0.20
	${shary} libip4tc2 libip6tc2 libxtables12 netbase libmnl0 libnetfilter-conntrack3 libnfnetlink0 libnftnl11 
	${shary} iptables 	
	${shary} iptables-persistent init-system-helpers netfilter-persistent

	#no more broken laptop, but there seems to be some problems with the wireless connection, so...
	csleep 5
	sudo ${d}/clouds.sh ${dnsm}
	${sifu} ${iface}
	csleep 5

	#https://pkginfo.devuan.org/cgi-bin/package-query.html?c=package&q=dnsmasq-base=2.90-4~deb12u1
	${shary} libdbus-1-3 libgmp10  libhogweed6 libidn2-0 libnettle8 
	
	#https://pkginfo.devuan.org/cgi-bin/package-query.html?c=package&q=dnsmasq=2.90-4~deb12u1 	
	${shary} runit-helper

	#https://pkginfo.devuan.org/cgi-bin/package-query.html?c=package&q=dnsutils=1:9.18.28-1~deb12u2
	#${shary} bind9-dnsutils bind9-host libedit2 libjemalloc2 libkrb5-3 libprotobuf-c1 

	${shary} dnsmasq-base dnsmasq dns-root-data #dnsutils
	[ $? -eq 0 ] || exit 2
	${lftr} 

	#${shary} adduser lsb-base ntpsec netbase python3 python3-ntp tzdata libbsd0 libcap2 libssl3 
	[ $? -eq 0 ] || exit 3

	#${shary} libev4 libgetdns10 libbsd0 libidn2-0 libssl1.1 libunbound8 libyaml-0-2 stubby
	#https://pkginfo.devuan.org/cgi-bin/package-query.html?c=package&q=stubby=1.6.0-3+b1

	${shary} libev4
	${shary} libgetdns10 libbsd0 libidn2-0 libssl3 libunbound8 libyaml-0-2 #sotkeekohan libc6 uudelleenas tässä?
	${shary} stubby

	[ $? -eq 0 ] || exit 6
	${lftr} 

	#HUOM. jos aikoo gpg'n tuoda takaisin ni jotenkin fiksummin kuin aiempi häsläys kesällä
	${srat} -rpf ${1} ${pkgdir}/*.deb
	dqb "sudo  ~/Desktop/minimize/${distro}/clouds.sh ${dnsm}"
}

#tässäkin se -c -r:n sijaan voi sotkea 
function make_tar_1_75() {
	#echo "sudo  ~/Desktop/minimize/${distro}/clouds.sh ${dnsm}"
	dqb "make_tar_1_75( ${1} )"	
	csleep 1
	
	[ y"${1}" == "y" ] && exit 1
	[ -s ${1} ] || exit 2
	dqb "paramz_0k"
	csleep 1

	${srat} -rpf ${1} /etc/sudoers.d/meshuggah /etc/iptables /etc/network/interfaces*
	
	local f;for f in $(find /etc -type f -name 'stubby*') ; do ${srat} -rpf ${1} ${f} ; done
	for f in $(find /etc -type f -name 'dns*') ; do ${srat} -rpf ${1} ${f} ; done

	${srat} -rpf ${1} /etc/init.d/net*
	${srat} -rpf ${1} /etc/rcS.d/S*net*
	csleep 5
}

#TODO:jos jatkossa ajaisi tämän ennen _1,5 tai _1,75
#VAIH:tuplavarmistus että validi /e/n/i tulee mukaan
#VAIH:kts uudemman kerran mitä pakettiin tulee yllä, ettei päällekkäisyyksiä ghbin kanssa
function make_tar2() {
	dqb "make_tar2 ( ${1} )"
	csleep 1

	[ y"${1}" == "y" ] && exit 1
	[ -s ${1} ] || exit 2
	dqb "paramz_0k"
	csleep 1

	local p
	local q	
	local tig
	tig=$(sudo which git)
	
	sudo  ~/Desktop/minimize/${distro}/clouds.sh ${dnsm}
	csleep 1

	ff [ x"${tig}" == "x" ] ; then
		${shary} git
		[ $? -eq 0 ] || exit 7
	fi

	csleep 5
	tig=$(sudo which git)
	[ -x ${tig} ] || exit 87

	p=$(pwd)
	dqb "p=${p}"

	dqb "q=$(mktemp -d)"
	q=$(mktemp -d)

	echo "#dqb cd ${q}"
	cd ${q}

	sudo  ~/Desktop/minimize/${distro}/clouds.sh ${dnsm}
	csleep 1

	#olisi kiva jos ei tarvitsisi koko projektia vetää, wget -r tjsp
	${tig} clone https://github.com/senescent777/project.git
	#(jospa siirtäöisi nuo project-jutut jonnekin muualle?)
	sudo  ~/Desktop/minimize/${distro}/clouds.sh ${dnsm}
	csleep 1

	cd project
	${spc} /etc/dhcp/dhclient.conf ./etc/dhcp/dhclient.conf.OLD
	${spc} /etc/resolv.conf ./etc/resolv.conf.OLD
	${spc} /sbin/dhclient-script ./sbin/dhclient-script.OLD

	sudo mv ./etc/apt/sources.list ./etc/apt/sources.list.tmp
	sudo mv ./etc/network/interfaces ./etc/network/interfaces.tmp

	${sco} -R root:root ./etc; ${scm} -R a-w ./etc
	${sco} -R root:root ./sbin; ${scm} -R a-w ./sbin
#	${srat} -rpf ${1} ./etc ./sbin
	cd ${p}
	
	${srat} -tf ${1} > MANIFEST
	${srat} -rpf ${1} ${p}/MANIFEST
}

function make_upgrade() {
	dqb "make_upgrade(${1} )"
	csleep 1
	
	[ y"${1}" == "y" ] && exit 1
	[ -s ${1} ] || exit 2
	dqb "paramz_0k"
	csleep 1

	dqb "${sagu}; ${sag} upgrade -u"

	${odio} shred -fu ${pkgdir}/*.deb 
	${odio} ${d}/clouds.sh ${dnsm} 
	${sifu} ${iface}	
	sleep 6

	${asy} 
	sleep 4

	echo "${sag_u}"; sleep 4
	${sag_u}

	echo "${sag} upgrade -u";sleep 5
	${sag} upgrade -u
	${srat} -jcpf ${1} ${pkgdir}

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
		make_tar_15 ${tgtfile}
		make_tar_1_75 ${tgtfile}

		make_tar2 ${tgtfile}
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

