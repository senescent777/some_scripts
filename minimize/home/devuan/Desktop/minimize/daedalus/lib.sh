#=================================================PART 0=====================================

function pre_part3() {
	[ y"${1}" == "y" ] && exit
	echo "pp3( ${1} )"
	[ -d ${1} ] || exit
	echo "pp3.2"

	#josko vielä testaisi löytyykö asennettavia ennenq dpkg	(esim find)
	
	${odio} dpkg -i ${1}/netfilter-persistent*.deb
	[ $? -eq 0 ] && ${NKVD} ${1}/netfilter-persistent*.deb
	csleep 5

	${odio} dpkg -i ${1}/libip*.deb
	[ $? -eq 0 ] && ${NKVD} ${1}/libip*.deb
	csleep 5

	${odio} dpkg -i ${1}/iptables_*.deb
	[ $? -eq 0 ] && ${NKVD} ${1}/iptables_*.deb
	csleep 5

	${odio} dpkg -i ${1}/iptables-*.deb
	[ $? -eq 0 ] && ${NKVD} ${1}/iptables-*.deb

	dqb "pp3 d0n3"
	csleep 5
}

#TODO:näille main sitä git:in asentelua

pr4() {
	dqb "pr4( ${1})"
	csleep 5

	${odio} dpkg -i ${1}/libpam-modules-bin_*.deb
	${odio} dpkg -i ${1}/libpam-modules_*.deb
	${NKVD} ${1}/libpam-modules*
	csleep 5
	${odio} dpkg -i ${1}/libpam*.deb

	${odio} dpkg -i ${1}/perl-modules-*.deb
	${odio} dpkg -i ${1}/libperl*.deb 
	${NKVD} ${1}/perl-modules-*.deb 
	${NKVD} ${1}/libperl*.deb
	csleep 5

	${odio} dpkg -i ${1}/perl*.deb
	${odio} dpkg -i ${1}/libdbus*.deb
	${odio} dpkg -i ${1}/dbus*.deb

	${NKVD} ${1}/libpam*
	${NKVD} ${1}/libperl*
	${NKVD} ${1}/libdbus*
	${NKVD} ${1}/dbus*
	${NKVD} ${1}/perl*
}
#
#function check_binaries() {
#	dqb "ch3ck_b1nar135(${1} )"
#	dqb "sudo= ${odio} "
#	csleep 1
#
#	[ z"${1}" == "z" ] && exit 99
#	[ -d ~/Desktop/minimize/${1} ] || exit 100
#	dqb "params_ok"
#	csleep 1
#
#	ipt=$(sudo which iptables)
#	ip6t=$(sudo which ip6tables)
#	iptr=$(sudo which iptables-restore)
#	ip6tr=$(sudo which ip6tables-restore)
#
#	if [ y"${ipt}" == "y" ] ; then
#		echo "SHOULD INSTALL IPTABLES"
#	
#		pre_part3 ~/Desktop/minimize/${1}
#		pr4 ~/Desktop/minimize/${1}
#
#		ipt=$(sudo which iptables)
#		ip6t=$(sudo which ip6tables)
#		iptr=$(sudo which iptables-restore)
#		ip6tr=$(sudo which ip6tables-restore)
#	fi
#
#	[ -x ${ipt} ] || exit 5
#	#jospa sanoisi ipv6.disable=1 isolinuxille ni ei tarttisi tässä säätää
#	[ -x ${ip6t} ] || exit 5
#	[ -x ${iptr} ] || exit 5
#	[ -x ${ip6tr} ] || exit 5
#
#	CB_LIST1="${ipt} ${ip6t} ${iptr} ${ip6tr} "
#	local x
#	
#	#passwd mukaan listaan?
#	for x in chown chmod pkill apt-get apt ip netstat dpkg ifup ifdown rm ln cp tar mount umount 
#		do ocs ${x} 
#	done
#
#	sco=$(sudo which chown)
#	scm=$(sudo which chmod)
#	whack=$(sudo which pkill)
#	sag=$(sudo which apt-get)
#	sa=$(sudo which apt)
#	sip=$(sudo which ip)
#	snt=$(sudo which netstat)
#	sdi=$(sudo which dpkg)
#	sifu=$(sudo which ifup)
#	sifd=$(sudo which ifdown)
#	smr=$(sudo which rm) #TODO:shred mukaan kanssa
#	slinky=$(sudo which ln)
#	spc=$(sudo which cp)
#	srat=$(sudo which tar)
#
#	if [ ${debug} -eq 1 ] ; then
#		srat="${srat} -v "
#	fi
#
#	#HUOM. gpgtar olisi vähän parempi kuin pelkkä tar, silleen niinqu tavallaan
#
#	som=$(sudo which mount)
#	uom=$(sudo which umount)
#
#	dqb "half_fdone"
#	csleep 1
#
#	dch=$(find /sbin -name dhclient-script)
#	[ x"${dch}" == "x" ] && exit 6
#	[ -x ${dch} ] || exit 6
#
#	#HUOM:tulisi speksata sudolle tarkemmin millä param on ok noita komentoja ajaa
#	dqb "b1nar135 0k" 
#	csleep 3
#}
#
function clouds_case0() {
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
}

function clouds_case1() {
	echo "WORK IN PROGRESS"

#		if [ -s /etc/resolv.conf.new ] ; then
#			echo "r30lv.c0nf alr3ady 3x15t5"
#		else
#			sudo touch /etc/resolv.conf.new
#			sudo chmod a+w /etc/resolv.conf.new
#			sudo echo "nameserver 127.0.0.1" > /etc/resolv.conf.new
#			sudo chmod 0444 /etc/resolv.conf.new
#			sudo chown root:root /etc/resolv.conf.new
#		fi
#
#		${slinky} /etc/resolv.conf.new /etc/resolv.conf
#		${slinky} /etc/dhcp/dhclient.conf.new /etc/dhcp/dhclient.conf
#		${spc} /sbin/dhclient-script.new /sbin/dhclient-script
#
#		if [ y"${ipt}" == "y" ] ; then
#			echo "SHOULD 1NSTALL TABL35"
#		else
#			${ipt} -A INPUT -p tcp -m tcp --sport 853 -j b
#			${ipt} -A OUTPUT -p tcp -m tcp --dport 853 -j e
#			for s in $(grep -v '#' /home/stubby/.stubby.yml | grep address_data | cut -d ':' -f 2) ; do tod_dda ${s} ; done
#		fi
#
#		echo "dns";sleep 2
#		${odio} /etc/init.d/dnsmasq restart
#		pgrep dnsmasq
#
#		echo "stu";sleep 2
#		${whack} stubby* #090325: pitäisiköhän tämä muuttaa?
#		sleep 3	
#			
#		[ -f /run/stubby.pid ] || sudo touch /run/stubby.pid
#		${sco} devuan:devuan /run/stubby.pid #$n
#		${scm} 0644 /run/stubby.pid 
#		sleep 3
#
#		su devuan -c '/usr/bin/stubby -C /home/stubby/.stubby.yml -g'
#		pgrep stubby
}

check_binaries ${distro}
check_binaries2


