#!/bin/bash
d=$(dirname $0) #tarpeellinen?
debug=1
tgtfile=""
distro=""

case $# in
	3)
		tgtfile=${2}
		distro=${3}
	;;
	*)
		echo "$0 <mode> <tgtfile> <distro>"
	;;
esac

[ z"${distro}" == "z" ] && exit 6

if [ -d ~/Desktop/minimize/${distro} ] && [ -s ~/Desktop/minimize/${distro}/conf ]; then
	#HUOM. mielellään hanskat naulaan jos ei konf löydy
	
	. ~/Desktop/minimize/${distro}/conf
else
	echo "CONFIG MISSING"; exit 55
fi

debug=1
. ~/Desktop/minimize/common_lib.sh

if [ -d ~/Desktop/minimize/${distro} ] && [ -x ~/Desktop/minimize/${distro}/lib.sh ] ; then	
	. ~/Desktop/minimize/${distro}/lib.sh
else
	echo "L1B M1SSING";exit 66
fi

#HUOM.140325:syystä tässä kohtaa mode'n asxetus näin (ennen common_lib rodnäk myös ok)
mode=${1}
dqb "mode= ${mode}"

tig=$(sudo which git)
mkt=$(sudo which mktemp)
#debug=1 #TODO: jos parametriksi

if [ x"${tig}" == "x" ] ; then
	#HUOM. kts alempaa mitä git tarvitsee
	echo "sudo apt-get update;sudo apt-get install git"
	exit 7
fi

if [ x"${mkt}" == "x" ] ; then
	echo "sudo apt-get update;sudo apt-get install mktemp"
	exit 8
fi

sudo chown -Rv _apt:root /var/cache/apt/archives/partial/
sudo chmod -Rv 700 /var/cache/apt/archives/partial/
csleep 4

function pre() {
	[ x"${1}" == "z" ] && exit 666

	sudo chown -Rv _apt:root /var/cache/apt/archives/partial/
	sudo chmod -Rv 700 /var/cache/apt/archives/partial/
	csleep 4

	if [ -d ~/Desktop/minimize/${1} ] ; then
		dqb "5TNA"

		${scm} 0755 ~/Desktop/minimize/${1}
		${scm} 0755 ~/Desktop/minimize/*.sh
		${scm} 0755 ~/Desktop/minimize/${1}/*.sh
		
		if [ -s /etc/apt/sources.list.${1} ] ; then
			${smr} /etc/apt/sources.list
			${slinky} /etc/apt/sources.list.${1} /etc/apt/sources.list
		else
			part1_5 ${1}		
		fi

		csleep 2
	else
		echo "P.V.HH"
		exit 111
	fi
}

#TODO:glob muutt pois jatqssa jos mahd
function pre2() {
	[ x"${1}" == "z" ] && exit 666

	if [ -d ~/Desktop/minimize/${1} ] ; then
		dqb "PRKL"
		~/Desktop/minimize/clouds2.sh ${dnsm} ${1}		
		csleep 4
		
		${sifu} ${iface}
		[ ${debug} -eq 1 ] && /sbin/ifconfig
		csleep 4

		sudo chown -Rv _apt:root /var/cache/apt/archives/partial/
		sudo chmod -Rv 700 /var/cache/apt/archives/partial/
		
		${sag_u}
		csleep 4
	else
		echo "P.V.HH"
		exit 111
	fi
} 

function tp1() {
	dqb "tp1( ${1} , ${2} )"
	[ z"${1}" == "z" ] && exit
	dqb "params_ok"
	csleep 4

	${scm} -R a-wx ~/Desktop/minimize/*
	${scm} 0755 ~/Desktop/minimize

	if [ -d ~/Desktop/minimize/${2} ] ; then
		dqb "cleaning up ~/Desktop/minimize/${2} "
		csleep 4
		${NKVD} ~/Desktop/minimize/${2}/*.deb
		dqb "d0nm3"
	fi

	if [ ${enforce} -eq 1 ] ; then
		dqb "FORCEFED BROKEN GLASS"
		${srat} -cvf ~/Desktop/minimize/xfce.tar ~/.config/xfce4/xfconf/xfce-perchannel-xml 
		csleep 3

		local tget
		local p
		local f

		tget=$(ls ~/.mozilla/firefox/ | grep default-esr | tail -n 1)
		p=$(pwd)
		cd ~/.mozilla/firefox/${tget}
		dqb "TG3T=tget"		
		csleep 3

		#TODO:pitäsi ensin luoda se tar ennenq alkaa lisäämään
		for f in $(find . -name '*.js') ; do ${rat} -rf ~/Desktop/minimize/someparam.tar ${f} ; done
		#*.js ja *.json kai oleellisimmat kalat
		cd ${p}
	fi

	if [ ${debug} -eq 1 ] ; then
		ls -las ~/Desktop/minimize/; sleep 5
	fi
	
	${srat} -cvf ${1} ~/Desktop/minimize /home/stubby #HUOM.260125: -p wttuun varm. vuoksi  
	dqb "tp1 d0n3"
	csleep 3
}

#HUOM. pitäisiköhän tässä karsia joitain paketteja ettei tartte myöhemmin... no ehkö chimeran tapauksessa
#HUOM. erilllliseen oksennukseen liittyen kts main() , case e
function tp4() {
	dqb "tp4( ${1} , ${2} )"
	
	[ z"${1}" == "z" ] && exit 1
	[ -s ${1} ] || exit 2
	
	[ z"${2}" == "z" ] && exit 11
	[ -d  ~/Desktop/minimize/${2} ] || exit 22

	dqb "paramz_ok"
	csleep 4

	if [ z"${pkgdir}" != "z" ] ; then
		${NKVD} ${pkgdir}/*.deb
		dqb "SHREDDED HUMANS"
	fi

	dqb "EDIBLE AUTOPSY"

	#https://pkginfo.devuan.org/cgi-bin/package-query.html?c=package&q=netfilter-persistent=1.0.20
	${shary} libip4tc2 libip6tc2 libxtables12 netbase libmnl0 libnetfilter-conntrack3 libnfnetlink0 libnftnl11 
	${shary} iptables 	
	${shary} iptables-persistent init-system-helpers netfilter-persistent

	#actually necessary
	pre2 ${2}

	if [ ${dnsm} -eq 1 ] ; then
		${shary} libgmp10 libhogweed6 libidn2-0 libnettle8
		${shary} runit-helper

		${shary} dnsmasq-base dnsmasq dns-root-data #dnsutils
		${lftr} 

		#josqs ntp-jututkin mukaan?
		[ $? -eq 0 ] || exit 3

		${shary} libev4
		${shary} libgetdns10 libbsd0 libidn2-0 libssl3 libunbound8 libyaml-0-2 #sotkeekohan libc6 uudelleenas tässä?
		${shary} stubby
	fi

	echo "${shary} git mktemp in 4 secs"
	sleep 5
	${lftr} 

	#https://pkginfo.devuan.org/cgi-bin/package-query.html?c=package&q=git=1:2.39.2-1~bpo11+1
	#${shary} mktemp
	${shary} libcurl3-gnutls libexpat1 liberror-perl libpcre2-8-0 zlib1g 
	${shary} git-man git

	[ $? -eq 0 ] && dqb "TOMB OF THE MUTILATED"	
	sleep 6
	${lftr}

	#HUOM. jos aikoo gpg'n tuoda takaisin ni jotenkin fiksummin kuin aiempi häsläys kesällä
	if [ -d ~/Desktop/minimize/${2} ] ; then 
		${NKVD} ~/Desktop/minimize/${2}/*.deb
	
		#HUOM.070325: varm vuoksi speksataan että *.deb
		${odio} mv ${pkgdir}/*.deb ~/Desktop/minimize/${2}
		${srat} -rf ${1} ~/Desktop/minimize/${2}/*.deb
	fi

	#HUOM.260125: -p wttuun varm. vuoksi  
	dqb "tp4 donew"
	csleep 3
}

function tp2() {
	dqb "tp2 ${1} ${2}"
	[ y"${1}" == "y" ] && exit 1
	[ -s ${1} ] || exit 2
	dqb "params_ok"
	csleep 5

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

	dqb "tp2 done"
	csleep 4
}

function tp3() {
	dqb "tp3 ${1} ${2}"
	[ y"${1}" == "y" ] && exit 1
	[ -s ${1} ] || exit 2
	dqb "paramz_0k"
	csleep 4

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

	dqb "tp3 done"
	csleep 4
}

function tpu() {
	dqb "tpu( ${1}, ${2})"
	[ y"${1}" == "y" ] && exit 1
	[ -s ${1} ] && mv ${1} ${1}.OLD #oli exit aiemmin
	
	[ z"${2}" == "z" ] && exit 11
	[ -d  ~/Desktop/minimize/${2} ] || exit 22
	dqb "params_ok"

	#pitäisiköhän kohdehmistostakin poistaa paketit?
	${NKVD} ${pkgdir}/*.deb
	#${smr}  ${pkgdir}/*.deb
#	${smr}  ${pkgdir}/*.bin

	dqb "TUP PART 2"

	#${sag} upgrade -u
	sudo apt-get upgrade -u
	echo $?
	csleep 5	

	dqb "UTP PT 3"
	${odio} mv ${pkgdir}/*.deb ~/Desktop/minimize/${2}
	${srat} -cf ${1} ~/Desktop/minimize/${2}/*.deb
	${sifd} ${iface}

	dqb "SIELUNV1H0LL1N3N"
}

#TODO:ao- if-blkkiin liittyen jos poistaisi ghubista minimize-hamistosta välistä sen /h/d-osuuden

function tp5() {
	dqb "tp5 ${1} ${2}"
	[ z"${1}" == "z" ] && exit 99
	#[ -s  ${1} ] || exit 98

	dqb "params ok"
	csleep 5

	local q
	q=$(mktemp -d)
	cd ${q}
	[ $? -eq 0 ] || exit 77

	${tig} clone https://github.com/senescent777/some_scripts.git
	[ $? -eq 0 ] || exit 99

	mv some_scripts/lib/export/profs* ~/Desktop/minimize 
	${scm} 0755 ~/Desktop/minimize/profs*
	${srat} -rvf ${1} ~/Desktop/minimize/profs*

	dqb "AAMUNK01"
}

dqb "mode= ${mode}"
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
		#HUOM.20325:toimisokohan tämä jo?
		pre2 ${distro}
		tpu ${tgtfile} ${distro}
	;;
	p)
		#HUOM.20325:toimisokohan tämä jo?
		pre2 ${distro}
		tp5 ${tgtfile}
	;;
	e)
		pre2 ${distro}
		tp4 ${tgtfile} ${distro}
	;;
esac

