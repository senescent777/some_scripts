#!/bin/bash
d=$(dirname $0)
mode=2
[ -s ${d}/conf ] && . ${d}/conf
. ~/Desktop/minimize/common_lib.sh

if [ -s ${d}/lib.sh ] ; then
	. ${d}/lib.sh
else
	echo "TO CONTINUE FURTHER IS POINTLESS, ESSENTIAL FILES MISSING"
	exit 111	
fi

n=$(whoami)
#TODO:->common_lib
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

if [ $# -gt 0 ] ; then
	for opt in $@ ; do parse_opts_1 $opt ; done
fi

check_params 
[ ${enforce} -eq 1 ] && pre_enforce ${n} ${distro}
enforce_access ${n}

dqb "man date;man hwclock; sudo date --set | sudo hwclock --set --date if necessary" 
part1 ${distro} 
#HUOM.190325:part_1_5sessa oli bugi, u+w ei vaan riitä
[ ${debug} -eq 1 ] && less /etc/apt/sources.list
[ ${mode} -eq 0 ] && exit

#HUOM.261224: ntpsec uutena
for s in avahi-daemon bluetooth cups cups-browsed exim4 nfs-common network-manager ntp mdadm saned rpcbind lm-sensors dnsmasq stubby ntpsec ; do
	${odio} /etc/init.d/${s} stop
	csleep 1
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
csleep 5
${odio} /etc/init.d/ntpsec stop
#K01avahi-jutut sopivaan kohtaan?

#===================================================PART 2===================================
ecfx
csleep 5

if [ ${mode} -eq 1 ] ; then
	vommon
fi

if [ ${removepkgs} -eq 1 ] ; then
	${sharpy} libblu* network* libcupsfilters* libgphoto* 
	# libopts25 ei tömmöistä daedaluksessa

	#HUOM.200325:eximin läsnäolo aiheuyiu removepkgs-mjan arvosrta
	${sharpy} avahi* blu* cups* 
	${sharpy} exim*
	${lftr}
	csleep 3

#	${sharpy} exim*
#	${lftr}
#	csleep 3
#	
#	${sharpy} rpc* nfs* 
#	csleep 3
#	${sharpy} rpc* 
#	csleep 4
#	${sharpy} nfs* 
#	csleep 4

	${sharpy} modem* wireless* wpa*
	${sharpy} iw lm-sensors

	${sharpy} ntp*
	${lftr}
	csleep 3
	
	${sharpy} po* pkexec
	${lftr}
	csleep 3
fi

if [ y"${ipt}" != "y" ] ; then 
	${ip6tr} /etc/iptables/rules.v6
	${iptr} /etc/iptables/${tblz4} #voisi olla rules.v4 jatkossa, ei kikkaulua
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
#HUOM.190325: joskohan nyt chimerankin kanssa loppuisi nalkutukset paketeista

echo $?
csleep 3
${ip6tr} /etc/iptables/rules.v6

#VAIH:se ffox-profiili-asia (mallia sieltä ghubin toisesta hmistosta)
if [ -x ~/Desktop/minimize/profs.sh ] ; then
	[ -x ~/Desktop/minimize/middleware.sh ] && . ~/Desktop/minimize/middleware.sh 
	. ~/Desktop/minimize/profs.sh
	copyprof ${n} someparam
fi

${asy}
dqb "GR1DN BELIALAS KYE"

#sudo ${d}/clouds.sh 0 #jatqs se yleismepi
#HUOM. TOIMIIKO TUO KOMENTO TUOSSA ALLA VAI EI ??? (olikohan resolv.conf:ista kiinni)
~/Desktop/minimize/clouds2 ${dnsm} ${distro}
${sipt} -L
csleep 6

${scm} a-wx ~/Desktop/minimize/*.sh
${scm} a-wx $0 #oikeastaan kerta-ajo tulisi riittää tai toisaalta daedaluksen versiossa ominaisuuksia

#===================================================PART 4(final)==========================================================

if [ ${mode} -eq 2 ] ; then
	echo "time to ${sifu} ${iface} or whåtever"
	csleep 5
	${whack} xfce4-session
 	exit 
fi

#070235: heittääkö pihalle xfce:stä tuossa yllä vai ei? vissiin pitää muuttaa parametreja
#sudo ${d}/clouds.sh 1
~/Desktop/minimize/clouds2 ${dnsm} ${distro}

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