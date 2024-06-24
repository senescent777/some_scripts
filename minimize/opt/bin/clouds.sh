#!/bin/bash

. ~/Desktop/minimize/lib
debug=1
check_binaries
check_binaries2

#TODO:voisi kai speksata sudolle asioita ettei tarvitse koko skiptiä sallia
#kts. https://github.com/senescent777/some_scripts/blob/main/lib/d227D33.sh.export liittyen

#VAIH: sittenkin /opt alle erillinen skripti mikä renkkaa nämä dns-jutut eestaas
function tod_dda() {
	${ipt} -A b -p tcp --sport 853 -s ${1} -j c
	${ipt} -A e -p tcp --dport 853 -d ${1} -j f
}

function dda_snd() {
	${ipt} -A b -p udp -m udp -s ${1} --sport 53 -j ACCEPT 
	${ipt} -A e -p udp -m udp -d ${1} --dport 53 -j ACCEPT 
}

#mallia https://github.com/senescent777/project/blob/main/opt/bin/install.sh , https://github.com/senescent777/project/blob/main/opt/bin/install.sh , https://github.com/senescent777/project/blob/main/home/devuan/Dpckcer/buildr/source/scripts/part4.sh 
#clouds() {
dqb "coluds(${1})"

sudo rm /etc/resolv.conf
sudo rm /etc/dhcp/dhclient.conf
sudo rm /sbin/dhclient-script

#tässä oikea paikka tables-muutoksille vai ei?
${ipt} -F b
${ipt} -F e
${ipt} -D INPUT 5
${ipt} -D OUTPUT 6
#local s #/opt/bin/clouds.sh: line 33: local: can only be used in a function

case ${1} in 
	0)
		sudo ln -s /etc/resolv.conf.OLD /etc/resolv.conf
		sudo ln -s /etc/dhcp/dhclient.conf.OLD /etc/dhcp/dhclient.conf
		sudo cp /sbin/dhclient-script.OLD /sbin/dhclient-script

		${ipt} -A INPUT -p udp -m udp --sport 53 -j b 
		${ipt} -A OUTPUT -p udp -m udp --dport 53 -j e
		for s in $(grep -v '#' /etc/resolv.conf.OLD | grep names | grep -v 127. | awk '{print $2}') ; do dda_snd ${s} ; done	
	;;
	1)
		sudo ln -s /etc/resolv.conf.new /etc/resolv.conf
		sudo ln -s /etc/dhcp/dhclient.conf.new /etc/dhcp/dhclient.conf
		sudo cp /sbin/dhclient-script.new /sbin/dhclient-script
	
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
	sleep 5
fi #
#}