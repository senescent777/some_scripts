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

#TODO:$sco ja $scm käyttöön jatq§
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

##check_binaries(), check_binaries2() , distro-spesifisiä vai ei? (TODO: let's find out)
#
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
	local tgt
	[ y"${1}" == "y" ] && exit
	[ -x ${1} ] || exit  #oli -s
	[ y"${2}" == "y" ] && exit 
	[ -f ${2} ] || exit  

	tgt=${2}

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

	sudo chown ${n}:${n} ${q}/meshuggah #oli: 1k:1k
	sudo chmod 0660 ${q}/meshuggah	
		
	for f in ${CB_LIST1} ; do mangle_s ${f} ${q}/meshuggah ; done
	#TODO:clouds: a) nimeäminen fiksummin 
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

	if [ y"${n}" != "y" ] ; then
		#josko vielä testaisi että $n asetettu ylipäänsä
		${sco} -R ${n}:${n} ~
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
		#TODO:ne ppre_part3-jutut sopivaan kohtaan
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

	#VAIH:testaa tuo linkkaus-kikkailu
	if [ z"${pkgsrc}" != "z" ] ; then
		local g
		g=$(date +%F) 
		dqb "MUST MUTILATE sources.list FOR SEXUAL PURPOSES"
		csleep 5
		[ -f /etc/apt/sources.list ] && sudo mv /etc/apt/sources.list /etc/apt/sources.list.${g}

		sudo touch /etc/apt/sources.list.${distro}
		${scm} a+w /etc/apt/sources.list.${distro}

		for x in ${distro} ${distro}-updates ${distro}-security ; do
			echo "deb https://${pkgsrc}/merged ${x} main non-free-firmware" >> /etc/apt/sources.list.${distro} 
		done
		
		#slinky
		${odio} ln -s /etc/apt/sources.list.${distro} /etc/apt/sources.list
		[ ${debug} -eq 1 ] && cat /etc/apt/sources.list
		csleep 5
	fi

	${scm} a-w /etc/apt/sources.list
	${sco} -R root:root /etc/apt 
	${scm} -R a-w /etc/apt/

	dqb "FOUR-LEGGED WHORE (maybe i have tourettes)"
}

function part3() {
	[ y"${1}" == "y" ] && exit 1
	dqb "11"
	[ -d ${1} ] || exit 2

	dqb "22 ${sdi} ${1}/lib*.deb"
	${sdi} ${1}/lib*.deb

	#TODO:varmistus jotta sdi eityhjä+ajokelpoinen ennenq... (oikeastaan check_binaries* pitäisi hoitaa)

	if [ $? -eq  0 ] ; then
		dqb "part3.1 ok"
		sleep 5
		${odio} shred -fu ${1}/lib*.deb
	else
	 	dqb "exit 66" #TODO:jatkossa oikeasti exit?
	fi

	${sdi} ${1}/*.deb
	
	if [ $? -eq  0 ] ; then
		dqb "part3.2 ok"
		sleep 5
		${odio} shred -fu ${1}/*.deb 
	else
	 	dqb "exit 67" #TODO:jatkossa oikeasti exit?
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