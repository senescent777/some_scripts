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

n=$(whoami)
#==================================PART 1============================================================

if [ $# -gt 0 ] ; then
	for opt in $@ ; do parse_opts_1 $opt ; done
fi

check_params 
[ ${enforce} -eq 1 ] && pre_enforce ${n}
enforce_access ${n} 

dqb "man date;man hwclock; sudo date --set | sudo hwclock --set --date if necessary" 
part1 ${distro} 
[ ${mode} -eq 0 ] && exit

for s in avahi-daemon bluetooth cups cups-browsed exim4 nfs-common network-manager ntp mdadm saned rpcbind lm-sensors dnsmasq stubby ; do
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
sleep 3
#exit

#K01avahi-jutut sopivaan kohtaan?

#===================================================PART 2===================================
${sharpy} libblu* network* libcupsfilters* libgphoto* libopts25
${sharpy} avahi* blu* cups* exim*
${sharpy} rpc* nfs* 
${sharpy} modem* wireless* wpa* iw lm-sensors
#paketin mdadm poisto siirretty tdstoon pt2.sh päiväyksellä 220624

${smr} -rf /run/live/medium/live/initrd.img*
sleep 3

${ip6tr} /etc/iptables/rules.v6
${iptr} /etc/iptables/${tblz4}

csleep 5
${smr} -rf /run/live/medium/live/initrd.img*
sleep 3

if [ ${debug} -eq 1 ] ; then
	${snt} -tulpan
	sleep 5
fi #

#===================================================PART 3===========================================================
dqb "INSTALLING NEW PACKAGES IN 10 SECS"
csleep 3

echo "DO NOT ANSWER \"Yes\" TO A QUESTION ABOUT IPTABLES";sleep 2
echo "... FOR POSITIVE ANSWER MAY BREAK THINGS";sleep 5

pre_part3 ${d} 
pr4 ${d}
part3 ${d} 

ecfx

csleep 5
if [ -x ~/Desktop/minimize/profs.sh ] ; then
	[ -x ~/Desktop/minimize/middleware.sh ] && . ~/Desktop/minimize/middleware.sh	
	. ~/Desktop/minimize/profs.sh
	copyprof ${n} someparam
fi

if [ ${mode} -eq 1 ] ; then
	vommon
fi

${asy}
sudo ${d}/clouds.sh 0
sleep 5

##===================================================PART 4(final)==========================================================
##tulisi olla taas tables toiminnassa tässä kohtaa skriptiä
#${odio} /etc/init.d/dnsmasq restart
#sudo ${d}/clouds.sh 1
#ns2 stubby
#ns4 stubby
#
#if [ ${debug} -eq 1 ] ; then 
#	${snt} -tulpan
#	sleep 5
#	pgrep stubby*
#	sleep 5
#fi
#
#echo "time to ${sifu} ${iface} or whåtever"
#echo "P.S. if stubby dies, resurrect it with \"restart_stubby.desktop\" "
