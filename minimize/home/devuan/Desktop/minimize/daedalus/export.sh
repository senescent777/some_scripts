#!/bin/bash
d=$(dirname $0)
debug=1
. ~/Desktop/minimize/common_lib.sh

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
	csleep 1
	[ z"${1}" == "z" ] && exit

	${scm} -R a-wx ~/Desktop/minimize/*
	${scm} 0755 ~/Desktop/minimize;${scm} 0755 ~/Desktop/minimize/${distro}
	${scm} a+x ~/Desktop/minimize/${distro}/*.sh

	${odio} shred -fu ~/Desktop/minimize/${distro}/*.deb
	if [ ${enforce} -eq 1 ] ; then
		${srat} -cvf ~/Desktop/minimize/xfce.tar ~/.config/xfce4/xfconf/xfce-perchannel-xml 
		#HUOM.100325: pitäisiköhän se .mozilla:n vetäminen mukaan jollain ehdolla?	
		${srat} -cvf ~/Desktop/minimize/someparam.tar ~/.mozilla #arpoo arpooo
	fi

	if [ ${debug} -eq 1 ] ; then
		ls -las ~/Desktop/minimize/; sleep 10
	fi
	
	${srat} -cvf ${1} ~/Desktop/*.desktop ~/Desktop/minimize /home/stubby #HUOM.260125: -p wttuun varm. vuoksi  
}

#HUOM. pitäisiköhän tässä karsia joitain paketteja ettei tartte myöhemmin... no ehkö chimeran tapauksessa
function make_tar_15() {
	csleep 4
	
	if [ z"${pkgdir}" != "z" ] ; then 
		${odio} shred -fu ${pkgdir}/*.deb
	fi
	
	[ z"${1}" == "z" ] && exit 1
	[ -s ${1} ] || exit 2

	${sag_u}
	[ $? -eq 0 ] || exit	
	csleep 1

	#https://pkginfo.devuan.org/cgi-bin/package-query.html?c=package&q=netfilter-persistent=1.0.20
	${shary} libip4tc2 libip6tc2 libxtables12 netbase libmnl0 libnetfilter-conntrack3 libnfnetlink0 libnftnl11 
	${shary} iptables 	
	${shary} iptables-persistent init-system-helpers netfilter-persistent

	#actually necessary block
	csleep 5
	sudo ${d}/clouds.sh ${dnsm}
	${sifu} ${iface}
	csleep 5

	${shary} libgmp10 libhogweed6 libidn2-0 libnettle8
	${shary} runit-helper

	${shary} dnsmasq-base dnsmasq dns-root-data #dnsutils
	${lftr} 

	#josqs ntp-jututkin mukaan?
	[ $? -eq 0 ] || exit 3

	${shary} libev4
	${shary} libgetdns10 libbsd0 libidn2-0 libssl3 libunbound8 libyaml-0-2 #sotkeekohan libc6 uudelleenas tässä?
	${shary} stubby

	${lftr} 

	#HUOM. jos aikoo gpg'n tuoda takaisin ni jotenkin fiksummin kuin aiempi häsläys kesällä
	${odio} shred -fu  ~/Desktop/minimize/${distro}/*.deb
	sleep 4 

	#HUOM.070325: varm vuoksi speksataan että *.deb
	${odio} mv ${pkgdir}/*.deb ~/Desktop/minimize/${distro}
	${srat} -rf ${1} ~/Desktop/minimize/${distro}/*.deb
	#HUOM.260125: -p wttuun varm. vuoksi  
}

#tässäkin se -c -r:n sijaan voi sotkea 
function make_tar_1_75() {
	csleep 1
	
	[ y"${1}" == "y" ] && exit 1
	[ -s ${1} ] || exit 2
	csleep 1

	#HUOM.260125: -p wttuun varm. vuoksi  
	${srat} -rf ${1} /etc/iptables /etc/network/interfaces*

	if [ ${enforce} -eq 1 ] ; then
		echo "das asdd"
	else
		${srat} -rf ${1} /etc/sudoers.d/meshuggah
	fi

	local f;for f in $(find /etc -type f -name 'stubby*') ; do ${srat} -rf ${1} ${f} ; done
	for f in $(find /etc -type f -name 'dns*') ; do ${srat} -rf ${1} ${f} ; done

	${srat} -rf ${1} /etc/init.d/net*
	${srat} -rf ${1} /etc/rcS.d/S*net*
	csleep 5
}

#2 jälkeen 1_75 -> saattaa paikata puutteet (tai miten lienee)
function make_tar2() {
	csleep 1

	[ y"${1}" == "y" ] && exit 1
	[ -s ${1} ] || exit 2
	csleep 1

	local p
	local q	
	local tig
	tig=$(sudo which git)
	
	csleep 1

	if [ x"${tig}" == "x" ] ; then
		${shary} git
		[ $? -eq 0 ] || exit 7
	fi

	csleep 5
	tig=$(sudo which git)

	p=$(pwd)
	q=$(mktemp -d)
	cd ${q}

	${tig} clone https://github.com/senescent777/project.git
	csleep 1

	cd project
	${spc} /etc/dhcp/dhclient.conf ./etc/dhcp/dhclient.conf.OLD
	${spc} /etc/resolv.conf ./etc/resolv.conf.OLD
	${spc} /sbin/dhclient-script ./sbin/dhclient-script.OLD

	sudo mv ./etc/apt/sources.list ./etc/apt/sources.list.tmp #ehkä pois jatqssa
	sudo mv ./etc/network/interfaces ./etc/network/interfaces.tmp

	csleep 5

	${sco} -R root:root ./etc; ${scm} -R a-w ./etc
	${sco} -R root:root ./sbin; ${scm} -R a-w ./sbin
	${srat} -rf ${1} ./etc ./sbin 
	cd ${p}
}

function make_upgrade() {
	csleep 1
	
	[ y"${1}" == "y" ] && exit 1
	[ -s ${1} ] && exit 2
	csleep 1

	${odio} shred -fu ${pkgdir}/*.deb 
	${odio} shred -fu ~/Desktop/minimize/${distro}/*.deb

	${odio} ${d}/clouds.sh ${dnsm} 
	${sifu} ${iface}	
	sleep 6

	${asy} 
	sleep 4

	echo "${sag_u}"; sleep 4
	${sag_u}

	echo "${sag} upgrade -u";sleep 5
	${sag} upgrade -u
	${odio} mv ${pkgdir}/*.deb ~/Desktop/minimize/${distro}
	${srat} -jcf ${1} ~/Desktop/minimize/${distro}/*.deb

	${sifd} ${iface}
	sleep 1
}

function prof5() {
	echo "5FF0RP"

	#TODO:git'in asnenusta varteb oma palikka tjsp
	sudo apt-get update
	sudo apt-get install git
	q=$(mktemp -d)
	cd ${q}

	#HUOM. prsofs kanssa olisi pikkuisen laittamista
	git clone https://github.com/senescent777/some_scripts.git

	#VAIH:profs* lähteenä jatq0ssa
	mv some_scripts/lib/export/profs* ~/Desktop/minimize/${distro}/
	${scm} 0755 ~/Desktop/minimize/${distro}/profs*
	${srat} -rvf ${1}  ~/Desktop/minimize/${distro}/profs*
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

#oma case sille profs.sh-jutulle?
case ${mode} in
	0)
		#jos nimeäisi fktiot uusiksi josqs
		make_tar ${tgtfile}
		make_tar_1_75 ${tgtfile}
		make_tar2 ${tgtfile}
		make_tar_15 ${tgtfile}

		#VAIH:manifest-jutut aivan viimeisenä (main())
		${srat} -tf ${1} > ./MANIFEST
		${srat} -rf ${1} ./MANIFEST
	;;
	1|u|upgrade)
		make_upgrade ${tgtfile}
	;;
	p)
		prof5 ${tgtfile}
	;;
	-h)
		echo "$0 0 tgtfile | $0 1 tgtfile"
	;;
	*)
		echo "-h"
	;;
esac

