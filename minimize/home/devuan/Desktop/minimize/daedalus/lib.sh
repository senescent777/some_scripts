#=================================================PART 0=====================================

function pre_part3() {
	[ y"${1}" == "y" ] && exit
	echo "pp3( ${1} )"
	[ -d ${1} ] || exit
	echo "pp3.2"

	#josko vielä testaisi löytyykö asennettavia ennenq dpkg	(esim find)
	
	${sdi} ${1}/netfilter-persistent*.deb
	[ $? -eq 0 ] && ${NKVD} ${1}/netfilter-persistent*.deb
	csleep 3

	${sdi} ${1}/libip*.deb
	[ $? -eq 0 ] && ${NKVD} ${1}/libip*.deb
	csleep 3

	${sdi} ${1}/iptables_*.deb
	[ $? -eq 0 ] && ${NKVD} ${1}/iptables_*.deb
	csleep 3

	${sdi} ${1}/iptables-*.deb
	[ $? -eq 0 ] && ${NKVD} ${1}/iptables-*.deb

	dqb "pp3 d0n3"
	csleep 3
}

#HUOM.190325: git näyttäisi asentuvan
#(olikohan näiden pp3 ja pre4 kanssa jotain säätämistä vielä?)

pr4() {
	dqb "pr4( ${1})"
	csleep 5

	${sdi} ${1}/libpam-modules-bin_*.deb
	${sdi} ${1}/libpam-modules_*.deb
	${NKVD} ${1}/libpam-modules*
	csleep 5
	${sdi} ${1}/libpam*.deb

	${sdi} ${1}/perl-modules-*.deb
	${sdi} ${1}/libperl*.deb 
	${NKVD} ${1}/perl-modules-*.deb 
	${NKVD} ${1}/libperl*.deb
	csleep 5

	${sdi} ${1}/perl*.deb
	${sdi} ${1}/libdbus*.deb
	${sdi} ${1}/dbus*.deb

	${NKVD} ${1}/libpam*
	${NKVD} ${1}/libperl*
	${NKVD} ${1}/libdbus*
	${NKVD} ${1}/dbus*
	${NKVD} ${1}/perl*
}

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


