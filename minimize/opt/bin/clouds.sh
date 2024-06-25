#!/bin/bash

debug=1 #TODO:jos komentoriviparametriksi
. ~/Desktop/minimize/lib

#TODO:/etc/network/if*.d/ alaiset skriptit, voisiko niiden kanssa leipoa yhteen jotenkin?
#kts. https://github.com/senescent777/some_scripts/blob/main/lib/d227D33.sh.export liittyen

function tod_dda() {
	${ipt} -A b -p tcp --sport 853 -s ${1} -j c
	${ipt} -A e -p tcp --dport 853 -d ${1} -j f
}

function dda_snd() {
	${ipt} -A b -p udp -m udp -s ${1} --sport 53 -j ACCEPT 
	${ipt} -A e -p udp -m udp -d ${1} --dport 53 -j ACCEPT 
}

#mallia https://github.com/senescent777/project/blob/main/opt/bin/install.sh , https://github.com/senescent777/project/blob/main/opt/bin/install.sh , https://github.com/senescent777/project/blob/main/home/devuan/Dpckcer/buildr/source/scripts/part4.sh 

dqb "coluds(${1})"
#VAIH:rm ja muut, toisella tavalla
${smr} /etc/resolv.conf
${smr} /etc/dhcp/dhclient.conf
${smr} /sbin/dhclient-script
csleep 1

#tässä oikea paikka tables-muutoksille vai ei?
${ipt} -F b
${ipt} -F e
${ipt} -D INPUT 5
${ipt} -D OUTPUT 6
#local s #/opt/bin/clouds.sh: line 33: local: can only be used in a function
csleep 1

dqb "spc= ${spc}"
csleep 1

case ${1} in #{$mode} jatkossa
	0)
		${slinky} /etc/resolv.conf.OLD /etc/resolv.conf
		${slinky} /etc/dhcp/dhclient.conf.OLD /etc/dhcp/dhclient.conf
		${spc} /sbin/dhclient-script.OLD /sbin/dhclient-script

		${ipt} -A INPUT -p udp -m udp --sport 53 -j b 
		${ipt} -A OUTPUT -p udp -m udp --dport 53 -j e
		for s in $(grep -v '#' /etc/resolv.conf.OLD | grep names | grep -v 127. | awk '{print $2}') ; do dda_snd ${s} ; done	
	;;
	1)
		${slinky} /etc/resolv.conf.new /etc/resolv.conf
		${slinky} /etc/dhcp/dhclient.conf.new /etc/dhcp/dhclient.conf
		${spc} /sbin/dhclient-script.new /sbin/dhclient-script
	
		${ipt} -A INPUT -p tcp -m tcp --sport 853 -j b
		${ipt} -A OUTPUT -p tcp -m tcp --dport 853 -j e
		for s in $(grep -v '#' /home/stubby/.stubby.yml | grep address_data | cut -d ':' -f 2) ; do tod_dda ${s} ; done
	;;
	*)
		echo "ERROR TERROR"
	;;
esac

${scm} 0444 /etc/resolv.conf*
${sco} root:root /etc/resolv.conf*

${scm} 0444 /etc/dhcp/dhclient*
${sco} root:root /etc/dhcp/dhclient*
${scm} 0755 /etc/dhcp

${scm} 0555 /sbin/dhclient*
${sco} root:root /sbin/dhclient*
${scm} 0755 /sbin

${sco} -R root:root /etc/iptables
${scm} 0400 /etc/iptables/*
${scm} 0750 /etc/iptables
sleep 2

if [ ${debug} -eq 1 ] ; then
	${ipt} -L  #
	${ip6t} -L #
	ls -las /sbin/dhc*
	sleep 5
fi #
