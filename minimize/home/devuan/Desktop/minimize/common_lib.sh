odio=$(which sudo)
[ y"${odio}" == "y" ] && exit 99 
[ -x ${odio} ] || exit 100

fix_sudo() {
	${odio} chown -R 0:0 /etc/sudoers.d #pitääköhän juuri tässä tehdä tämä? jep
	${odio} chmod 0440 /etc/sudoers.d/* 
	
	echo "#VAIH:kts loput suq.ash"
	sudo chown -R 0:0 /etc/sudo*
	sudo chmod -R a-w /etc/sudo*

	echo "sudo chown -R 0:0 ./usr/lib/sudo/*"
	echo "sudo chown -R 0:0 ./usr/bin/sudo*"
	
	sudo chmod 0750 ./etc/sudoers.d
	sudo chmod 0440 /etc/sudoers.d/*

	echo "sudo chmod -R a-w ./usr/lib/sudo/*"
	echo "sudo chmod -R a-w ./usr/bin/sudo*"
	echo "sudo chmod 4555 ./usr/bin/sudo"
	echo "sudo chmod 0444	./usr/lib/sudo/sudoers.so"
	echo "sudo chattr +ui ./usr/bin/sudo"
	echo "sudo chattr +ui ./usr/lib/sudo/sudoers.so	"
}

function dqb() {
	[ ${debug} -eq 1 ] && echo ${1}
}

function csleep() {
	[ ${debug} -eq 1 ] && sleep ${1}
}

fix_sudo
#
##pr4(), pp3(), p3() distro-spesifisiä, ei tähän tdstoon
#
##TODO:jatkossa chimaeRan doit6 käyttämään tätä jos mahd
#function ocs() {
#	local tmp
#	tmp=$(sudo which ${1})
#
#	if [ y"${tmp}" == "y" ] ; then
#		exit 66 #fiksummankin exit-koodin voisi keksiä
#	else
#	fi
#
#	if [ -x ${tmp} ] ; then	
#	else
#		exit 77
#	fi
#
#	CB_LIST1="${CB_LIST1} ${tmp} " #ja nimeäminenkin...
#}
#
##check_binaries(), check_binaries2() , distro-spesifisiä vai ei? (TODO: let's find out)
#
##HUOM. jos tätä käyttää ni scm ja sco pitää tietenkin esitellä alussa
#function mangle2() {
#	if [ -f ${1} ] ; then 
#		dqb "MANGLED ${1}"
#		${scm} o-rwx ${1}
#		${sco} root:root ${1}
#	fi
#}
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
##TODO:gpo jo käyttöön?
##TODO:part1 tähän vai ei?
#
#function mangle_s() {
#local tgt
#	[ y"${1}" == "y" ] && exit
#	[ -s ${1} ] || exit  
#	[ y"${2}" == "y" ] && exit 
#	[ -f ${2} ] || exit  
#
#	tgt=${2}
#
#	sudo chmod 0555 ${1} #HUOM. miksi juuri 5? no six six six että suoritettavaan tdstoon ei tartte kirjoittaa
#	sudo chown root:root ${1} 
#
#	local s
#	s=$(sha256sum ${1})
#	sudo echo "${n} localhost=NOPASSWD: sha256: ${s} " >> ${tgt}
#}
#
##HUOm.080325 sietäisi kai harkita chimaeralle ja daedalukselle yhteistä kirjasrtoa
#
#function pre_enforce() {
#	#HUOM.230624 /sbin/dhclient* joutuisi hoitamaan toisella tavalla q mangle_s	
#	local q
#	q=$(mktemp -d)	
#	local f 
#
#	dqb "sudo touch ${q}/meshuggah in 5 secs"
#	csleep 5
#	sudo touch ${q}/meshuggah
#
#	[ ${debug} -eq 1 ] && ls -las ${q}
#	csleep 6
#	[ -f ${q}/meshuggah ] || exit
#	dqb "ANNOYING AMOUNT OF DEBUG"
#
#	sudo chown ${n}:${n} ${q}/meshuggah #oli: 1k:1k
#	sudo chmod 0660 ${q}/meshuggah	
#		
#	for f in ${CB_LIST1} ; do mangle_s ${f} ${q}/meshuggah ; done
#	#TODO:clouds: a) nimeäminen fiksummin 
#	for f in ~/Desktop/minimize/${distro}/clouds.sh /sbin/halt /sbin/reboot ; do mangle_s ${f} ${q}/meshuggah ; done
#	
#	if [ -s ${q}/meshuggah ] ; then
#		dqb "sudo mv ${q}/meshuggah /etc/sudoers.d in 5 secs"
#		csleep 5
#
#		sudo chmod a-wx ${q}/meshuggah
#		sudo chown root:root ${q}/meshuggah	
#		sudo mv ${q}/meshuggah /etc/sudoers.d
#	fi
#
#	#HUOM.190125 nykyään tapahtuu ulosheitto xfce:stä jotta sudo-muutokset tulisivat voimaan?
#	
#}
#
#function enforce_access() {
#	#HUOM. ao. sudo-kikkailut korvannee jatkossa fix_sudo tai siis näin olisi tarkoitus
#	#HUOM. 070325: oli ao. loitsut / asti ennen pre_enforce():n puolella
#	sudo chmod 0440 /etc/sudoers.d/* #hmiston kuiteskin parempi olla 0750
#	sudo chmod 0750 /etc/sudoers.d 
#	sudo chown -R root:root /etc/sudoers.d
#
#	echo "changing /sbin , /etc and /var 4 real"
#	${sco} -R root:root /sbin
#	${scm} -R 0755 /sbin
#
#	${sco} -R root:root /etc
#	for f in $(find /etc/sudoers.d/ -type f) ; do mangle2 ${f} ; done
#
#	#"find: ‘/etc/sudoers.d/’: Permission denied" jotain tarttis tehrä?
#	for f in $(find /etc -name 'sudo*' -type f | grep -v log) ; do 
#		mangle2 ${f}
#		#csleep 1
#	done
#
#	#sudoersin sisältöä voisi kai tiukentaa kanssa(?)
#	${scm} 0755 /etc 
#		
#	${sco} -R root:root /var
#	${scm} -R 0755 /var
#
#	${sco} root:staff /var/local
#	${sco} root:mail /var/mail
#		
#	${sco} -R man:man /var/cache/man 
#	${scm} -R 0755 /var/cache/man
#
#	${scm} 0755 /
#	${sco} root:root /
#
#	#ch-jutut siltä varalta että tar sössii oikeudet tai omistajat
#	${sco} root:root /home
#	${scm} 0755 /home
#
#	if [ y"${n}" != "y" ] ; then
#		#josko vielä testaisi että $n asetettu ylipäänsä
#		${sco} -R ${n}:${n} ~
#		csleep 5
#	fi
#	
#	local f
#	${scm} 0755 ~/Desktop/minimize	
#	for f in $(find ~/Desktop/minimize -type d) ; do ${scm} 0755 ${f} ; done	
#	for f in $(find ~/Desktop/minimize -type f) ; do ${scm} 0444 ${f} ; done	
#	${scm} a+x ${d}/*.sh
#	
#	f=$(date +%F)
#	[ -f /etc/resolv.conf.${f} ] || ${spc} /etc/resolv.conf /etc/resolv.conf.${f}
#	[ -f /sbin/dhclient-script.${f} ] || ${spc} /sbin/dhclient-script /sbin/dhclient-script.${f}
#	[ -f /etc/network/interfaces.${f} ] || ${spc} /etc/network/interfaces /etc/network/interfaces.${f}
#
#	if [ -s /etc/resolv.conf.new ] && [ -s /etc/resolv.conf.OLD ] ; then
#		${smr} /etc/resolv.conf 
#	fi
#
#	[ -s /sbin/dclient-script.OLD ] || ${spc} /sbin/dhclient-script /sbin/dhclient-script.OLD
#
#	#HUOM.280125:uutena seur rivit, poista jos pykii
#	${scm} 0777 /tmp
#	${sco} root:root /tmp
#}
#