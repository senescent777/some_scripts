#=================================================PART 0=====================================

function pre_part3() {
	[ y"${1}" == "y" ] && exit
	echo "pp3( ${1} )"
	[ -d ${1} ] || exit
	echo "pp3.2"

	#josko vielä testaisi löytyykö asennettavia ennenq dpkg	(esim find)
	
	${odio} dpkg -i ${1}/netfilter-persistent*.deb
	[ $? -eq 0 ] && ${odio} shred -fu ${1}/netfilter-persistent*.deb
	csleep 5

	${odio} dpkg -i ${1}/libip*.deb
	[ $? -eq 0 ] && ${odio} shred -fu ${1}/libip*.deb
	csleep 5

	${odio} dpkg -i ${1}/iptables_*.deb
	[ $? -eq 0 ] && ${odio} shred -fu ${1}/iptables_*.deb
	csleep 5

	${odio} dpkg -i ${1}/iptables-*.deb
	[ $? -eq 0 ] && ${odio} shred -fu ${1}/iptables-*.deb

	dqb "pp3 d0n3"
	csleep 5
}

#TODO:näille main sitä git:in asentelua

pr4() {
	dqb "pr4( ${1})"
	csleep 5

	${odio} dpkg -i ${1}/libpam-modules-bin_*.deb
	${odio} dpkg -i ${1}/libpam-modules_*.deb
	sudo shred -fu ${1}/libpam-modules*
	csleep 5
	${odio} dpkg -i ${1}/libpam*.deb

	${odio} dpkg -i ${1}/perl-modules-*.deb
	${odio} dpkg -i ${1}/libperl*.deb 
	sudo shred -fu ${1}/perl-modules-*.deb 
	sudo shred -fu ${1}/libperl*.deb
	csleep 5

	${odio} dpkg -i ${1}/perl*.deb
	${odio} dpkg -i ${1}/libdbus*.deb
	${odio} dpkg -i ${1}/dbus*.deb

	sudo shred -fu ${1}/libpam*
	sudo shred -fu ${1}/libperl*
	sudo shred -fu ${1}/libdbus*
	sudo shred -fu ${1}/dbus*
	sudo shred -fu ${1}/perl*
}

function check_binaries() {
	dqb "ch3ck_b1nar135()"
	dqb "sudo= ${odio} "
	csleep 1

	[ z"${1}" == "z" ] && exit 99
	[ -d ~/Desktop/minimize/${1} ] & exit 100
	dqb "params_ok"
	csleep 1

	ipt=$(sudo which iptables)
	ip6t=$(sudo which ip6tables)
	iptr=$(sudo which iptables-restore)
	ip6tr=$(sudo which ip6tables-restore)

	if [ y"${ipt}" == "y" ] ; then
		echo "SHOULD INSTALL IPTABLES"
	
		pre_part3 ~/Desktop/minimize/${1}
		pr4 ~/Desktop/minimize/${1}

		ipt=$(sudo which iptables)
		ip6t=$(sudo which ip6tables)
		iptr=$(sudo which iptables-restore)
		ip6tr=$(sudo which ip6tables-restore)
	fi

	[ -x ${ipt} ] || exit 5
	#jospa sanoisi ipv6.disable=1 isolinuxille ni ei tarttisi tässä säätää
	[ -x ${ip6t} ] || exit 5
	[ -x ${iptr} ] || exit 5
	[ -x ${ip6tr} ] || exit 5

	CB_LIST1="${ipt} ${ip6t} ${iptr} ${ip6tr} "
	local x
	
	#passwd mukaan listaan?
	for x in chown chmod pkill apt-get apt ip netstat dpkg ifup ifdown rm ln cp tar mount umount 
		do ocs ${x} 
	done

	sco=$(sudo which chown)
	scm=$(sudo which chmod)
	whack=$(sudo which pkill)
	sag=$(sudo which apt-get)
	sa=$(sudo which apt)
	sip=$(sudo which ip)
	snt=$(sudo which netstat)
	sdi=$(sudo which dpkg)
	sifu=$(sudo which ifup)
	sifd=$(sudo which ifdown)
	smr=$(sudo which rm) #TODO:shred mukaan kanssa
	slinky=$(sudo which ln)
	spc=$(sudo which cp)
	srat=$(sudo which tar)

	if [ ${debug} -eq 1 ] ; then
		srat="${srat} -v "
	fi

	#HUOM. gpgtar olisi vähän parempi kuin pelkkä tar, silleen niinqu tavallaan

	som=$(sudo which mount)
	uom=$(sudo which umount)

	dqb "half_fdone"
	csleep 1

	dch=$(find /sbin -name dhclient-script)
	[ x"${dch}" == "x" ] && exit 6
	[ -x ${dch} ] || exit 6

	#HUOM:tulisi speksata sudolle tarkemmin millä param on ok noita komentoja ajaa
	dqb "b1nar135 0k" 
	csleep 3
}

#voisikohan jatkkossa yhdenmuakistaa chimaeran version kanssa? -> common_lib jatkossa käytt
function check_binaries2() {
	dqb "ch3ck_b1nar135.2()"

	ipt="${odio} ${ipt} "
	ip6t="${odio} ${ip6t} "
	iptr="${odio} ${iptr} "
	ip6tr="${odio} ${ip6tr} "

	whack="${odio} ${whack} --signal 9 "
	snt="${odio} ${snt} "
	sharpy="${odio} ${sag} remove --purge --yes "
	spd="${odio} ${sdi} -l "
	sdi="${odio} ${sdi} -i "

	#HUOM. ${sag} OLTAVA VIIMEISENÄ NÄISTÄ KOLMESTA
	shary="${odio} ${sag} --no-install-recommends reinstall --yes "
	sag_u="${odio} ${sag} update "
	sag="${odio} ${sag} "

	sco="${odio} ${sco} "
	scm="${odio} ${scm} "
	sip="${odio} ${sip} "

	#HUOM.130325:tar0peellinen blokki nykyään?
	dqb "${scm} a-wx ~/Desktop/minimize/*.sh in 5 secs"
	csleep 5
	${scm} 0755 /home/devuan/Desktop/minimize/*.sh
	${scm} 0444 /home/devuan/Desktop/minimize/*.conf

	sa="${odio} ${sa} "
	sifu="${odio} ${sifu} "
	sifd="${odio} ${sifd} "

	smr="${odio} ${smr} "
	lftr="${smr} -rf /run/live/medium/live/initrd.img* "
	slinky="${odio} ${slinky} -s "

	spc="${odio} ${spc} "
	srat="${odio} ${srat} "
	asy="${odio} ${sa} autoremove --yes"

	fib="${odio} ${sa} --fix-broken install"
	som="${odio} ${som} "
	uom="${odio} ${uom} "	

	dch="${odio} ${dch}"
	dqb "b1nar135.2 0k.2" 
	csleep 3
}

check_binaries ${distro}
check_binaries2
#TODO:clouds.sh, distro-spesifinen sisältö -> lib


