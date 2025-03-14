#!/bin/bash
d=$(dirname $0)
[ -s ${d}/conf ] && . ${d}/conf
. ~/Desktop/minimize/common_lib.sh

if [ -s ${d}/lib.sh ] ; then
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

if [ $# -gt 0 ] ; then
	for opt in $@ ; do parse_opts_1 $opt ; done
fi

check_params 
[ ${enforce} -eq 1 ] && pre_enforce
enforce_access 

dqb "man date;man hwclock; sudo date --set | sudo hwclock --set --date if necessary" 
part1
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
ecfx
csleep 5


#TODO:testaus
if [ ${mode} -eq 1 ] ; then
	vommon
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
	[ -x ~/Desktop/minimize/middleware.sh ] && . ~/Desktop/minimize/middleware.sh 
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