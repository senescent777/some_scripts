#!/bin/bash

#HUOM.020225: sopisi olla slim:in login.ongelmat korjattu nyt
#TODO:xfce-asetukset mukaan varm. vuoksi?

d=$(dirname $0)
debug=1

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

debug=1

function make_tar() {
	dqb "make_tar ( ${1} )"
	csleep 5
	[ z"${1}" == "z" ] && exit

	${scm} -R a-wx ~/Desktop/minimize/*
	${scm} 0755 ~/Desktop/minimize;${scm} 0755 ~/Desktop/minimize/${distro}
	${scm} a+x ~/Desktop/minimize/${distro}/*.sh

	dqb "${srat} -cf ${1}"  #HUOM.260125: -p wttuun varm. vuoksi  
	${srat} -cf ${1} ~/Desktop/*.desktop ~/Desktop/minimize /home/stubby #HUOM.260125: -p wttuun varm. vuoksi  
}

#tässä oli pari potentiaalista ongelmien aiheuttajaa
#HUOM.020225:vissiin kunnossa pakettien nuoto nyt 
#HUOM. pitäisiköhän tässä karsia joitain paketteja ettei tartte myöhemmin...
function make_tar_15() {
	dqb "make_tar_15( ${1})"
	csleep 4
	
	#dqb "${fib}; ${asy}" #HUOM.010225: tilapåäisetsi pois tämä+seur 2 riviä kunnes sekoilu loppunut
	#${fib} 
	#${asy} 
	
	if [ z"${pkgdir}" != "z" ] ; then 
		${odio} shred -fu ${pkgdir}/*.deb
	fi

	${odio} shred -fu ~/Desktop/minimize/${distro}/*.deb
	[ z"${1}" == "z" ] && exit 1
	[ -s ${1} ] || exit 2
	dqb "paramz_ok"

	${sag_u}
	[ $? -eq 0 ] || exit	
	csleep 5
	dqb "sudo  ~/Desktop/minimize/${distro}/clouds.sh ${dnsm}"

	#https://pkginfo.devuan.org/cgi-bin/package-query.html?c=package&q=netfilter-persistent=1.0.20
	${shary} libip4tc2 libip6tc2 libxtables12 netbase libmnl0 libnetfilter-conntrack3 libnfnetlink0 libnftnl11 
	${shary} iptables 	
	${shary} iptables-persistent init-system-helpers netfilter-persistent

	#040325:tilapäisesti jemmaan, sotkee (tai siis nimenomaan pitäisi ajaa clouds iptables-pakettien uudelleenas jälkeen)
	#no more broken laptop, but there seems to be some problems with the wireless connection, so...
	csleep 5
	sudo ${d}/clouds.sh ${dnsm}
	${sifu} ${iface}
	csleep 5

	#https://pkginfo.devuan.org/cgi-bin/package-query.html?c=package&q=dnsmasq-base=2.90-4~deb12u1
	#${shary} libdbus-1-3 #tämä erhkö qsee asioita
	${shary} libgmp10 libhogweed6 libidn2-0 libnettle8 
	
	#https://pkginfo.devuan.org/cgi-bin/package-query.html?c=package&q=dnsmasq=2.90-4~deb12u1 	
	${shary} runit-helper

	#https://pkginfo.devuan.org/cgi-bin/package-query.html?c=package&q=dnsutils=1:9.18.28-1~deb12u2
	#${shary} bind9-dnsutils bind9-host libedit2 libjemalloc2 libkrb5-3 libprotobuf-c1 

	${shary} dnsmasq-base dnsmasq dns-root-data #dnsutils
	#[ $? -eq 0 ] || exit 2
	${lftr} 

	#josqs ntp-jututkin mukaan?
	#${shary} adduser lsb-base ntpsec netbase python3 python3-ntp tzdata libbsd0 libcap2 libssl3 
	#[ $? -eq 0 ] || exit 3

	#https://pkginfo.devuan.org/cgi-bin/package-query.html?c=package&q=stubby=1.6.0-3+b1

	${shary} libev4
	${shary} libgetdns10 libbsd0 libidn2-0 libssl3 libunbound8 libyaml-0-2 #sotkeekohan libc6 uudelleenas tässä?
	${shary} stubby

	#[ $? -eq 0 ] || exit 6
	${lftr} 

	#HUOM. jos aikoo gpg'n tuoda takaisin ni jotenkin fiksummin kuin aiempi häsläys kesällä
	${odio} shred -fu ~/Desktop/minimize/${distro}/*.deb
	csleep 4 
	${odio} mv ${pkgdir}/*.deb ~/Desktop/minimize/${distro}
	${srat} -rf ${1} ~/Desktop/minimize/${distro}/*.deb
	#HUOM.260125: -p wttuun varm. vuoksi  

	dqb "sudo ~/Desktop/minimize/${distro}/clouds.sh ${dnsm}"
}

#tässäkin se -c -r:n sijaan voi sotkea 
function make_tar_1_75() {
	#echo "sudo  ~/Desktop/minimize/${distro}/clouds.sh ${dnsm}"
	dqb "make_tar_1_75( ${1} )"	
	csleep 5
	
	[ y"${1}" == "y" ] && exit 1
	[ -s ${1} ] || exit 2
	dqb "paramz_0k"
	csleep 1

	#HUOM.260125: -p wttuun varm. vuoksi  
	${srat} -rf ${1} /etc/sudoers.d/meshuggah /etc/iptables /etc/network/interfaces*
	
	local f;for f in $(find /etc -type f -name 'stubby*') ; do ${srat} -rf ${1} ${f} ; done
	for f in $(find /etc -type f -name 'dns*') ; do ${srat} -rf ${1} ${f} ; done

	${srat} -rf ${1} /etc/init.d/net*
	${srat} -rf ${1} /etc/rcS.d/S*net*
	csleep 5
}

#VAIH:jos jatkossa ajaisi tämän ennen _1,5 tai _1,75 (tai niin että ajetaan m,ikäli joitain tiedostoja puuttuu)
#VAIH:tuplavarmistus että validi /e/n/i tulee mukaan
#VAIH:kts uudemman kerran mitä pakettiin tulee yllä, ettei päällekkäisyyksiä ghbin kanssa
#VAIH:tämänkin toimivuuden tarkistus taas
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
	
	#sudo  ~/Desktop/minimize/${distro}/clouds.sh ${dnsm}
	#csleep 1

	if [ x"${tig}" == "x" ] ; then
		${shary} git
		[ $? -eq 0 ] || exit 7
	fi

	csleep 5
	tig=$(sudo which git)
	[ -x ${tig} ] || exit 87

	p=$(pwd)
	dqb "p=${p}"

	dqb "q=\$(mktemp -d)"
	q=$(mktemp -d)

	echo "#dqb cd ${q}"
	cd ${q}

	#sudo  ~/Desktop/minimize/${distro}/clouds.sh ${dnsm}
	#csleep 1

	#olisi kiva jos ei tarvitsisi koko projektia vetää, wget -r tjsp
	${tig} clone https://github.com/senescent777/project.git

	#(jospa siirtäöisi nuo project-jutut jonnekin muualle?)
	#sudo  ~/Desktop/minimize/${distro}/clouds.sh ${dnsm}
	#csleep 1

	cd project
	${spc} /etc/dhcp/dhclient.conf ./etc/dhcp/dhclient.conf.OLD
	${spc} /etc/resolv.conf ./etc/resolv.conf.OLD
	${spc} /sbin/dhclient-script ./sbin/dhclient-script.OLD

	sudo mv ./etc/apt/sources.list ./etc/apt/sources.list.tmp
	sudo mv ./etc/network/interfaces ./etc/network/interfaces.tmp

	${sco} -R root:root ./etc; ${scm} -R a-w ./etc
	${sco} -R root:root ./sbin; ${scm} -R a-w ./sbin
	${srat} -rf ${1} ./etc ./sbin 
	cd ${p}
	
	${srat} -tf ${1} > MANIFEST
	${srat} -rf ${1} ${p}/MANIFEST
}

#HUOM.020225:vissiin ao. fdktion tuotos toimii tällä hetkellä
function make_upgrade() {
	dqb "make_upgrade(${1} )"
	csleep 5
	
	[ y"${1}" == "y" ] && exit 1
	[ -s ${1} ] && exit 2
	dqb "paramz_0k"
	csleep 1

	dqb "${sagu}; ${sag} upgrade -u"

	${odio} shred -fu ${pkgdir}/*.deb 
	#${odio} ${d}/clouds.sh ${dnsm} 
	#${sifu} ${iface}	
	sleep 6

	${asy} 
	sleep 4

	echo "${sag_u}"; sleep 4
	${sag_u}

	echo "${sag} upgrade -u";sleep 5
	${sag} upgrade -u
	${odio} mv ${pkgdir}/*.deb ~/Desktop/minimize/${distro}
	${srat} -jcf ${1} ~/Desktop/minimize/${distro}/*.deb

	#${sifd} ${iface}
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
		make_tar_1_75 ${tgtfile}
		make_tar2 ${tgtfile}

		make_tar_15 ${tgtfile} 
	;;
	1|u|upgrade)
		make_upgrade ${tgtfile}
	;;
	-h)
		echo "$0 0 tgtfile | $0 1 tgtfile"
	;;
	*)
		echo "-h"
	;;
esac

