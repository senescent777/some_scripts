#=================================================PART 0=====================================
function check_binaries() {
	dqb "lib.ch3ck_b1nar135( ${1} )"
	dqb "sudo= ${odio} "
	csleep 1

	[ z"${1}" == "z" ] && exit 99
	[ -d ~/Desktop/minimize/${1} ] || exit 100
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

	#TODO:ajamaan nuo komennot jatkossa (tai vaikka common_lib:iin c_b_1)
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

	#HUOM.:tulisi speksata sudolle tarkemmin millä param on ok noita komentoja ajaa
	#TODO:ocs() käyttöön, testaa 	
	CB_LIST1="${ipt} ${ip6t} ${iptr} ${ip6tr} ${sco} ${scm} ${whack} ${sag} ${sa} ${sip} ${snt} ${sdi} ${sifu} ${sifd} ${smr} ${slinky} ${srat} ${spc} ${som} ${uom}"

	dqb "spc= ${spc}"
	dqb "b1nar135 0k" 
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
#TODO:näille main sitä git:in asentelua (jos ei siis jo pelaa)

function pre_part3() {
	dqb "pre_part3( ${1})"
	${sdi} ${1}/dns-root-data*.deb
	${smr} -rf ${1}/dns-root-data*.deb

	#uutena, pois jos qsee	
	${sdi} ${1}/perl-modules-*.deb
	${smr} -rf ${1}/perl-modules-*.deb
}

function clouds_case0() {
	dqb  "lib.case0 "

	${slinky} /etc/resolv.conf.OLD /etc/resolv.conf
	${slinky} /etc/dhcp/dhclient.conf.OLD /etc/dhcp/dhclient.conf
	${spc} /sbin/dhclient-script.OLD /sbin/dhclient-script

	#samaan tapaan voisi menneä daeDALuksenkin kanssa? s.e. jos a-f - ketjut olemassa ni muutetaan vain dns-säännlt, muussa tapaux pakotetaan rules.v4
	${ipt} -A INPUT -p udp -m udp --sport 53 -j b 
	${ipt} -A OUTPUT -p udp -m udp --dport 53 -j e
	for s in $(grep -v '#' /etc/resolv.conf.OLD | grep names | grep -v 127. | awk '{print $2}') ; do dda_snd ${s} ; done	

	csleep 1
	dqb "... d0n3"	
}

function clouds_case1() {
	echo "lib.case1 (TODO)"
#		${slinky} /etc/resolv.conf.new /etc/resolv.conf
#		${slinky} /etc/dhcp/dhclient.conf.new /etc/dhcp/dhclient.conf
#		${spc} /sbin/dhclient-script.new /sbin/dhclient-script
#		
#		${ipt} -A INPUT -p tcp -m tcp --sport 853 -j b
#		${ipt} -A OUTPUT -p tcp -m tcp --dport 853 -j e
#		for s in $(grep -v '#' /home/stubby/.stubby.yml | grep address_data | cut -d ':' -f 2) ; do tod_dda ${s} ; done

	csleep 1
	dqb "... d0n3"	
}

dqb "BIL-UR-SAG"
check_binaries ${distro}
check_binaries2 #${distro}
dqb "UMULAMAHRI"
