#=================================================PART 0=====================================
#grep /e/n/i ?

odio=$(which sudo)
[ y"${odio}" == "y" ] && exit 99 
[ -x ${odio} ] || exit 100
${odio} chown -R 0:0 /etc/sudoers.d #pitääköhän juuri tässä tehdä tämä? no ainakin loppuu nalkutukset mahd aikaisin

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
	#josko vielä testaisi löytyykö asennettavia ennenq dpkg	(esim find)
	
	#https://pkginfo.devuan.org/cgi-bin/package-query.html?c=package&q=netfilter-persistent=1.0.20
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

	echo "pp3.3"
	##uutena(vielä menossa arpajaiset että tartteeko asentaa vaiko poistaa)
	##${odio} dpkg -i ${1}/libdbus*.deb
	##[ $? -eq 0 ] && 
	#${odio} shred -fu ${1}/libdbus*.deb

	#ao. versio aiheesta kopsattu tdstodts import.sh, pois jos pykii
	#TODO:josko koettaisi masennella nuo ao. paketit ennen varsinaista masxennusta	
	sudo shred -fu ${1}/libpam*
	sudo shred -fu ${1}/libperl*
	sudo shred -fu ${1}/libdbus*
	sudo shred -fu ${1}/dbus*
	sudo shred -fu ${1}/perl*

	dqb "pp3 d0n3"
	csleep 5
}

function ocs() {
	local tmp
	tmp=$(sudo which ${1})

	if [ y"${tmp}" == "y" ] ; then
		exit 66 #fiksummankin exit-koodin voisi keksiä
	else
		dqb "fråm ocs(): ${tmp} exists"
	fi

	if [ -x ${tmp} ] ; then	
		dqb "fråm ocs(): ${tmp} is executable"		
	else
		exit 77
	fi

	CB_LIST1="${CB_LIST1} ${tmp} " #ja nimeäminenkin...
	dqb "fråm ocs(): ${tmp} add3d t0 l1st"
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

	[ -x ${ipt} ] || exit 5
	#jospa sanoisi ipv6.disable=1 isolinuxille ni ei tarttisi tässä säätää
	[ -x ${ip6t} ] || exit 5
	[ -x ${iptr} ] || exit 5
	[ -x ${ip6tr} ] || exit 5

	CB_LIST1="${ipt} ${ip6t} ${iptr} ${ip6tr} "
	local x
	
	#TODO:passwd mukaan listaan?
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
	smr=$(sudo which rm)
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

	#CB_list'iin mukaan vai ei? vai oliko jo?
	dch=$(find /sbin -name dhclient-script)
	[ x"${dch}" == "x" ] && exit 6
	[ -x ${dch} ] || exit 6
	#ocs dhclient-script
	#enforce'en mukaan find -name dhclient-script* tjsp?

	#HUOM:tulisi speksata sudolle tarkemmin millä param on ok noita komentoja ajaa
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

	spd="${odio} ${sdi} -l "
	sdi="${odio} ${sdi} -i "

	#HUOM. ${sag} OLTAVA VIIMEISENÄ NÄISTÄ KOLMESDTA
	shary="${odio} ${sag} --no-install-recommends reinstall --yes "
	sag_u="${odio} ${sag} update "
	sag="${odio} ${sag} "

	sco="${odio} ${sco} "
	scm="${odio} ${scm} "

	dqb "${scm} a-wx ~/Desktop/minimize/*.sh in 5 secs"
	csleep 5
	${scm} a-wx /home/devuan/Desktop/minimize/*.sh
	${scm} a-wx /home/devuan/Desktop/minimize/*.conf
	#[ $debug -eq 1 ] && ls -las ~/Desktop/minimize;sleep 6

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
	dch="${odio} ${dch}"
	dqb "b1nar135.2 0k.2" 
	csleep 3
}

function mangle2() {
	if [ -f ${1} ] ; then 
		dqb "MANGLED ${1}"
		#sleep 1
		${scm} o-rwx ${1}
		${sco} root:root ${1}
		#csleep 1
	fi
}

##HUOM.220624:stubbyn asentumisen ja käynnistymisen kannalta sleep saattaa olla tarpeen
#HUOM.280125: ao. fktion kanssa piotäisi vissiin jotain tehdä vähitellen
#function ns4() {
#	dqb "ns4( ${1} )"
#	[ z"{$1}" == "z" ] && exit 33
#jospa kirjoittaisi /e/i.d alaisen skriptin uudellleen tai valmis käyttöön ni ehkei tarttisi .pid-filen kanssa kikkailla tässä
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



function part3() {
	[ y"${1}" == "y" ] && exit 1
	dqb "11"
	[ -d ${1} ] || exit 2
	dqb "22"
	${sdi} ${1}/lib*.deb

	if [ $? -eq  0 ] ; then
		dqb "part3.1 ok"
		sleep 5
		${odio} shred -fu ${1}/lib*.deb
	else
	 	dqb "exit 66"
	fi

	${sdi} ${1}/*.deb
	
	if [ $? -eq  0 ] ; then
		dqb "part3.2 ok"
		sleep 5
		${odio} shred -fu ${1}/*.deb 
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
