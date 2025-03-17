#bash kutsuvaan skriptiin tulkiksi saattaa aiheuttaa vähemmän nalkutusta kuin sh
odio=$(which sudo)
[ y"${odio}" == "y" ] && exit 99 
[ -x ${odio} ] || exit 100

function dqb() {
	[ ${debug} -eq 1 ] && echo ${1}
}

function csleep() {
	[ ${debug} -eq 1 ] && sleep ${1}
}

#TODO:$sco ja $scm käyttöön jatq?
fix_sudo() {
	echo "fix_sud0.pt0"
	${odio} chown -R 0:0 /etc/sudoers.d #pitääköhän juuri tässä tehdä tämä? jep
	${odio} chmod 0440 /etc/sudoers.d/* 
	
	${odio} chown -R 0:0 /etc/sudo*
	${odio} chmod -R a-w /etc/sudo*

	dqb "POT. DANGEROUS PT 1"
	#sudo chown 0:0 /usr/lib/sudo/* #onko moista daedaluksessa?
	#sudo chown 0:0 /usr/bin/sudo* #HUOM. LUE VITUN RUNKKARI MAN-SIVUT AJATUKSELLA ENNENQ KOSKET TÄHÄN!!!

	dqb "fix_sud0.pt1"
	${odio} chmod 0750 /etc/sudoers.d
	${odio} chmod 0440 /etc/sudoers.d/*
	
	dqb "POT. DANGEROUS PT 2"
	#sudo chmod -R a-w /usr/lib/sudo/* #onko moista daedaluksessa?
	#sudo chmod -R a-w /usr/bin/sudo* #HUOM. LUE VITUN RUNKKARI MAN-SIVUT AJATUKSELLA ENNENQ KOSKET TÄHÄN!!!

	#sudo chmod 4555 ./usr/bin/sudo #HUOM. LUE VITUN RUNKKARI MAN-SIVUT AJATUKSELLA ENNENQ KOSKET TÄHÄN!!!

	#sudo chmod 0444 /usr/lib/sudo/sudoers.so #onko moista daedaluksessa?
	[ ${debug} -eq 1 ] && ls -las  /usr/bin/sudo*
	csleep 5	
	echo "d0n3"
}

fix_sudo

#pr4(), pp3(), p3() distro-spesifisiä, ei tähän tdstoon
#VAIH:jospa tämänkin toiminnan testausu (daedaluksen kanssa sitten)
function ocs() {
	dqb "ocs"
	local tmp
	tmp=$(sudo which ${1})

	if [ y"${tmp}" == "y" ] ; then
		exit 66 #fiksummankin exit-koodin voisi keksiä
	fi

	if [ ! -x ${tmp} ] ; then
		exit 77
	fi
	
	dqb "paramz_0k"
	CB_LIST1="${CB_LIST1} ${tmp} " #ja nimeäminenkin...
}

#check_binaries(), check_binaries2() , distro-spesifisiä vai ei? (VAIH: let's find out?)

#HUOM. jos tätä käyttää ni scm ja sco pitää tietenkin esitellä alussa
function mangle2() {
	if [ -f ${1} ] ; then 
		dqb "MANGLED ${1}"
		${scm} o-rwx ${1}
		${sco} root:root ${1}
	fi
}

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

function mangle_s() {
	#dqb "mangle_s( ${1} ${2})"
	csleep 1

	[ y"${1}" == "y" ] && exit
	[ -x ${1} ] || exit 55 #oli -s
	[ y"${2}" == "y" ] && exit 
	[ -f ${2} ] || exit 54
	#dqb "params_oik"

	${scm} 0555 ${1}
	#HUOM. miksi juuri 5? no six six six että suoritettavaan tdstoon ei tartte kirjoittaa
	${sco} root:root ${1} 

	local s
	s=$(sha256sum ${1})
	${odio} echo "${n} localhost=NOPASSWD: sha256: ${s} " >> ${2}
}

function pre_enforce() {
	dqb "common_lib.pre_enforce( ${1} , ${2} )"	

	#HUOM.230624 /sbin/dhclient* joutuisi hoitamaan toisella tavalla q mangle_s	
	local q
	local f
	q=$(mktemp -d)	
	 
	dqb "sudo touch ${q}/meshuggah in 5 secs"
	csleep 3
	${odio} touch ${q}/meshuggah

	[ ${debug} -eq 1 ] && ls -las ${q}
	csleep 3
	[ -f ${q}/meshuggah ] || exit 33
	dqb "ANNOYING AMOUNT OF DEBUG"

	if [ z"${1}" != "z" ] ; then
		dqb "333"
		${sco} ${1}:${1} ${q}/meshuggah 
 		${scm} 0660 ${q}/meshuggah
	fi	

	##HUOM.lib- ja conf- kikkailujen takia ei ehkä kantsikaan ajaa vlouds2:sta sudon kautta kokonaisuudessaan
	##if [ z"${2}" != "z" ] ; then
	##	dqb "FUCKED WITH A KNIFE"
	##	#[ ${debug} -eq 1 ] && ls -las ~/Desktop/minimize/${2}
	##
	##	if [ -d ~/Desktop/minimize/${2} ] ; then
	#		dqb "1NF3RN0 0F SACR3D D35TRUCT10N"
	#		#mangle_s ~/Desktop/minimize/${2}/clouds.sh ${q}/meshuggah
	#		mangle_s ~/Desktop/minimize/clouds2.sh ${q}/meshuggah 			
	#		csleep 2
	##	fi
	##fi

	#exit 111
	for f in ${CB_LIST1} ; do mangle_s ${f} ${q}/meshuggah ; done
	for f in /sbin/halt /sbin/reboot ; do mangle_s ${f} ${q}/meshuggah ; done
	
	if [ -s ${q}/meshuggah ] ; then
		dqb "sudo mv ${q}/meshuggah /etc/sudoers.d in 5 secs"
		csleep 2

		${scm} a-wx ${q}/meshuggah
		${sco} root:root ${q}/meshuggah	
		${odio} mv ${q}/meshuggah /etc/sudoers.d
	fi

	#HUOM.190125 nykyään tapahtuu ulosheitto xfce:stä jotta sudo-muutokset tulisivat voimaan?	
}

function enforce_access() {
	dqb " enforce_access( ${1})"	

	${scm} 0440 /etc/sudoers.d/* 
	${scm} 0750 /etc/sudoers.d 
	${sco} -R root:root /etc/sudoers.d

	dqb "changing /sbin , /etc and /var 4 real"
	${sco} -R root:root /sbin
	${scm} -R 0755 /sbin

	${sco} -R root:root /etc
	for f in $(find /etc/sudoers.d/ -type f) ; do mangle2 ${f} ; done

	for f in $(find /etc -name 'sudo*' -type f | grep -v log) ; do 
		mangle2 ${f}
	done

	#sudoersin sisältöä voisi kai tiukentaa kanssa(?)
	${scm} 0755 /etc 
		
	${sco} -R root:root /var
	${scm} -R 0755 /var

	${sco} root:staff /var/local
	${sco} root:mail /var/mail
		
	${sco} -R man:man /var/cache/man 
	${scm} -R 0755 /var/cache/man

	${scm} 0755 /
	${sco} root:root /

	#ch-jutut siltä varalta että tar sössii oikeudet tai omistajat
	${sco} root:root /home
	${scm} 0755 /home

	#HUOM.140325:riittääköhän ao. tarkistus?
	if [ y"${1}" != "y" ] ; then
		dqb "444"
		${sco} -R ${1}:${1} ~
		csleep 5
	fi
	
	local f
	${scm} 0755 ~/Desktop/minimize	
	for f in $(find ~/Desktop/minimize -type d) ; do ${scm} 0755 ${f} ; done	
	for f in $(find ~/Desktop/minimize -type f) ; do ${scm} 0444 ${f} ; done	
	for f in $(find ~/Desktop/minimize -name '*.sh') ; do ${scm} 0755 ${f} ; done
	f=$(date +%F)

	[ -f /etc/resolv.conf.${f} ] || ${spc} /etc/resolv.conf /etc/resolv.conf.${f}
	[ -f /sbin/dhclient-script.${f} ] || ${spc} /sbin/dhclient-script /sbin/dhclient-script.${f}
	[ -f /etc/network/interfaces.${f} ] || ${spc} /etc/network/interfaces /etc/network/interfaces.${f}

	if [ -s /etc/resolv.conf.new ] && [ -s /etc/resolv.conf.OLD ] ; then
		${smr} /etc/resolv.conf 
	fi

	[ -s /sbin/dclient-script.OLD ] || ${spc} /sbin/dhclient-script /sbin/dhclient-script.OLD
	
	#TODO: se man chmod ao. riveihin liittyen, rwt... (kts nyt vielä miten oikeudet menivät ennen sorkintaa)
	#HUOM.280125:uutena seur rivit, poista jos pykii
	#0 drwxrwxrwt 7 root   root   220 Mar 16 22:41 .
	
	${scm} 0777 /tmp
	${sco} root:root /tmp
}

function part1() {
	#jos jokin näistä kolmesta hoitaisi homman...
	${sifd} ${iface}
	${sifd} -a
	${sip} link set ${iface} down

	[ $? -eq 0 ] || echo "PROBLEMS WITH NETWORK CONNECTION"
	[ ${debug} -eq 1 ] && /sbin/ifconfig;sleep 5 

	if [ y"${ipt}" == "y" ] ; then
		echo "5H0ULD-1N\$TALL-1PTABL35!!!"
		#ne ppre_part3-jutut sopivaan kohtaan? (kts. daedalus->lib->check_bin)
	else
		for t in INPUT OUTPUT FORWARD ; do 
			${ipt} -P ${t} DROP
			dqb "V6"; csleep 3
			${ip6t} -P ${t} DROP
			${ip6t} -F ${t}
		done

		for t in INPUT OUTPUT FORWARD b c e f ; do ${ipt} -F ${t} ; done

		if [ ${debug} -eq 1 ] ; then
			${ipt} -L #
			dqb "V6.b"; csleep 3
			${ip6t} -L # -x mukaan?
			sleep 5 
		fi #	
	fi

	#HUOM.1303225:joskohan tänä blokki toimisi
	if [ z"${pkgsrc}" != "z" ] ; then
		if [ -d ~/Desktop/minimize/${1} ] ; then
			if [ ! -s /etc/apt/sources.list.${1} ] ; then
				local g
			
				g=$(date +%F) 
				dqb "MUST MUTILATE sources.list FOR SEXUAL PURPOSES"
				csleep 3

				[ -f /etc/apt/sources.list ] && sudo mv /etc/apt/sources.list /etc/apt/sources.list.${g}
				${odio} touch /etc/apt/sources.list.${1} 
				${scm} a+w /etc/apt/sources.list.${1} 

				for x in ${1} ${1}-updates ${1}-security ; do
					echo "deb https://${pkgsrc}/merged ${x} main" >> /etc/apt/sources.list.${1}  
				done
		
				${slinky} /etc/apt/sources.list.${1} /etc/apt/sources.list			

				[ ${debug} -eq 1 ] && cat /etc/apt/sources.list
				csleep 2
			fi
		fi
	fi

	#${scm} a-w /etc/apt/sources.list
	${sco} -R root:root /etc/apt 
	${scm} -R a-w /etc/apt/
	dqb "FOUR-LEGGED WHORE (maybe i have tourettes)"
}

function part3() {
	dqb "part3()"
	[ y"${1}" == "y" ] && exit 1
	dqb "11"
	[ -d ${1} ] || exit 2

	dqb "22 ${sdi} ${1} / lib\*.deb"
	[ z"${sdi}" == "z" ] && exit 33
	#[ -x ${sdi} ] || exit 44 #1. kokeilulla pyki, jemmaan toistaiseksi
	
	local f
	for f in $(find ${1} -name 'lib*.deb') ; do ${sdi} ${f} ; done

	#VAIH:varmistus jotta sdi eityhjä+ajokelpoinen ennenq... (oikeastaan check_binaries* pitäisi hoitaa)

	if [ $? -eq  0 ] ; then
		dqb "part3.1 ok"
		csleep 5
		#${odio} shred -fu ${1}/lib*.deb
		${NKVD} ${1}/lib*.deb 
	else
	 	exit 66
	fi

	for f in $(find ${1} -name '*.deb') ; do ${sdi} ${f} ; done	

	if [ $? -eq  0 ] ; then
		dqb "part3.2 ok"
		csleep 5
		${NKVD} ${1}/*.deb 
	else
	 	exit 67
	fi

	csleep 2
}

function ecfx() {
	dqb "echx"

	#for .. do .. done saattaisi olla fiksumpi tässä (tai jokin find-loitsu)
	if [ -s ~/Desktop/minimize/xfce.tar ] ; then
		${srat} -C / -xvf ~/Desktop/minimize/xfce.tar
	else 
		if  [ -s ~/Desktop/minimize/xfce070325.tar ] ; then
			${srat} -C / -xvf ~/Desktop/minimize/xfce070325.tar
		fi
	fi
}

function vommon() {
	dqb "R (in 6 secs)"; csleep 6
	${odio} passwd
	
	if [ $? -eq 0 ] ; then
		dqb "L (in 6 secs)"; csleep 6
		passwd
	fi

	if [ $? -eq 0 ] ; then
		${whack} xfce4-session
		#HUOM. tässä ei tartte jos myöhemmin joka tap
		exit 	
	fi
} 

#VAIH:näitä josqs käyttööön
function tod_dda() { 
	${ipt} -A b -p tcp --sport 853 -s ${1} -j c
	${ipt} -A e -p tcp --dport 853 -d ${1} -j f
}

function dda_snd() {
	${ipt} -A b -p udp -m udp -s ${1} --sport 53 -j ACCEPT 
	${ipt} -A e -p udp -m udp -d ${1} --dport 53 -j ACCEPT
}

#HUOM.220624:stubbyn asentumisen ja käynnistymisen kannalta sleep saattaa olla tarpeen
function ns2() {
	[ y"${1}" == "y" ] && exit
	dqb "ns2( ${1} )"
	${scm} u+w /home
	csleep 3

	${odio} /usr/sbin/userdel ${1}
	sleep 3

	${odio} adduser --system ${1}
	sleep 3

	${scm} go-w /home
	${sco} -R ${1}:65534 /home/${1}/ #HUOM.280125: tässä saattaa mennä metsään ... tai sitten se /r/s.pid
	dqb "d0n3"
	csleep 4	

	[ ${debug} -eq 1 ]  && ls -las /home
	csleep 3
}

function ns4() {
	dqb "ns4( ${1} )"

	${scm} u+w /run
	${odio} touch /run/${1}.pid
	${scm} 0600 /run/${1}.pid
	${sco} ${1}:65534 /run/${1}.pid
	${scm} u-w /run

	sleep 5
	${whack} ${1}* #saattaa joutua muuttamaan vielä
	sleep 5

	dqb "starting ${1} in 5 secs"

	sleep 5
	${odio} -u ${1} ${1} -g
	echo $?

	sleep 1
	pgrep stubby*
	sleep 5
}

#VAIH:nämä käyttöön vähitellen (tai siis common_lib:in vastaava)
#HUOM.toisessa clouds:issa taisi olla pre-osuudessa muutakin
#pitäisiköhän se ipt-testi olla tässä?
#HUOM. jos mahd ni pitäisi kai sudoersissa speksata millä parametreilla mitäkin komerntoja ajetaan (man sudo, man sudoers)
function clouds_pre() {
	dqb "common_lib.clouds_pre()"

	#HUOM. rm-kikkailuja sietää vähän miettiä, jos vaikka prujaisi daedaluksen clouds:ista ne kikkrilut
	${smr} /etc/resolv.conf
	${smr} /etc/dhcp/dhclient.conf
	${smr} /sbin/dhclient-script

	csleep 1
	#HUOM.160325:lisätty uutena varm. vuoksi
	${iptr} /etc/iptables/rules.v4
	${ip6tr} /etc/iptables/rules.v6
	csleep 2

	#tässä oikea paikka tables-muutoksille vai ei?
	${ipt} -F b
	${ipt} -F e

	${ipt} -D INPUT 5
	${ipt} -D OUTPUT 6

	dqb "... done"
}

function clouds_post() {
	dqb "common_lib.clouds_post() "

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
 
	csleep 2

	if [ ${debug} -eq 1 ] ; then
		${ipt} -L  #
		${ip6t} -L #parempi ajaa vain jos löytyy
		csleep 5
	fi #

	dqb "d0n3"
}

#VAIH:tämäkin josqs käyttöön
function check_binaries() {
	dqb "ch3ck_b1nar135(${1} )"
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
	smr=$(sudo which rm) #VAIH:shred mukaan kanssa
	NKVD=$(sudo which shred)
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

#TODO:voisi tarkIStaa että mitkä komennot pitää jatkossa sudottaa kun omega ajettu (eli clouds käyttämät lähinnä)
function check_binaries2() {
	dqb "c0mm0n_lib.ch3ck_b1nar135.2()"

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
	lftr="${smr} -rf /run/live/medium/live/initrd.img* " 
	NKVD=$(${odio} which shred)
	NKVD="${NKVD} -fu "
	NKVD="${odio} ${NKVD}"
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