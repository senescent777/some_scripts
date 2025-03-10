#!/bin/bash
d=$(dirname $0)

if [ -s ${d}/conf ] && [ -s ${d}/lib.sh ] ; then
	. ${d}/conf
	. ${d}/lib.sh
else
	echo "TO CONTINUE FURTHER IS POINTLESS, ESSENTIAL FILES MISSING"
	exit 111	
fi

n=$(whoami)

function parse_opts_1() {
	case "${1}" in
		-v|--v)
			debug=1
		;;
		*)
			mode=${1}
		;;
	esac
}

#HUOM. mode otetaan jo parametriksi p_o_1:sessä, josko enforce kanssa?
 
function check_params() {
	case ${debug} in
		0|1)
			dqb "ko"
		;;
		*)
			echo "MEE HIMAAS LEIKKIMÄÄN"
			exit 4
		;;
	esac
}

function mangle_s() {
	local tgt
	[ y"${1}" == "y" ] && exit
	[ -s ${1} ] || exit  #-x sittenkin?
	[ y"${2}" == "y" ] && exit 
	[ -f ${2} ] || exit  

	tgt=${2}
	dqb "fr0m mangle_s(${1}, ${2}) : params_OK"; sleep 3

	sudo chmod 0555 ${1} #HUOM. miksi juuri 5? no six six six että suoritettavaan tdstoon ei tartte kirjoittaa
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
	dqb "3nf0rc3_acc355()"
	#HUOM. 070325: oli ao. loitsut / asti ennen pre_enforce():n puolella
	sudo chmod 0440 /etc/sudoers.d/* #hmiston kuiteskin parempi olla 0750
	sudo chmod 0750 /etc/sudoers.d 
	sudo chown -R root:root /etc/sudoers.d

	echo "changing /sbin , /etc and /var 4 real"
	${sco} -R root:root /sbin
	${scm} -R 0755 /sbin

	${sco} -R root:root /etc
	for f in $(find /etc/sudoers.d/ -type f) ; do mangle2 ${f} ; done

	#"find: ‘/etc/sudoers.d/’: Permission denied" jotain tarttis tehrä
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
		dqb "${sco} -R ${n}:${n} ~"
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

	${scm} 0777 /tmp
	${sco} root:root /tmp
}

#==================================PART 1============================================================
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

if [ $# -gt 0 ] ; then
	for opt in $@ ; do parse_opts_1 $opt ; done
fi

check_params 
[ ${enforce} -eq 1 ] && pre_enforce
enforce_access 

dqb "man date;man hwclock; sudo date --set | sudo hwclock --set --date if necessary" 
part1
g=$(date +%F)

if [ z"${pkgsrc}" != "z" ] ; then
	dqb "MUST MUTILATE sources.list"
	csleep 5
	[ -f /etc/apt/sources.list ] && sudo mv /etc/apt/sources.list /etc/apt/sources.list.${g}

	sudo touch /etc/apt/sources.list
	${scm} a+w /etc/apt/sources.list

	for x in ${distro} ${distro}-updates ${distro}-security ; do
		echo "deb https://${pkgsrc}/merged ${x} main non-free-firmware" >> /etc/apt/sources.list 
	done

	[ ${debug} -eq 1 ] && cat /etc/apt/sources.list
	csleep 10
fi

${scm} a-w /etc/apt/sources.list
${sco} -R root:root /etc/apt 
${scm} -R a-w /etc/apt/
[ ${mode} -eq 0 ] && exit

#HUOM.261224: ntpsec uutena
for s in avahi-daemon bluetooth cups cups-browsed exim4 nfs-common network-manager ntp mdadm saned rpcbind lm-sensors dnsmasq stubby ntpsec ; do
	${odio} /etc/init.d/${s} stop
	sleep 1
done

dqb "shutting down some services (4 real) in 3 secs"
sleep 3 

#pitäisiköhän näillekin tehdä jotain=
${whack} cups*
${whack} avahi*
${whack} dnsmasq*
${whack} stubby*
${whack} nm-applet

#ntp ehkä takaisin myöhemmin
${whack} ntp*
csleep 10
${odio} /etc/init.d/ntpsec stop
#K01avahi-jutut sopivaan kohtaan?

#===================================================PART 2===================================
#for .. do .. done saattaisi olla fiksumpi tässä
if [ -s ~/Desktop/minimize/xfce.tar ] ; then
	${srat} -C / -xvf ~/Desktop/minimize/xfce.tar
else 
	if  [ -s ~/Desktop/minimize/xfce070325.tar ] ; then
		${srat} -C / -xvf ~/Desktop/minimize/xfce070325.tar
	fi
fi

csleep 10

if [ ${mode} -eq 1 ] ; then
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
fi

${sharpy} libblu* network* libcupsfilters* libgphoto* 
# libopts25 ei tömmöistä daedaluksessa

${sharpy} avahi* blu* cups* exim*
${sharpy} rpc* nfs* 
${sharpy} modem* wireless* wpa*
${sharpy} iw lm-sensors

${sharpy} ntp*
${sharpy} po* pkexec
${lftr}
csleep 3

if [ y"${ipt}" != "y" ] ; then 
	${ip6tr} /etc/iptables/rules.v6
	${iptr} /etc/iptables/${tblz4}
fi

#HUOM.270624:oli aikaisemmin tässä clouds.sh 0

csleep 5
${lftr} 
csleep 3

if [ ${debug} -eq 1 ] ; then
	${snt} -tulpan
	sleep 5
fi #

#===================================================PART 3===========================================================
dqb "INSTALLING NEW PACKAGES IN 10 SECS"
csleep 3

echo "DO NOT ANSWER \"Yes\" TO A QUESTION ABOUT IPTABLES";sleep 2
echo "... FOR POSITIVE ANSWER MAY BREAK THINGS";sleep 5

#toimiiko? jos vaikka
pre_part3 ${d}
pr4 ${d}
part3 ${d}
#(daudaluksen kanssa ok mutta chimaera...)

echo $?
sleep 3
${ip6tr} /etc/iptables/rules.v6

#VAIH:se ffox-profiili-asia (mallia sieltä ghubin toisesta hmistosta)
if [ -x ~/Desktop/minimize/profs.sh ] ; then
	. ~/Desktop/minimize/profs.sh
	copyprof ${n} someparam
fi

${asy}
dqb "GR1DN BELIALAS KYE"

sudo ${d}/clouds.sh 0
csleep 5

${scm} a-wx ~/Desktop/minimize/*.sh
${scm} a-wx $0 #oikeastaan kerta-ajo tulisi riittää

#===================================================PART 4(final)==========================================================

if [ ${mode} -eq 2 ] ; then
	echo "time to ${sifu} ${iface} or whåtever"
	csleep 5
	${whack} xfce4-session
 	exit 
fi

#070235: heittääkö pihalle xfce:stä tuossa yllä vai ei? vissiin pitää muuttaa parametreja
sudo ${d}/clouds.sh 1

#VAIH:stubby-jutut toimimaan
#ongelmana error: Could not bind on given addresses: Permission denied
dqb "MESSIAH OF IMPURITY AND DARKNESS"
csleep 4

if [ ${debug} -eq 1 ] ; then 
	${snt} -tulpan
	sleep 5
	pgrep stubby*
	sleep 5
fi

echo "time to ${sifu} ${iface} or whåtever"
echo "P.S. if stubby dies, resurrect it with \"restart_stubby.desktop\" "

if [ ${debug} -eq 1 ] ; then 
	sleep 5
	#whack xfce so that the ui is reset
	${whack} xfce4-session
fi