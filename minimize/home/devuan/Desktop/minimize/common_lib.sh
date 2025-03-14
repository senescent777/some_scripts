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
function ocs() {
	local tmp
	tmp=$(sudo which ${1})

	if [ y"${tmp}" == "y" ] ; then
		exit 66 #fiksummankin exit-koodin voisi keksiä
	fi

	if [ ! -x ${tmp} ] ; then
		exit 77
	fi

	CB_LIST1="${CB_LIST1} ${tmp} " #ja nimeäminenkin...
}

#check_binaries(), check_binaries2() , distro-spesifisiä vai ei? (TODO: let's find out?)

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
	local tgt #turha
	[ y"${1}" == "y" ] && exit
	[ -x ${1} ] || exit  #oli -s
	[ y"${2}" == "y" ] && exit 
	[ -f ${2} ] || exit  

	tgt=${2} #turha

	sudo chmod 0555 ${1}
	#HUOM. miksi juuri 5? no six six six että suoritettavaan tdstoon ei tartte kirjoittaa
	sudo chown root:root ${1} 

	local s
	s=$(sha256sum ${1})
	sudo echo "${n} localhost=NOPASSWD: sha256: ${s} " >> ${tgt}
}

#HUOm.080325 sietäisi kai harkita chimaeralle ja daedalukselle yhteistä kirjasrtoa

function pre_enforce() {
	#HUOM.230624 /sbin/dhclient* joutuisi hoitamaan toisella tavalla q mangle_s	
	local q
	q=$(mktemp -d)	
	local f 

	dqb "sudo touch ${q}/meshuggah in 5 secs"
	csleep 5
	sudo touch ${q}/meshuggah

	[ ${debug} -eq 1 ] && ls -las ${q}
	csleep 6
	[ -f ${q}/meshuggah ] || exit
	dqb "ANNOYING AMOUNT OF DEBUG"

	if [ z"${1}" != "z" ] ; then
		dqb "333"
		${odio} chown ${1}:${1} ${q}/meshuggah 
 		${odio} chmod 0660 ${q}/meshuggah	
	fi	
	
	for f in ${CB_LIST1} ; do mangle_s ${f} ${q}/meshuggah ; done
	#TODO:globaali mja wttuun
	for f in ~/Desktop/minimize/${distro}/clouds.sh /sbin/halt /sbin/reboot ; do mangle_s ${f} ${q}/meshuggah ; done
	
	if [ -s ${q}/meshuggah ] ; then
		dqb "sudo mv ${q}/meshuggah /etc/sudoers.d in 5 secs"
		csleep 5

		sudo chmod a-wx ${q}/meshuggah
		sudo chown root:root ${q}/meshuggah	
		sudo mv ${q}/meshuggah /etc/sudoers.d
	fi

	#HUOM.190125 nykyään tapahtuu ulosheitto xfce:stä jotta sudo-muutokset tulisivat voimaan?	
}

function enforce_access() {
	sudo chmod 0440 /etc/sudoers.d/* #hmiston kuiteskin parempi olla 0750
	sudo chmod 0750 /etc/sudoers.d 
	sudo chown -R root:root /etc/sudoers.d

	echo "changing /sbin , /etc and /var 4 real"
	${sco} -R root:root /sbin
	${scm} -R 0755 /sbin

	${sco} -R root:root /etc
	for f in $(find /etc/sudoers.d/ -type f) ; do mangle2 ${f} ; done

	#"find: ‘/etc/sudoers.d/’: Permission denied" jotain tarttis tehrä?
	for f in $(find /etc -name 'sudo*' -type f | grep -v log) ; do 
		mangle2 ${f}
		#csleep 1
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
	${scm} a+x ${d}/*.sh
	
	f=$(date +%F)
	[ -f /etc/resolv.conf.${f} ] || ${spc} /etc/resolv.conf /etc/resolv.conf.${f}
	[ -f /sbin/dhclient-script.${f} ] || ${spc} /sbin/dhclient-script /sbin/dhclient-script.${f}
	[ -f /etc/network/interfaces.${f} ] || ${spc} /etc/network/interfaces /etc/network/interfaces.${f}

	if [ -s /etc/resolv.conf.new ] && [ -s /etc/resolv.conf.OLD ] ; then
		${smr} /etc/resolv.conf 
	fi

	[ -s /sbin/dclient-script.OLD ] || ${spc} /sbin/dhclient-script /sbin/dhclient-script.OLD
	#TODO: se man chmod ao. riveihin liittyen, rwt...
	#HUOM.280125:uutena seur rivit, poista jos pykii
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
		#TODO:ne ppre_part3-jutut sopivaan kohtaan? (daedalus->lib->check_bin)
	else
		for t in INPUT OUTPUT FORWARD ; do 
			${ipt} -P ${t} DROP
			dqb "V6"; csleep 5
			${ip6t} -P ${t} DROP
			${ip6t} -F ${t}
		done

		for t in INPUT OUTPUT FORWARD b c e f ; do ${ipt} -F ${t} ; done

		if [ ${debug} -eq 1 ] ; then
			${ipt} -L #
			dqb "V6.b"; csleep 5
			${ip6t} -L #
			sleep 5 
		fi #	
	fi

	#HUOM.1303225:joskohan tänä blokki toimisi
	if [ z"${pkgsrc}" != "z" ] ; then
		#if [ ! -s /etc/apt/sources.list.${distro 
		#TODO:tulisi kai tarkistaa se minimizen alihmiston olemassaolo kanssa
		if [ ! -s /etc/apt/sources.list.${1} ] ; then
			local g
			g=$(date +%F) 
			dqb "MUST MUTILATE sources.list FOR SEXUAL PURPOSES"
			csleep 5

			[ -f /etc/apt/sources.list ] && sudo mv /etc/apt/sources.list /etc/apt/sources.list.${g}
			sudo touch /etc/apt/sources.list.${1} #${distro}
			${scm} a+w /etc/apt/sources.list.${1} #${distro}

			#for x in ${distro} ${distro}-updates ${distro}-security ; do
			for x in ${1} ${1}-updates ${1}-security ; do
				echo "deb https://${pkgsrc}/merged ${x} main" >> /etc/apt/sources.list.${1} #${distro} 
			done
		
			#slinky
			#${odio} ln -s /etc/apt/sources.list.${distro} /etc/apt/sources.list
			${slinky} /etc/apt/sources.list.${1} /etc/apt/sources.list			

			[ ${debug} -eq 1 ] && cat /etc/apt/sources.list
			csleep 5
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
	
	${sdi} ${1}/lib*.deb
	#TODO:pitäisi kai mennä findin kautta jottei kosahda sopivanlaistEn .deb-tdstojen puutteeseen
	#VAIH:varmistus jotta sdi eityhjä+ajokelpoinen ennenq... (oikeastaan check_binaries* pitäisi hoitaa)

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

function ecfx() {
	#for .. do .. done saattaisi olla fiksumpi tässä
	if [ -s ~/Desktop/minimize/xfce.tar ] ; then
		${srat} -C / -xvf ~/Desktop/minimize/xfce.tar
	else 
		if  [ -s ~/Desktop/minimize/xfce070325.tar ] ; then
			${srat} -C / -xvf ~/Desktop/minimize/xfce070325.tar
		fi
	fi
}

#TODO:jos vähitellen teatsisi toiminnan
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

#TODO:näitä josqs käyttööön
#function tod_dda() { 
#	${ipt} -A b -p tcp --sport 853 -s ${1} -j c
#       ${ipt} -A e -p tcp --dport 853 -d ${1} -j f
#}
#
#function dda_snd() {
#	${ipt} -A b -p udp -m udp -s ${1} --sport 53 -j ACCEPT 
#	${ipt} -A e -p udp -m udp -d ${1} --dport 53 -j ACCEPT
#}
#HUOM.220624:stubbyn asentumisen ja käynnistymisen kannalta sleep saattaa olla tarpeen
#function ns2() {
#	[ y"${1}" == "y" ] && exit
#	dqb "ns2( ${1} )"
#	${scm} u+w /home
#	csleep 3
#
#	${odio} /usr/sbin/userdel ${1}
#	sleep 3
#
#	${odio} adduser --system ${1}
#	sleep 3
#
#	${scm} go-w /home
#	${sco} -R ${1}:65534 /home/${1}/ #HUOM.280125: tässä saattaa mennä metsään ... tai sitten se /r/s.pid
#	dqb "d0n3"
#	csleep 4	
#
#	[ ${debug} -eq 1 ]  && ls -las /home
#	csleep 3
#}
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
#function clouds_pre() {}
#function clouds_post() {
#
#${scm} 0444 /etc/resolv.conf*
#${sco} root:root /etc/resolv.conf*
#
#${scm} 0444 /etc/dhcp/dhclient*
#${sco} root:root /etc/dhcp/dhclient*
#${scm} 0755 /etc/dhcp
#
#${scm} 0555 /sbin/dhclient*
#${sco} root:root /sbin/dhclient*
#${scm} 0755 /sbin
#
#${sco} -R root:root /etc/iptables
#${scm} 0400 /etc/iptables/*
#${scm} 0750 /etc/iptables
# 
#sleep 2
#
##if [ ${debug} -eq 1 ] ; then
#	${ipt} -L  #
#	${ip6t} -L #
#	sleep 5
##fi #
#
#}
#HUOM.140325:käytännössä samat chim ja daed
#TODO:jatkossa käyttöön
#function check_binaries2() {
#	dqb "ch3ck_b1nar135.2()"
#
#	ipt="${odio} ${ipt} "
#	ip6t="${odio} ${ip6t} "
#	iptr="${odio} ${iptr} "
#	ip6tr="${odio} ${ip6tr} "
#
#	whack="${odio} ${whack} --signal 9 "
#	snt="${odio} ${snt} "
#	sharpy="${odio} ${sag} remove --purge --yes "
#	spd="${odio} ${sdi} -l "
#	sdi="${odio} ${sdi} -i "
#	
#	#HUOM. ${sag} VIIMEISENÄ
#	shary="${odio} ${sag} --no-install-recommends reinstall --yes "
#	sag_u="${odio} ${sag} update "
#	sag="${odio} ${sag} "
#
#	sco="${odio} ${sco} "
#	scm="${odio} ${scm} "
#	sip="${odio} ${sip} "
#
#	sa="${odio} ${sa} "
#	sifu="${odio} ${sifu} "
#	sifd="${odio} ${sifd} "
#
#	smr="${odio} ${smr} "
#	lftr="${smr} -rf /run/live/medium/live/initrd.img* " #shred myös keksitty
#	slinky="${odio} ${slinky} -s "
#
#	spc="${odio} ${spc} "
#	srat="${odio} ${srat} "
#	asy="${odio} ${sa} autoremove --yes"
#
#	fib="${odio} ${sa} --fix-broken install"
#	som="${odio} ${som} "
#	uom="${odio} ${uom} "	
#
#	#smr="${odio} ${smr} "
#	dch="${odio} ${dch}"
#	dqb "b1nar135.2 0k.2" 
#	csleep 3
#}