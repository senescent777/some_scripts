#!/bin/bash
#
#mode=0
#frist=0
#debug=1
#tgtfile=/tmp/out.tar 
#dnsm=0
#
#function parse_opts_1 () {
#	case ${1} in
#		-v|--v)
#			debug=1
#		;;
#		-h)
#			echo "$0 <mode> [-o ouftile] [-i infile] [-v]"
#			exit
#		;;
#		*)
#			if [ ${frist} -eq 0 ] ; then 
#				mode=${1}
#				frist=1
#			fi
#		;;
#	esac
#}
#
#function parse_opts_2() {
#	case "${1}" in
#		-o|--o|-i|--i)
#			tgtfile=${2}
#		;;
#	esac
#}
#
#function check_params() {
#	dqb "check_params( ${1} )"
#	[ -s ${1} ] && echo "${1} alr3ady 3x1st5"
#	local d
#	
#	d=$(dirname ${1})
#	[ -d ${d} ] || echo "no such dir as ${d}"
#}
#
#. ./libd
#
##HUOM. löytyy myös se out4.tar
#function make_tar() {
#	dqb "make_tar ( ${1} )"
#	csleep 1
#
#	dqb "sa= ${sa}"
#	csleep 5
#
#	dqb "shary= ${shary}"
#	csleep 5
#
#	dqb "${sa} --fix-broken install"
#	${sa} --fix-broken install
#	csleep 1
#	sudo /opt/bin/cloudsd.sh ${dnsm}
#
#	${shary} dnsmasq-base runit-helper dnsmasq libev4
#
#	csleep 1
#	sudo /opt/bin/cloudsd.sh ${dnsm}
#	csleep 1
#	
#	${shary} libip4tc2 libip6tc2 libxtables12 netbase libmnl0 libnetfilter-conntrack3 libnfnetlink0 libnftnl11 iptables
#	[ $? -eq 0 ] || exit 1	
#	${smr} -rf /run/live/medium/live/initrd.img*
#	
#	csleep 1
#	sudo /opt/bin/cloudsd.sh ${dnsm}
#	csleep 1
#
#	${shary} init-system-helpers netfilter-persistent iptables-persistent
#	[ $? -eq 0 ] || exit 2
#	${smr} -rf /run/live/medium/live/initrd.img*
#
#	csleep 1
#	sudo /opt/bin/cloudsd.sh ${dnsm}
#	csleep 1
#
#	#${shary} python3-ntp ntpsec-ntpdate
#	[ $? -eq 0 ] || exit 3
#	
#	csleep 1
#	sudo /opt/bin/clouds.sh ${dnsm}
#	csleep 1
#
#	dqb "${shary} dnsmasq-base runit-helper"
#	csleep 1
#
#	#https://pkginfo.devuan.org/cgi-bin/package-query.html?c=package&q=dnsmasq=2.85-1
#	${shary} dnsmasq-base runit-helper
#	[ $? -eq 0 ] || exit 4
#	${smr} -rf /run/live/medium/live/initrd.img*
#
#	csleep 1
#	sudo /opt/bin/cloudsd.sh ${dnsm}
#	csleep 1
#
#	#dqb "${shary} dnsmasq-base runit-helper"
#	#csleep 1
#
#	dqb "${shary} libev4 "
#	csleep 1
#
#	${shary} libev4 
#	[ $? -eq 0 ] || exit 5
#
#	csleep 1
##	csleep 1
#
##
#	dqb "${shary} dnsmasq"
#	csleep 1
#
#	${shary} dnsmasq
#	sudo /opt/bin/cloudsd.sh ${dnsm}
#	csleep 1
#
#	${smr} -rf /run/live/medium/live/initrd.img*
#	csleep 5
#
#	sudo /opt/bin/cloudsd.sh ${dnsm}
#	csleep 1
#
#	${shary} libgetdns10 libbsd0 libidn2-0 libssl1.1 libunbound8 libyaml-0-2 stubby
#	[ $? -eq 0 ] || exit 6
#	${smr} -rf /run/live/medium/live/initrd.img*
#	
#	csleep 1
#	sudo /opt/bin/cloudsd.sh ${dnsm}
#	csleep 1
#
#	${srat} -cvpf ${1} /var/cache/apt/archives/*.deb ~/Desktop/minimize ~/.gnupg /opt/bin
#	${srat} -rvpf ${1} /home/stubby /etc/sudoers.d/meshuggah /etc/iptables /etc/network/interfaces*
#	
#	local f;for f in $(find /etc -type f -name 'stubby*') ; do ${srat} -rvpf ${1} ${f} ; done
#	for f in $(find /etc -type f -name 'dns*') ; do ${srat} -rvpf ${1} ${f} ; done
#
#	${srat} -rvpf ${1} /etc/init.d/net*
#	${srat} -rvpf ${1} /etc/rcS.d/S*net*
#	csleep 5
#}
#
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
#	sudo /opt/bin/cloudsd.sh ${dnsm}
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
#	sudo /opt/bin/cloudsd.sh ${dnsm}
#	csleep 1
#
#	#olisi kiva jos ei tarvitsisi koko projektia vetää, wget -r tjsp
#	${tig} clone https://github.com/senescent777/project.git
#
#	sudo /opt/bin/cloudds.sh ${dnsm}
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
#
#function make_upgrade() {
#	dqb "make_upgrade(${1} )"
#	dqb "${sag} upgrade -u"
#
#	sudo /opt/bin/clouds.sh ${dnsm}
#	csleep 1
#
#	${sag} upgrade -u
#	${srat} -cvpf ${1} /var/cache/apt/archives 
#
#	sudo /opt/bin/cloudsd.sh ${dnsm}
#	csleep 1
#}
#
#if [ $# -gt 0 ] ; then
#	parse_opts_2 ${2} ${3}
#	for opt in $@ ; do parse_opts_1 ${opt} ; done
#
#	dqb "if this script doesn't work, try /opt/bin/cloudsd.sh"	
#	sudo /opt/bin/cloudsd.sh ${dnsm}
#	csleep 1
#
#	${asy}
#	${sag_u} 
#
#	sudo /opt/bin/cloudsd.sh ${dnsm}
#	csleep 1
#
#	#[ $? -eq 0 ] || echo "/o/b/cloudsd.sh <mode> | ${sifu} -a | ${sifu} ${iface}";exit
#else
#	echo "$0 -h";exit
#fi
#
#check_params ${tgtfile}
##main()
#gg=$(sudo which gpg)
#
##VAIH:josko gpg allekirjoittamaan tar:it mikäli .gnupg olemassa ja täts it
##https://github.com/senescent777/some_scripts/blob/main/skripts/export/mksums_new.sh.export voisi ottaa mallia
#g#pg -u <param1> -sb <file> lienee se keskeinen juttu 
#
#case ${mode} in
#	0)
#		make_tar ${tgtfile}
#		make_tar2 ${tgtfile}
#	;;
#	1)
#		#päällekkäinen toiminto export.sh kanssa?
#		make_upgrade ${tgtfile}
#	;;
##	2)
##		cd /
##		${srat} -xvpf ${tgtfile}
##		#vöib mennä päällekkäin import.sh kanssa
##		${sdi} /var/cache/apt/archives/perl-modules-5.32*.deb
##		[ $? -eq 0 ] && ${smr} -rf ${pkgdir}/perl-modules-5.32*.deb
##
##		part3
##	;;
#	3)
#		if [ x"$gg" == "x" ] ; then 
#			sudo /opt/bin/cloudsd.sh ${dnsm}
#			csleep 1	
#			${sag} install gpg pinentry-tty gpg-agent
#
#			csleep 1
#			sudo /sbin/ifdown -a
#			csleep 4
#
#			gg=$(sudo which gpg)
#			${gg} --quick-generate-key tester
#		fi
#	
#		#fiksumpi ehto sopisi löytyä
#		#[ -d ~/.gnupg ] ||
#
#		#VAIH:joitain gpg:n huomioiva versio make_upgRade():sta tähän
#		#${gz} --sign --create ${tgtfile}.s /var/cache/apt/archives/
#	;;
##	4)
##		
##		if [ x"$gz" == "x" ] ; then 
##			sudo /opt/bin/clouds.sh ${dnsm}
##			csleep 1
##
##			${sag} install gpg
##		fi
##
#	#	#VAIH:gpg-allekIRjoitukset huomioiva tar-purku tähän
#	#	echo "mount;gpgtar -x"
#	#;;
#	*)
#		echo "-h"
#	;;
#esac
#
#if [ -x ${gg} ] ; then
#	if [ -s  ${tgtfile} ] ; then
##		gpg -u tester -sb ${tgtfile}
#		dqb "cp ${tgtfile}* targetdir"
#	fi
#fi