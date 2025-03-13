#!/bin/bash
d=$(dirname $0)
debug=1

if [ $# -gt 2 ] ; then
	if [ -d ~/Desktop/minimize/${3} ] ; then
		#HUOM. mielellään hanskat naulaan jos ei konf löydy
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

tig=$(sudo which git)
mkt=$(sudo which mktemp)
debug=1 #TODO: jos parametriksi

if [ x"${tig}" == "x" ] ; then
	#HUOM. kts alempaa mitä git tarvitsee
	echo "sudo apt-get update;sudo apt-get install git"
	exit 7
fi

if [ x"${mkt}" == "x" ] ; then
	echo "sudo apt-get update;sudo apt-get install mktemp"
	exit 8
fi

#TODO:jatkjossa yleisemmän kaavan mukaan nuo sudotukset
function pre() {
	[ x"${1}" == "z" ] && exit 666

	if [ -d ~/Desktop/minimize/${1} ] ; then
		echo "5TNA"
		sudo chmod 0755 ~/Desktop/minimize/${1}
		#HUOM. pitäisköhän olla myös minimize/*.sh ?
		sudo chmod 0755 ~/Desktop/minimize/${1}/*.sh
		
		#tai jos pre1:seen tämä jatkossa...
		if [ -s /etc/apt/sources.list.${1} ] ; then
			${odio} rm /etc/apt/sources.list
			${odio} ln -s /etc/apt/sources.list.${1} /etc/apt/sources.list
		fi

		sleep 3
	else
		echo "P.V.HH"
		exit 111
	fi
}

#TODO:glob muutt pois jatqssa jos mahd
function pre2() {
	[ x"${1}" == "z" ] && exit 666

	if [ -d ~/Desktop/minimize/${1} ] ; then
		echo "PRKL"
		sudo ~/Desktop/minimize/${1}/clouds.sh ${dnsm}
		sudo /sbin/ifup ${iface}

		sudo apt-get update
	else
		echo "P.V.HH"
		exit 111
	fi
} 

function tp1() {
	echo "tp1( ${1} , ${2} )"
	[ z"${1}" == "z" ] && exit
	echo "params_ok"
	sleep 4

	${scm} -R a-wx ~/Desktop/minimize/*
	${scm} 0755 ~/Desktop/minimize

	if [ -d ~/Desktop/minimize/${2} ] ; then
		dqb "cleaning up ~/Desktop/minimize/${2} "
		${odio} shred -fu ~/Desktop/minimize/${2}/*.deb
	fi

	if [ ${enforce} -eq 1 ] ; then
		${srat} -cvf ~/Desktop/minimize/xfce.tar ~/.config/xfce4/xfconf/xfce-perchannel-xml 
		
		#HUOM.100325: pitäisiköhän se .mozilla:n vetäminen mukaan jollain ehdolla?	
		#HUOM.110325: ei suoraan tar, miel find:in kautta
		#TODO:jopsa vähitellen kasaisi tuon tar'in find:illa

		#*.js ja *.json kai oleellisimmat kalat
		#${srat} -cvf ~/Desktop/minimize/someparam.tar ~/.mozilla #arpoo arpooo
	fi

	if [ ${debug} -eq 1 ] ; then
		ls -las ~/Desktop/minimize/; sleep 10
	fi
	
	${srat} -cvf ${1} ~/Desktop/*.desktop ~/Desktop/minimize /home/stubby #HUOM.260125: -p wttuun varm. vuoksi  
	echo "tp1 d0n3"
	sleep 3
}

#HUOM. pitäisiköhän tässä karsia joitain paketteja ettei tartte myöhemmin... no ehkö chimeran tapauksessa
#HUOM. erilllliseen oksennukseen liittyen kts main() , case e
function tp4() {
	echo "tp4( ${1} , ${2} )"
	
	[ z"${1}" == "z" ] && exit 1
	[ -s ${1} ] || exit 2
	
	[ z"${2}" == "z" ] && exit 11
	[ -d  ~/Desktop/minimize/${2} ] || exit 22

	dqb "paramz_ok"
	sleep 4

	if [ z"${pkgdir}" != "z" ] ; then 
		${odio} shred -fu ${pkgdir}/*.deb
		dqb "SHREDDED HUMANS"
	fi

	#HUOM.140325: ao. blokki liene ejo turha koska pre
	if [ -s /etc/apt/sources.list.${2} ] ; then
		${odio} rm /etc/apt/sources.list
		${odio} ln -s /etc/apt/sources.list.${2} /etc/apt/sources.list
	fi

	dqb "EDIBLE AUTOPSY"

	#https://pkginfo.devuan.org/cgi-bin/package-query.html?c=package&q=netfilter-persistent=1.0.20
	${shary} libip4tc2 libip6tc2 libxtables12 netbase libmnl0 libnetfilter-conntrack3 libnfnetlink0 libnftnl11 
	${shary} iptables 	
	${shary} iptables-persistent init-system-helpers netfilter-persistent

	#actually necessary
	pre2 ${2}

	${shary} libgmp10 libhogweed6 libidn2-0 libnettle8
	${shary} runit-helper

	${shary} dnsmasq-base dnsmasq dns-root-data #dnsutils
	${lftr} 

	#josqs ntp-jututkin mukaan?
	[ $? -eq 0 ] || exit 3

	${shary} libev4
	${shary} libgetdns10 libbsd0 libidn2-0 libssl3 libunbound8 libyaml-0-2 #sotkeekohan libc6 uudelleenas tässä?
	${shary} stubby

	echo "${shary} git mktemp in 4 secs"
	sleep 5
	#${lftr} 

	#https://pkginfo.devuan.org/cgi-bin/package-query.html?c=package&q=git=1:2.39.2-1~bpo11+1
	#${shary} mktemp
	${shary} libcurl3-gnutls libexpat1 liberror-perl libpcre2-8-0 zlib1g 
	${shary} git-man git

	[ $? -eq 0 ] && echo "TOMB OF THE MUTILATED"	
	sleep 6
	${lftr}

	#HUOM. jos aikoo gpg'n tuoda takaisin ni jotenkin fiksummin kuin aiempi häsläys kesällä
	if [ -d ~/Desktop/minimize/${2} ] ; then 
		${odio} shred -fu ~/Desktop/minimize/${2}/*.deb
	
		#HUOM.070325: varm vuoksi speksataan että *.deb
		${odio} mv ${pkgdir}/*.deb ~/Desktop/minimize/${2}
		${srat} -rf ${1} ~/Desktop/minimize/${2}/*.deb
	fi

	#HUOM.260125: -p wttuun varm. vuoksi  
	echo "tp4 donew"
	sleep 3
}

function tp2() {
	echo "tp2 ${1} ${2}"
	[ y"${1}" == "y" ] && exit 1
	[ -s ${1} ] || exit 2
	echo "params_ok"
	sleep 5

	#HUOM.260125: -p wttuun varm. vuoksi  
	${srat} -rf ${1} /etc/iptables /etc/network/interfaces*

	if [ ${enforce} -eq 1 ] ; then
		dqb "das asdd"
	else
		${srat} -rf ${1} /etc/sudoers.d/meshuggah
	fi

	local f;for f in $(find /etc -type f -name 'stubby*') ; do ${srat} -rf ${1} ${f} ; done
	for f in $(find /etc -type f -name 'dns*') ; do ${srat} -rf ${1} ${f} ; done

	${srat} -rf ${1} /etc/init.d/net*
	${srat} -rf ${1} /etc/rcS.d/S*net*
	echo "tp2 done"
	sleep 4
}

function tp3() {
	echo "tp3 ${1} ${2}"
	[ y"${1}" == "y" ] && exit 1
	[ -s ${1} ] || exit 2
	echo "paramz_0k"
	sleep 4

	local p
	local q	
	tig=$(sudo which git)

	p=$(pwd)
	q=$(mktemp -d)
	cd ${q}

	${tig} clone https://github.com/senescent777/project.git
	[ $? -eq 0 ] || exit 66
	cd project

	${spc} /etc/dhcp/dhclient.conf ./etc/dhcp/dhclient.conf.OLD
	${spc} /etc/resolv.conf ./etc/resolv.conf.OLD
	${spc} /sbin/dhclient-script ./sbin/dhclient-script.OLD

	sudo mv ./etc/apt/sources.list ./etc/apt/sources.list.tmp #ehkä pois jatqssa
	sudo mv ./etc/network/interfaces ./etc/network/interfaces.tmp

	${sco} -R root:root ./etc; ${scm} -R a-w ./etc
	${sco} -R root:root ./sbin; ${scm} -R a-w ./sbin
	${srat} -rf ${1} ./etc ./sbin 
	
	cd ${p}
	${sifd} ${iface}
	echo "tp3 done"
	sleep 4
}

function tpu() {
	dqb "tpu( ${1}, ${2})"
	[ y"${1}" == "y" ] && exit 1
	[ -s ${1} ] && exit 2
	
	[ z"${2}" == "z" ] && exit 11
	[ -d  ~/Desktop/minimize/${2} ] || exit 22
	dqb "params_ok"

	${odio} shred -fu ${pkgdir}/*.deb #HUOM.pois kommenteista?
	
#	if [ -s /etc/apt/sources.list.${2} ] ; then
#		${odio} rm /etc/apt/sources.list
#		${odio} ln -s /etc/apt/sources.list.${2} /etc/apt/sources.list
#	fi

	${sag} upgrade -u
	${odio} mv ${pkgdir}/*.deb ~/Desktop/minimize/${2}
	${srat} -cf ${1} ~/Desktop/minimize/${2}/*.deb
	${sifd} ${iface}

	echo "SIELUNV1H0LL1N3N"
}

#TODO:ao- if-blkkiin liittyen jos poistaisi ghubista minimize-hamistosta välistä sen /h/d-osuuden

function tp5() {
	echo "tp5 ${1} ${2}"
	[ z"${1}" == "z" ] && exit 99
	[ -s  ${1} ] || exit 98

	echo "params ok"
	sleep 5

	local q
	q=$(mktemp -d)
	cd ${q}
	[ $? -eq 0 ] || exit 77

	${tig} clone https://github.com/senescent777/some_scripts.git
	[ $? -eq 0 ] || exit 99

	mv some_scripts/lib/export/profs* ~/Desktop/minimize 
	${scm} 0755 ~/Desktop/minimize/profs*
	${srat} -rvf ${1} ~/Desktop/minimize/profs*

	echo "AAMUNK01"
}

mode=0
tgtfile=""

#parsetus josqs käyttöön, ehkä (pärjäisiköhän ilman else-haaraa jo?)
if [ $# -gt 0 ] ; then
	mode=${1}
	tgtfile=${2}
else
	echo "-h"
	exit
fi

pre ${distro}

case ${mode} in
	0)
		tp1 ${tgtfile} ${distro}

		pre ${distro}
		pre2 ${distro}		
		tp3 ${tgtfile} ${distro}

		pre ${distro}
		tp2 ${tgtfile} ${distro}

		pre ${distro}
		pre2 ${distro}
		tp4 ${tgtfile} ${distro}
	;;
	1|u|upgrade)
		pre2 ${distro}
		tpu ${tgtfile} ${distro}
	;;
	p)
		pre2 ${distro}
		tp5 ${tgtfile}
	;;
	e)
		pre2 ${distro}
		tp4 ${tgtfile} ${distro}
	;;
	-h)
		echo "$0 0 tgtfile distro | $0 1 tgtfile distro"
	;;
	*)
		echo "-h"
	;;
esac

