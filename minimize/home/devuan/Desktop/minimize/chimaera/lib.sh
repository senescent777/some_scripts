#=================================================PART 0=====================================

function check_binaries() {
	dqb "ch3ck_b1nar135()"
	dqb "sudo= ${odio} "
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
	smr=$(sudo which rm)
	slinky=$(sudo which ln)
	spc=$(sudo which cp)
	srat=$(sudo which tar)
	som=$(sudo which mount)
	uom=$(sudo which umount)

	dqb "half_fdone"
	csleep 1

	#olisi kai toinenkin tapa tehdä tämä ipt-asdia...
	ic=$(echo $ipt | wc -w)

	if [ $ic -le 0 ] ; then
		echo "SHOULD INSTALL IPTABLES"
	fi

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
	slinky="${odio} ${slinky} -s "
	spc="${odio} ${spc} "
	srat="${odio} ${srat} "
	asy="${odio} ${sa} autoremove --yes"

	som="${odio} ${som} "
	uom="${odio} ${uom} "	

	smr="${odio} ${smr} "
	lftr="${smr} -rf /run/live/medium/live/initrd.img* "

#	dqb "spc= ${spc}"
	dqb "b1nar135.2 0k.2" 

	csleep 3
}
#
#function mangle2() {
#	if [ -f ${1} ] ; then 
#		dqb "MANGLED ${1}"
#		sleep 1
#		${scm} o-rwx ${1}
#		${sco} root:root ${1}
#		csleep 1
#	fi
#}
#
##HUOM.220624:stubbyn asentumisen ja käynnistymisen kannalta sleep saattaa olla tarpeen
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
#
#	[ ${debug} -eq 1 ]  && ls -las /home
#	sleep 7
#}
#
#function ns4() {
#	dqb "ns4( ${1} )"
#
#	${scm} u+w /run
#	${odio} touch /run/${1}.pid
#	${scm} 0600 /run/${1}.pid
#	${sco} ${1}:65534 /run/${1}.pid
#	${scm} u-w /run
#
#	sleep 5
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
function pr4() {
	echo "pr4 (${1})"
	${odio} shred -fu ${1}/stubby*
	${odio} shred -fu ${1}/libgetdns*

	#uutena
	${odio} shred -fu ${1}/dnsmasq*
}

#VAIH:jompaan kumpaan(pp3/pr4) dnsmasq* poisto (pidemmällä tähtäimellä tietty parempi laittaa toimimaanq poistaa mutta nyt näin)

function pre_part3() {
	dqb "pre_part3( ${1})"
	${sdi} ${1}/dns-root-data*.deb
	${smr} -rf ${1}/dns-root-data*.deb

	#uutena, pois jos qsee	
	${sdi} ${1}/perl-modules-*.deb
	${smr} -rf ${1}/perl-modules-*.deb
	
}
##common_lib jatkossa käyttöön
#function part3() {
#	dqb "part3( ${1})"
#	${sdi} ${1}/lib*.deb
#
#	if [ $? -eq  0 ] ; then
#		#nköjään ei riittävästitehty dnsmasq kannalta
#		dqb "part3.1 ok"
#		sleep 5
#
#		${smr} -rf ${1}/lib*.deb
#
#	else
#	 	exit 66
#	fi
#	
#	#&&
#
#	#ei kannattane vastata myöntävästi tallennus-kysymykseen?
#	${sdi} ${1}/*.deb
#
#	if [ $? -eq  0 ] ; then
#		dqb "part3.2 ok"
#		sleep 5
#		${smr} -rf ${1}/*.deb
#
#	else
#	 	exit 67
#	fi
#
#	csleep 2
#
#	dqb "pt3 d0m3"
#
#}
#
#part1?
echo "BIL-UR-SAG"
check_binaries
check_binaries2
echo "UMULAMAHRI"
#
#function gpo() {
#	local prevopt
#	local opt
#	prevopt=""
#
#	for opt in $@ ; do 
#		parse_opts_1 ${opt}
#		parse_opts_2 ${prevopt} ${opt}
#		prevopt=opt
#	done
#}
#
#TODO:gpo jo käyttöön?
#check_params ?