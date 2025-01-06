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

${smr} /etc/resolv.conf
${smr} /etc/dhcp/dhclient.conf
${smr} /sbin/dhclient-script

#tässä oikea paikka tables-muutoksille vai ei?
if [ y"${ipt}" == "y" ] ; then
	echo "SHOULD 1NSTALL TABL35"
else
	${iptr} /etc/iptables/rules.v4
	${ip6tr} /etc/iptables/rules.v6
	sleep 3

	${ipt} -F b
	${ipt} -F e

	#pitäisiköhän liittyä nÄiden noihin dns/dot-juTTuihin? jep
	${ipt} -D INPUT 5
	${ipt} -D OUTPUT 5
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
			echo "SHOULD 1NSTALL TABL35"
		else
			${ipt} -A INPUT -p udp -m udp --sport 53 -j b 
			${ipt} -A OUTPUT -p udp -m udp --dport 53 -j e

			for s in $(grep -v '#' /etc/resolv.conf | grep names | grep -v 127. | awk '{print $2}') ; do dda_snd ${s} ; done	
		fi
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
		pgrep dnsmasq
		echo "stu";sleep 2
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

#if [ ${debug} -eq 1 ] ; then
	#echo "PISDEO PRO SAnTANA"
	${ipt} -L  #
	sleep 6
	echo "666"
	sleep 6
	${ip6t} -L #
	sleep 6
#fi #

