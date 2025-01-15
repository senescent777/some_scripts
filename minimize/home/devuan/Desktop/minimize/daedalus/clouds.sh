#!/bin/bash

smr=$(sudo which rm)
ipt=$(sudo which iptables)
ip6t=$(sudo which ip6tables)
iptr=$(sudo which iptables-restore)
ip6tr=$(sudo which ip6tables-restore)
slinky=$(sudo which ln)
spc=$(sudo which cp)
slinky="${slinky} -s "
sco=$(sudo which chown)
scm=$(sudo which chmod)
debug=0

function dqb() {
	[ ${debug} -eq 1 ] && echo ${1}
}

function csleep() {
	[ ${debug} -eq 1 ] && sleep ${1}
}

if [ -s /etc/resolv.conf.new ] || [ -s /etc/resolv.conf.OLD ] ; then 
	${smr} /etc/resolv.conf
fi

if [ -s /etc/dhcp/dhclient.conf.new ] || [ -s /etc/dhcp/dhclient.conf.OLD ] ; then 
	${smr} /etc/dhcp/dhclient.conf
fi

#ei välttis suhtaudu hyvin lib.sh:n alkuun, tulisi siirtää seur. if-blokin jölkeen
if [ -s /sbin/dhclient-script.new ] || [ -s /sbin/dhclient-script.OLD ] ; then 
	${smr} /sbin/dhclient-script
fi

[ $? -gt 0 ] && echo "SHOULD USE SUDO WITH THIS SCRIPT"

#tässä oikea paikka tables-muutoksille vai ei?
if [ y"${ipt}" == "y" ] ; then
	echo "SHOULD 1NSTALL TABL35"
	. ./lib.sh #pitäisiköhän tässäkin olla se dirname-.jekku?
	pre_part3 ${pkgdir}
else
	#töässö klohtaa kai vähän parempi tuo sääntöjen pakottaminen kuin part1
	${iptr} /etc/iptables/rules.v4
	${ip6tr} /etc/iptables/rules.v6
	sleep 3

	${ipt} -F b
	${ipt} -F e

	#pitäisiköhän liittyä nÄiden noihin dns/dot-juTTuihin? jep
	${ipt} -D INPUT 6 #aiemmin oli 5
	${ipt} -D OUTPUT 6
fi

function tod_dda() { 
	${ipt} -A b -p tcp --sport 853 -s ${1} -j c
        ${ipt} -A e -p tcp --dport 853 -d ${1} -j f
}

function dda_snd() {
	${ipt} -A b -p udp -m udp -s ${1} --sport 53 -j ACCEPT 
	${ipt} -A e -p udp -m udp -d ${1} --dport 53 -j ACCEPT
}

case ${1} in 
	0)
		${slinky} /etc/resolv.conf.OLD /etc/resolv.conf
		${slinky} /etc/dhcp/dhclient.conf.OLD /etc/dhcp/dhclient.conf
		${spc} /sbin/dhclient-script.OLD /sbin/dhclient-script

		if [ y"${ipt}" == "y" ] ; then
			dqb "SHOULD 1NSTALL TABL35"
		else
			${ipt} -A INPUT -p udp -m udp --sport 53 -j b 
			${ipt} -A OUTPUT -p udp -m udp --dport 53 -j e

			for s in $(grep -v '#' /etc/resolv.conf | grep names | grep -v 127. | awk '{print $2}') ; do dda_snd ${s} ; done	
		fi

		${odio} /etc/init.d/dnsmasq stop
		${odio} /etc/init.d/ntpsec stop
		csleep 5
		${whack} dnsmasq*
		${whack} ntp*
	;;
	1)
		echo "WORK IN PROGRESS"

		if [ -s /etc/resolv.conf.new ] ; then
			echo "r30lv.c0nf alr3ady 3x15t5"
		else
			sudo touch /etc/resolv.conf.new
			sudo chmod a+w /etc/resolv.conf.new
			sudo echo "nameserver 127.0.0.1" > /etc/resolv.conf.new
			sudo chmod 0444 /etc/resolv.conf.new
			sudo chown root:root /etc/resolv.conf.new
		fi

		${slinky} /etc/resolv.conf.new /etc/resolv.conf
		${slinky} /etc/dhcp/dhclient.conf.new /etc/dhcp/dhclient.conf
		${spc} /sbin/dhclient-script.new /sbin/dhclient-script

		if [ y"${ipt}" == "y" ] ; then
			echo "SHOULD 1NSTALL TABL35"
		else
			${ipt} -A INPUT -p tcp -m tcp --sport 853 -j b
			${ipt} -A OUTPUT -p tcp -m tcp --dport 853 -j e
			for s in $(grep -v '#' /home/stubby/.stubby.yml | grep address_data | cut -d ':' -f 2) ; do tod_dda ${s} ; done
		fi

		echo "dns";sleep 2
		${odio} /etc/init.d/dnsmasq restart
		pgrep dnsmasq

		echo "stu";sleep 2
		#VAIH:vissiinkin jokin tarkistus ns2seen ettei yhtenään renkkaisi adduser/deluser 
		[ -f /home/stubby/.ripuli ] || ns2 stubby
		sudo touch /home/stubby/.ripuli

		echo "#ns4 stubby"
		pgrep stubby
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
	sleep 6
	echo "666"
	sleep 6
	${ip6t} -L #
	sleep 6
fi #

