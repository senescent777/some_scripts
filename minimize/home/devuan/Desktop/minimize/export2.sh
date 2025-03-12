#!/bin/bash
#d=$(dirname $0)
#[ -s ${d}/conf ] && . ${d}/conf

if [ $# -gt 2 ] ; then
	if [ -d ~/Desktop/minimize/${3} ] ; then
		distro=${3}
		. ~/Desktop/minimize/${3}/conf
	fi
fi

. ~/Desktop/minimize/common_lib.sh

if [ $# -gt 2 ] ; then
	if [ -d ~/Desktop/minimize/${3} ] ; then
		. ~/Desktop/minimize/${3}/lib.sh
	fi
fi

#if [ -s ${d}/lib.sh ] ; then
#	. ${d}/lib.sh
#else
#	srat="sudo /bin/tar"
#	som="sudo /bin/mount"
#	uom="sudo /bin/umount"
#	dir=/mnt
#	odio=$(which sudo)
#	debug=1
#	
#	function dqb() {
#		[ ${debug} -eq 1 ] && echo ${1}
#	}
#
#	function csleep() {
#		[ ${debug} -eq 1 ] && sleep ${1}
#	}	
#fi
#
#tig=$(sudo which git)
#
#if [ x"${tig}" == "x" ] ; then
#	#VAIH:voisi myös urputtaa kjälle että ajaa ao. komennot
#	echo "${sag_u}"
#	echo "${shary} git"
#	exit 7
#fi
#
#mkt=$(sudo which mktemp)
#
#if [ x"${mkt}" == "x" ] ; then
#	#VAIH:voisi myös urputtaa kjälle että ajaa ao. komennot
#	echo "${sag_u}"
#	echo "${shary} mktemp"
#	exit 8
#fi
#
#function tp1() {
#	[ z"${1}" == "z" ] && exit
#
#	${scm} -R a-wx ~/Desktop/minimize/*
#	${scm} 0755 ~/Desktop/minimize;${scm} 0755 ~/Desktop/minimize/${distro}
#	${scm} 0755 ~/Desktop/minimize/${distro}/*.sh
#	${odio} shred -fu ~/Desktop/minimize/${distro}/*.deb
#
#	if [ ${enforce} -eq 1 ] ; then
#		${srat} -cvf ~/Desktop/minimize/xfce.tar ~/.config/xfce4/xfconf/xfce-perchannel-xml 
#		
#		#HUOM.100325: pitäisiköhän se .mozilla:n vetäminen mukaan jollain ehdolla?	
#		#HUOM.110325: ei suoraan tar, miel find:in kautta
#		#*.js ja *.json kai oleellisimmat kalat
#		#${srat} -cvf ~/Desktop/minimize/someparam.tar ~/.mozilla #arpoo arpooo
#	fi
#
#	if [ ${debug} -eq 1 ] ; then
#		ls -las ~/Desktop/minimize/; sleep 10
#	fi
#	
#	${srat} -cvf ${1} ~/Desktop/*.desktop ~/Desktop/minimize /home/stubby #HUOM.260125: -p wttuun varm. vuoksi  
#}
#
##HUOM. pitäisiköhän tässä karsia joitain paketteja ettei tartte myöhemmin... no ehkö chimeran tapauksessa
#function tp4() {
#	if [ z"${pkgdir}" != "z" ] ; then 
#		${odio} shred -fu ${pkgdir}/*.deb
#	fi
#	
#	[ z"${1}" == "z" ] && exit 1
#	[ -s ${1} ] || exit 2
#
#	${sag_u}
#	[ $? -eq 0 ] || exit
#
#	#https://pkginfo.devuan.org/cgi-bin/package-query.html?c=package&q=netfilter-persistent=1.0.20
#	${shary} libip4tc2 libip6tc2 libxtables12 netbase libmnl0 libnetfilter-conntrack3 libnfnetlink0 libnftnl11 
#	${shary} iptables 	
#	${shary} iptables-persistent init-system-helpers netfilter-persistent
#
#	#actually necessary block
#	sudo ${d}/clouds.sh ${dnsm}
#	${sifu} ${iface}
#
#	${shary} libgmp10 libhogweed6 libidn2-0 libnettle8
#	${shary} runit-helper
#
#	${shary} dnsmasq-base dnsmasq dns-root-data #dnsutils
#	${lftr} 
#
#	#josqs ntp-jututkin mukaan?
#	[ $? -eq 0 ] || exit 3
#
#	${shary} libev4
#	${shary} libgetdns10 libbsd0 libidn2-0 libssl3 libunbound8 libyaml-0-2 #sotkeekohan libc6 uudelleenas tässä?
#	${shary} stubby
#
#	${lftr} 
#
#	#HUOM. jos aikoo gpg'n tuoda takaisin ni jotenkin fiksummin kuin aiempi häsläys kesällä
#	${odio} shred -fu  ~/Desktop/minimize/${distro}/*.deb
#
#	#HUOM.070325: varm vuoksi speksataan että *.deb
#	${odio} mv ${pkgdir}/*.deb ~/Desktop/minimize/${distro}
#	${srat} -rf ${1} ~/Desktop/minimize/${distro}/*.deb
#	#HUOM.260125: -p wttuun varm. vuoksi  
#}
#
#function tp2() {
#	[ y"${1}" == "y" ] && exit 1
#	[ -s ${1} ] || exit 2
#
#	#HUOM.260125: -p wttuun varm. vuoksi  
#	${srat} -rf ${1} /etc/iptables /etc/network/interfaces*
#
#	if [ ${enforce} -eq 1 ] ; then
#		dqb "das asdd"
#	else
#		${srat} -rf ${1} /etc/sudoers.d/meshuggah
#	fi
#
#	local f;for f in $(find /etc -type f -name 'stubby*') ; do ${srat} -rf ${1} ${f} ; done
#	for f in $(find /etc -type f -name 'dns*') ; do ${srat} -rf ${1} ${f} ; done
#
#	${srat} -rf ${1} /etc/init.d/net*
#	${srat} -rf ${1} /etc/rcS.d/S*net*
#}
#
##jopsa jatkossa ajaisi tp3 ennen tp2?
#function tp3() {
#	[ y"${1}" == "y" ] && exit 1
#	[ -s ${1} ] || exit 2
#
#	local p
#	local q	
#	tig=$(sudo which git)
#
#	p=$(pwd)
#	q=$(mktemp -d)
#	cd ${q}
#
#	${tig} clone https://github.com/senescent777/project.git
#
#	cd project
#	${spc} /etc/dhcp/dhclient.conf ./etc/dhcp/dhclient.conf.OLD
#	${spc} /etc/resolv.conf ./etc/resolv.conf.OLD
#	${spc} /sbin/dhclient-script ./sbin/dhclient-script.OLD
#
#	sudo mv ./etc/apt/sources.list ./etc/apt/sources.list.tmp #ehkä pois jatqssa
#	sudo mv ./etc/network/interfaces ./etc/network/interfaces.tmp
#
#	${sco} -R root:root ./etc; ${scm} -R a-w ./etc
#	${sco} -R root:root ./sbin; ${scm} -R a-w ./sbin
#	${srat} -rf ${1} ./etc ./sbin 
#	cd ${p}
#}
#
#function tpu() {
#	[ y"${1}" == "y" ] && exit 1
#	[ -s ${1} ] && exit 2
#
#	${odio} shred -fu ${pkgdir}/*.deb 
#	${odio} shred -fu ~/Desktop/minimize/${distro}/*.deb
#	${odio} ${d}/clouds.sh ${dnsm} 
#	${sifu} ${iface}
#
#
#	${sag} upgrade -u
#	${odio} mv ${pkgdir}/*.deb ~/Desktop/minimize/${distro}
#	${srat} -jcf ${1} ~/Desktop/minimize/${distro}/*.deb
#
#	${sifd} ${iface}
#}
#
#function tp5() {
#	dqb "5FF0RP"
#
#	local q
#	q=$(mktemp -d)
#	cd ${q}
#
#	#HUOM. prsofs kanssa olisi pikkuisen laittamista
#	${tig} clone https://github.com/senescent777/some_scripts.git
#
#	#VAIH:profs* lähteenä jatq0ssa
#	mv some_scripts/lib/export/profs* ~/Desktop/minimize/${distro}/
#	${scm} 0755 ~/Desktop/minimize/${distro}/profs*
#	${srat} -rvf ${1}  ~/Desktop/minimize/${distro}/profs*
#}
#mode=0
#tgtfile=""
#
##parsetus josqs käyttöön, ehkä
if [ $# -gt 0 ] ; then
	mode=${1}
	tgtfile=${2}
else
	echo "-h"
fi

case ${mode} in
	0)
		echo "tp1 ${tgtfile}"
		echo "tp2 ${tgtfile}"
		echo "tp3 ${tgtfile}"
		echo "tp4 ${tgtfile}"
#
#		#${srat} -tf ${tgtfile} > ./MANIFEST
#		#${srat} -rf ${tgtfile} ./MANIFEST
	;;
	1|u|upgrade)
		echo "tpu ${tgtfile}"
	;;
	p)
		echo "tp5 ${tgtfile}"
	;;
	e)
		echo "tp4 ${tgtfile}"
	;;
	-h)
		echo "$0 0 tgtfile distro | $0 1 tgtfile distro"
	;;
	*)
		echo "-h"
	;;
esac

