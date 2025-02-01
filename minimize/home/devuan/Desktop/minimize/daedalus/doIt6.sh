#!/bin/bash
d=$(dirname $0)

if [ -s ${d}/conf ] && [ -s ${d}/lib.sh ] ; then
	. ${d}/conf
	. ${d}/lib.sh
else
	echo "TO CONTINUE FURTHER IS POINTLESS, ESSENTIAL FILES MISSING"
	exit 111	
fi

#HUOM. 260125: suattaapi olla niinnii jotta "80 megaa vs 180" ei liity suoraan paketteihin
#DONE?:/v/c/man-nalkutus (sopisi olla ainakin)
#180125:/tmp-jekku kai toimii jo
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

#HUOM. _s - kutsun oltava ennenq check_binaries2() kutsutaan tjsp.
#HUOM.2. ei niitä {sco}-juttuja ao. fktioon, varm vuoksi

function mangle_s() {
	local tgt
	[ y"${1}" == "y" ] && exit 
	tgt=${2}
	dqb "fr0m mangle_s(${1}, ${2}) : params_OK"; sleep 3

	if [ -s ${1} ] ; then 
		#chattr -ui ${1} #chattr ei välttämättä toimi overlay'n tai squashfs'n kanssa
		#csleep 1
		
		sudo chmod 0555 ${1} #HUOM. miksi juuri 5? no six six six että suoritettavaan tdstoon ei tartte kirjoittaa
		sudo chown root:root ${1} 
		#chattr +ui ${1}

		#csleep 1
		local s
		#local n
#
		#n=$(whoami) #olisi myös %users...
		s=$(sha256sum ${1})
		sudo echo "${n} localhost=NOPASSWD: sha256: ${s} " >> ${tgt}
		#sleep 1
	else
		dqb "no sucg file as ${1} "
	fi
}

function pre_enforce() {
	#HUOM.230624 /sbin/dhclient* joutuisi hoitamaan toisella tavalla q mangle_s	
	local q
	q=$(mktemp -d)	
	local f 

	#jotain tolkkua tähän if-blokkiin olisi hyvä saada(esim mv pois)
	#if [ -f /etc/sudoers.d/meshuggah ] ; then
	#	#sudo mv /etc/sudoers.d/meshuggah /etc/sudoers.d/meshuggah.0LD
	#	[ $? -eq 0 ] && dqb "a51a kun05a"
	#else	
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
		for f in /etc/init.d/stubby ~/Desktop/minimize/${distro}/clouds.sh /sbin/halt /sbin/reboot ; do mangle_s ${f} ${q}/meshuggah ; done
	#fi
	
	if [ -s ${q}/meshuggah ] ; then
		dqb "sudo mv ${q}/meshuggah /etc/sudoers.d in 5 secs"
		csleep 5

		sudo chmod a-wx ${q}/meshuggah
		sudo chown root:root ${q}/meshuggah	
		sudo mv ${q}/meshuggah /etc/sudoers.d
	fi

	#HUOM.190125 nykyään tapahtuu ulosheitto xfce:stä jotta sudo-muutokset tulisivat voimaan?
	
	sudo chmod 0440 /etc/sudoers.d/* #hmiston kuiteskin parempi olla 0750
	sudo chmod 0750 /etc/sudoers.d 
	sudo chown -R root:root /etc/sudoers.d

	echo "changing /sbin , /etc and /var 4 real"
	${sco} -R root:root /sbin
	${scm} -R 0755 /sbin

	#this part inspired by:https://raw.githubusercontent.com/senescent777/project/main/opt/bin/part0.sh
	#HUOM! ei sitten sorkita /etc sisältöä tässä (?)
	${sco} -R root:root /etc

	#erillinen mangle2 /e/s.d tarpeellinen? vissiin juuri sudoers.d/* takia
	#HUOM.080125:olikohan peräti tarpeellista että erikseen pre_e ja sitten tämä?		
	for f in $(find /etc/sudoers.d/ -type f) ; do mangle2 ${f} ; done

	#"find: ‘/etc/sudoers.d/’: Permission denied" jotain tarttis tehrä
	for f in $(find /etc -name 'sudo*' -type f | grep -v log) ; do 
		mangle2 ${f}
		#csleep 1
	done

	#sudoersin sisältöä voisi kai tiukentaa kanssa(?)
	${scm} 0755 /etc 

	#HUOM. 080125:tästgä saattaa tulla jotain nalkutusta
	#pitäisi kai jotenkin huomioida:
	#0 drwxrwsr-x 2 root staff   3 May 10  2023 local
	#0 drwxr-xr-x 1 root root  360 Jan  8 21:46 log
	#0 drwxrwsr-x 2 root mail    3 Jul 20  2023 mail
		
	${sco} -R root:root /var
	${scm} -R 0755 /var

	${sco} root:staff /var/local
	${sco} root:mail /var/mail
		
	#jokohan alkaisi nalkutus loppua?
	${sco} -R man:man /var/cache/man 
	${scm} -R 0755 /var/cache/man

	${scm} 0755 /
	${sco} root:root /
}

#HUOM.270125.1: pelkkä enforce=1 viimeisimmän mergen mukaisissa skripteissä -> login ok
#HUOM.270125.2:entä alun chmod+chown? edelleen login ok
#HUOM.270125.3: /etc sorkkiminen? vissiin ok
#HUOM.270125.4 /var? ok edelleen
function enforce_access() {
	dqb "3nf0rc3_acc355()"

	#ch-jutut siltä varalta että tar sössii oikeudet tai omistajat
	${sco} root:root /home
	${scm} 0755 /home

	#HUOM.260125: saattoipa loginin pykiminen aiheutua alustamatt0omasta mjasta n (tai sit ei)
	#local n
	#n=$(whoami)

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
	${scm} a+x ~/Desktop/minimize/${distro}/*.sh
	
	f=$(date +%F)
	[ -f /etc/resolv.conf.${f} ] || ${spc} /etc/resolv.conf /etc/resolv.conf.${f}
	[ -f /sbin/dhclient-script.${f} ] || ${spc} /sbin/dhclient-script /sbin/dhclient-script.${f}
	[ -f /etc/network/interfaces.${f} ] || ${spc} /etc/network/interfaces /etc/network/interfaces.${f}

	if [ -s /etc/resolv.conf.new ] && [ -s /etc/resolv.conf.OLD ] ; then
		${smr} /etc/resolv.conf 
	fi

	[ -s /sbin/dclient-script.OLD ] || ${spc} /sbin/dhclient-script /sbin/dhclient-script.OLD

	#HUOM.280125:uutena seur rivit, poista jos pykii
	${scm} 0777 /tmp
	${sco} root:root /tmp
}

#==================================PART 1============================================================

if [ $# -gt 0 ] ; then
	for opt in $@ ; do parse_opts_1 $opt ; done
fi

check_params 
[ ${enforce} -eq 1 ] && pre_enforce
enforce_access 

dqb "man date;man hwclock; sudo date --set | sudo hwclock --set --date if necessary" 
part1
g=$(date +%F)

#roiskisikohan nuo sources.list ja muut part1:seen?

if [ -s /etc/apt/sources.list.tmp ] ; then #tämän kanssa tarttisi tehd vielä jotain?
	dqb "https://raw.githubusercontent.com/senescent777/project/main/home/devuan/Dpckcer/buildr/bin/mutilate_sql_2.sh"
	csleep 5
	
	[ -f /etc/apt/sources.list ] && sudo mv /etc/apt/sources.list /etc/apt/sources.list.${g}

	sudo touch /etc/apt/sources.list
	${scm} a+w /etc/apt/sources.list

	${odio} sed -i 's/DISTRO/daedalus/g' /etc/apt/sources.list.tmp #>> /etc/apt/sources.list
	sudo mv /etc/apt/sources.list.tmp /etc/apt/sources.list

	${scm} a-w /etc/apt/sources.list
	${sco} -R root:root /etc/apt #/sources.list
	${scm} -R a-w /etc/apt/

	[ ${debug} -eq 1 ] && ls -las /etc/apt
	csleep 5
fi

#HUOM.310125: muista testata ainakin tässä kohtaa meneekö slim rikki
[ ${mode} -eq 0 ] && exit

#HUOM.261224: ntpsec uutena
for s in avahi-daemon bluetooth cups cups-browsed exim4 nfs-common network-manager ntp mdadm saned rpcbind lm-sensors dnsmasq stubby ntpsec ; do
	${odio} /etc/init.d/${s} stop
	sleep 1
done

dqb "shutting down some services (4 real) in 3 secs"
sleep 3 

${whack} cups*
${whack} avahi*
${whack} dnsmasq*
${whack} stubby*
${whack} nm-applet

#ntp ehkä takaisin myöhemmin
${whack} ntp*
${odio} /etc/init.d/ntpsec stop
#K01avahi-jutut sopivaan kohtaan?

#===================================================PART 2===================================
#[ ${debug} -eq 1 ] && ${spd} > ${d}/pkgs-${g}.txt
##debug-syistä tuo yo. rivi
#csleep 6
${sharpy} color* #uutena 010225
${sharpy} libblu* network* libcupsfilters* libgphoto* 
# libopts25 ei tömmöistä daedaluksessa

${sharpy} avahi* blu* cups* exim*
${sharpy} rpc* nfs* 
${sharpy} modem* wireless* wpa*
${sharpy} iw lm-sensors

#paketin mdadm poisto siirretty tdstoon pt2.sh päiväyksellä 220624
${sharpy} ntp*

#uutena 050125, alunp. pol-paketit pois koska slahdot tammikuun -22 lopussa 
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
dqb "INSTALLING NEW PACKAGES FROM ${pkgdir} IN 10 SECS"
csleep 3

echo "DO NOT ANSWER \"Yes\" TO A QUESTION ABOUT IPTABLES";sleep 2
echo "... FOR POSITIVE ANSWER MAY BREAK THINGS";sleep 5

pre_part3 ${pkgdir}
#${whack} xfce* 
#exit 	#HUOM.0101225:tässä kohtaa vielä kirjautuminen takaisin sisään onnaa

part3 ${pkgdir}
echo $?
sleep 3
${ip6tr} /etc/iptables/rules.v6

#toimii miten toimii tämä if-blokki (let's find out?)
if [ ${mode} -eq 1 ] ; then
	dqb "R (in 6 secs)"; csleep 6
	${odio} passwd

	dqb "L (in 6 secs)"; csleep 6
	passwd

	if [ $? -eq 0 ] ; then
		${whack} xfce* #HUOM. tässä ei tartte jos myöhemmin joka tap
		exit 	
	fi
fi

${asy}
dqb "GR1DN BELIALAS KYE"

#VAIH:clouds uusix kanssa (case 1 vuelä)
#katsotaan kanssa miten tuo uusi versio pelittää
sudo ${d}/clouds.sh 0
csleep 5

${scm} a-wx ~/Desktop/minimize/*.sh
${scm} a-wx $0 #kerta tulisi riittää

#if [ ${debug} -eq 1 ] ; then 
#	${scm} a-wx ${d}/pkgs*
#	for f in $(find ~/Desktop/minimize/ -name '*.txt') ; do ${scm} a-wx ${f} ; done
#	for f in $(find ~/Desktop/minimize/ -name '*.conf') ; do ${scm} a-wx ${f} ; done
#	for f in $(find ~/Desktop/minimize/ -name 'conf') ; do ${scm} a-wx ${f} ; done
#fi
#
#csleep 6

#===================================================PART 4(final)==========================================================
#tulisi olla taas tables toiminnassa tässä kohtaa skriptiä

if [ ${mode} -eq 2 ] ; then
	echo "time to ${sifu} ${iface} or whåtever"
	csleep 5
	${whack} xfce* 
 	exit 
fi

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
	${whack} xfce* 
fi