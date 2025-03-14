#=================================================PART 0=====================================
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
	som=$(sudo which mount)
	uom=$(sudo which umount)

	dqb "half_fdone"
	csleep 1

	#TODO:ajamaan nuo komennot jatkossa
	if [ y"${ipt}" == "y" ] ; then
		echo "SHOULD INSTALL IPTABLES"
		echo "pre_part3 ~/Desktop/minimize/${1}"
		echo "pr4 ~/Desktop/minimize/${1}"

		echo "ipt=\$(sudo which iptables)"
		echo "ip6t=\$(sudo which ip6tables)"
		echo "iptr=\$(sudo which iptables-restore)"
		echo "ip6tr=\$(sudo which ip6tables-restore)"
	fi

	#HUOM. ocs()?
	[ -x ${ipt} ] || exit 5
	#jospa sanoisi ipv6.disable=1 isolinuxille ni ei tarttisi tässä säätää
	[ -x ${ip6t} ] || exit 5
	[ -x ${iptr} ] || exit 5
	[ -x ${ip6tr} ] || exit 5
	[ -x ${sco} ] || exit 5
	[ -x ${scm} ] || exit 5
	[ -x ${whack} ] || exit 5
	[ -x ${sag} ] || exit 5
	[ -x ${sa} ] || exit 5
	[ -x ${sip} ] || exit 5
	[ -x ${snt} ] || exit 5
	[ -x ${sdi} ] || exit 5
	[ -x ${sifu} ] || exit 5
	[ -x ${sifd} ] || exit 5

	[ -x ${smr} ] || exit 5
	[ -x ${slinky} ] || exit 5
	[ -x ${spc} ] || exit 5
	[ -x ${srat} ] || exit 5
	[ -x ${som} ] || exit 5
	[ -x ${uom} ] || exit 5

	#TODO:tulisi speksata sudolle tarkemmin millä param on ok noita komentoja ajaa
	CB_LIST1="${ipt} ${ip6t} ${iptr} ${ip6tr} ${sco} ${scm} ${whack} ${sag} ${sa} ${sip} ${snt} ${sdi} ${sifu} ${sifd} ${smr} ${slinky} ${srat} ${spc} ${som} ${uom}"

	dqb "spc= ${spc}"
	dqb "b1nar135 0k" 
	csleep 3
}

#HUOM.140325:käytännössä samat chim ja daed -> common_lib jatkossa käytt
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
	
	#HUOM. ${sag} VIIMEISENÄ
	shary="${odio} ${sag} --no-install-recommends reinstall --yes "
	sag_u="${odio} ${sag} update "
	sag="${odio} ${sag} "

	sco="${odio} ${sco} "
	scm="${odio} ${scm} "
	sip="${odio} ${sip} "

	sa="${odio} ${sa} "
	sifu="${odio} ${sifu} "
	sifd="${odio} ${sifd} "

	smr="${odio} ${smr} "
	lftr="${smr} -rf /run/live/medium/live/initrd.img* " #shred myös keksitty
	slinky="${odio} ${slinky} -s "

	spc="${odio} ${spc} "
	srat="${odio} ${srat} "
	asy="${odio} ${sa} autoremove --yes"

	fib="${odio} ${sa} --fix-broken install"
	som="${odio} ${som} "
	uom="${odio} ${uom} "	

	#smr="${odio} ${smr} "
	dch="${odio} ${dch}"
	dqb "b1nar135.2 0k.2" 
	csleep 3
}

#=========================PART 0 ENDS HERE=================================================================
function pr4() {
	dqb "pr4 (${1})"
	${odio} shred -fu ${1}/stubby*
	${odio} shred -fu ${1}/libgetdns*

	#uutena
	${odio} shred -fu ${1}/dnsmasq*
	dqb "d0n3"
}

#VAIH:jompaan kumpaan(pp3/pr4) dnsmasq* poisto (pidemmällä tähtäimellä tietty parempi laittaa toimimaanq poistaa mutta nyt näin)
#TODO:näille main sitä git:in asentelua

function pre_part3() {
	dqb "pre_part3( ${1})"
	${sdi} ${1}/dns-root-data*.deb
	${smr} -rf ${1}/dns-root-data*.deb

	#uutena, pois jos qsee	
	${sdi} ${1}/perl-modules-*.deb
	${smr} -rf ${1}/perl-modules-*.deb
}

dqb "BIL-UR-SAG"
check_binaries ${distro}
check_binaries2
dqb "UMULAMAHRI"
