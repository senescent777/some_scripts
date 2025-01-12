#=================================================PART 0=====================================
#grep /e/n/i ?

odio=$(which sudo)
[ y"${odio}" == "y" ] && exit 665 
[ -x ${odio} ] || exit 666

#Näillä main jotain unary operator-valitusta vaiko kutsuvasta skriptstä kuitenkin?

function dqb() {
	[ ${debug} -eq 1 ] && echo ${1}
}

function csleep() {
	[ ${debug} -eq 1 ] && sleep ${1}
}

function pre_part3() {
	[ y"${1}" == "y" ] && exit
	echo "pp3( ${1} )"
	[ -d ${1} ] || exit
	echo "pp3.2"

	#HUOM.060125: uutena tables-asennus ennen vbarsinaista asennusta
	#josko vielä testaisi löytyykö asennettavia ennenq dpkg	
	${odio} dpkg -i ${1}/netfilter-persistent*.deb
	[ $? -eq 0 ] && ${odio} rm ${1}/netfilter-persistent*.deb
	csleep 5

	${odio} dpkg -i ${1}/libip*.deb
	[ $? -eq 0 ] && ${odio} rm ${1}/libip*.deb
	csleep 5

	${odio} dpkg -i ${1}/iptables_*.deb
	[ $? -eq 0 ] && ${odio} rm ${1}/iptables_*.deb
	csleep 5

	${odio} dpkg -i ${1}/iptables-*.deb
	[ $? -eq 0 ] && ${odio} rm ${1}/iptables-*.deb
	dqb "pp3 d0n3"
	csleep 5
}

function check_binaries() {
	dqb "ch3ck_b1nar135()"
	dqb "sudo= ${odio} "
	csleep 1

	ipt=$(sudo which iptables)
	ip6t=$(sudo which ip6tables)
	iptr=$(sudo which iptables-restore)
	ip6tr=$(sudo which ip6tables-restore)

	if [ y"${ipt}" == "y" ] ; then
		echo "SHOULD INSTALL IPTABLES"
		pre_part3 ${pkgdir}

		ipt=$(sudo which iptables)
		ip6t=$(sudo which ip6tables)
		iptr=$(sudo which iptables-restore)
		ip6tr=$(sudo which ip6tables-restore)
	fi

	sco=$(sudo which chown)
	[ y"${sco}" == "y" ] && exit
	dqb "${sco} OK"

	scm=$(sudo which chmod)
	[ y"${scm}" == "y" ] && exit
	dqb "${scm} OK"
	
	whack=$(sudo which pkill)
	[ y"${whack}" == "y" ] && exit 5
	[ -x ${whack} ] || exit 5

	sag=$(sudo which apt-get)
	sa=$(sudo which apt)
	sip=$(sudo which ip)
	snt=$(sudo which netstat)
	sdi=$(sudo which dpkg)
	sifu=$(sudo which ifup)
	sifd=$(sudo which ifdown)
	smr=$(sudo which rm)
	slinky=$(sudo which ln)
	spc=$(sudo which cp)

	#TODO: debug-mjasta riippuva -v
	srat=$(sudo which tar)

	som=$(sudo which mount)
	uom=$(sudo which umount)

	dqb "half_fdone"
	csleep 1


	[ -x ${ipt} ] || exit 5
	#jospa sanoisi ipv6.disable=1 isolinuxille ni ei tarttisi tässä säätää
	[ -x ${ip6t} ] || exit 5
	[ -x ${iptr} ] || exit 5
	[ -x ${ip6tr} ] || exit 5
	
	[ -x ${sco} ] || exit 5
	[ -x ${scm} ] || exit 5

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

function check_binaries2() {
	dqb "ch3ck_b1nar135.2()"

	ipt="${odio} ${ipt} "
	ip6t="${odio} ${ip6t} "
	iptr="${odio} ${iptr} "
	ip6tr="${odio} ${ip6tr} "

	whack="${odio} ${whack} --signal 9 "
	snt="${odio} ${snt} "
	sharpy="${odio} ${sag} remove --purge --yes "
	sdi="${odio} ${sdi} -i "

	#HUOM. ${sag} OLTAVA VIIMEISENÄ NÄISTÄ KOLMESDTA
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
	lftr="${smr} -rf /run/live/medium/live/initrd.img* "

	slinky="${odio} ${slinky} -s "
	spc="${odio} ${spc} "
	srat="${odio} ${srat} "
	asy="${odio} ${sa} autoremove --yes"
	fib="${odio} ${sa} --fix-broken install"
	som="${odio} ${som} "
	uom="${odio} ${uom} "	

	dqb "b1nar135.2 0k.2" 
	csleep 3
}

function mangle2() {
	if [ -f ${1} ] ; then 
		dqb "MANGLED ${1}"
		sleep 1
		${scm} o-rwx ${1}
		${sco} root:root ${1}
		csleep 1
	fi
}

##HUOM.220624:stubbyn asentumisen ja käynnistymisen kannalta sleep saattaa olla tarpeen
##VAIH:stubbyn asennus toimiimaan taas (261224)
#function ns2() {
#	dqb "ns2( ${1} )"
#
#	${scm} u+w /home
#
#	${odio} /usr/sbin/userdel ${1}
#	sleep 3
#
#	${odio} adduser --system ${1}
#	sleep 1
#	${scm} go-w /home
#	${sco} -R stubby:65534 /home/stubby/
#	[ ${debug} -eq 1 ]  && ls -las /home
#	sleep 7
#}
#
#function ns4() {
#	dqb "ns4( ${1} )"
#	[ z"{$1}" == "z" ] && exit 33
#jospa kirjoittaisi /e/i.d aqlaisen skriptin uudellleen tai valmis käyttöön ni ehkei tarttisi .pid-filen kanssa kikkailla tässä
#	${scm} u+w /run
#	${odio} touch /run/${1}.pid
#	${scm} 0600 /run/${1}.pid
#	${sco} ${1}:65534 /run/${1}.pid
#	${scm} u-w /run
#
#	sleep 5
#	#VAIJ:pitäisi kai tarkistaa parametrin validius ennenq...
#	${whack} ${1}*
#	sleep 5
#
#	dqb "starting ${1} in 5 secs"
#
#	sleep 5
#	${odio} -u ${1} ${1} -g
#	echo $?
#	sleep 1
#	pgrep stubby*
#	sleep 5
#}
#
#=========================PART 0 ENDS HERE=================================================================

function part1() {
	#jos jokin näistä kolmesta hoitaisi homman...
	${sifd} ${iface}
	${sifd} -a
	${sip} link set ${iface} down

	[ $? -eq 0 ] || echo "PROBLEMS WITH NETWORK CONNECTION"
	[ ${debug} -eq 1 ] && /sbin/ifconfig;sleep 5 

	if [ y"${ipt}" == "y" ] ; then
		echo "5H0ULD-1N\$TALL-1PTABL35!!!"
	else
		for t in INPUT OUTPUT FORWARD ; do 
			${ipt} -P ${t} DROP
			${ip6t} -P ${t} DROP
			${ip6t} -F ${t}
		done

		for t in INPUT OUTPUT FORWARD b c e f ; do ${ipt} -F ${t} ; done

		if [ ${debug} -eq 1 ] ; then
			${ipt} -L #
			${ip6t} -L #
			sleep 5 
		fi #
	
		
	fi
}

function part3() {
	[ y"${1}" == "y" ] && exit 1
	dqb "11"
	[ -d ${1} ] || exit 2
	dqb "22"
	${sdi} ${1}/lib*.deb

	if [ $? -eq  0 ] ; then
		dqb "part3.1 ok"
		sleep 5
		${smr} -rf ${1}/lib*.deb
	else
	 	dqb "exit 66"
	fi

	#ei kannattane vastata myöntävästi tallennus-kysymykseen?
	${sdi} ${1}/*.deb
	
	if [ $? -eq  0 ] ; then
		dqb "part3.2 ok"
		sleep 5
		${smr} -rf ${1}/lib*.deb
	else
	 	dqb "exit 67"
	fi

	csleep 2
}

check_binaries
check_binaries2

function gpo() {
	local prevopt
	local opt
	prevopt=""

	for opt in $@ ; do 
		parse_opts_1 ${opt}
		parse_opts_2 ${prevopt} ${opt}
		prevopt=opt
	done
}

#TODO:gpo jo käyttöön?
#check_params ?
