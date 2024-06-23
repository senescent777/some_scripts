#!/bin/bash
. ./lib
#==================================PART 1============================================================

if [ $# -gt 0 ] ; then
	parse_opts_2 ${1} ${2}
	for opt in $@ ; do parse_opts_1 $opt ; done
fi

#VAIH:part1 käyttöön?
check_params
check_binaries
[ ${enforce} -eq 1 ] && pre_enforce
check_binaries2
enforce_access

dqb "man date;man hwclock; sudo date --set | sudo hwclock --set --date if necessary" 

#jos jokin näistä kolmesta hoitaisi homman...
${sifd} ${iface}
${sifd} -a
${sip} link set ${iface} down
[ $? -eq 0 ] || echo "PROBLEMS WITH NETWORK CONNECTION"
[ ${debug} -eq 1 ] && /sbin/ifconfig;sleep 5 

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

#exit

for s in avahi-daemon bluetooth cups cups-browsed exim4 nfs-common network-manager ntp mdadm saned rpcbind lm-sensors dnsmasq stubby ; do
	sudo /etc/init.d/${s} stop
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

#===================================================PART 2===================================
${sharpy} libblu* network* libcupsfilters* libgphoto* libopts25
${sharpy} avahi* blu* cups* exim*
${sharpy} rpc* nfs* 
${sharpy} ntp* sntp*
${sharpy} modem* wireless* wpa* iw lm-sensors
#paketin mdadm poisto siirretty tdstoon pt2.sh päiväyksellä 220624

sudo rm -rf /run/live/medium/live/initrd.img*
sleep 3

${ip6tr} /etc/iptables/rules.v6
${iptr} /etc/iptables/${tblz4}
clouds 0

#autoremove:n ehdollisuus pois jatkossa?
if [ ${the_ar} -eq 1 ] ; then 
	dqb "autoremove in 5 secs"
	${sa} autoremove --yes
else
	dqb "autoremove postponed"
fi

csleep 5
sudo rm -rf /run/live/medium/live/initrd.img*
sleep 3

if [ ${debug} -eq 1 ] ; then
	${snt} -tulpan
	sleep 5
fi #

if [ ${install} -eq 1 ] ; then
	#HUOM. m_t tässä kohtaa siltä varalta errä squbby ei toimi
	make_tar
	exit
else
	dqb "not fetching pkgs"
fi


#===================================================PART 3===========================================================
dqb "INSTALLING NEW PACKAGES FROM ${pkgdir} IN 10 SECS"
csleep 3
echo "DO NOT ANSWER \"Yes\"  TO A QUESTION ABOUT IPTABLES";sleep 2
echo "... FOR POSITIVE ANSWER MAY BREAK THINGS";sleep 5

${sdi} ${pkgdir}/dns-root-data*.deb 
[ $? -eq 0 ] && sudo rm -rf ${pkgdir}/dns-root-data*.deb

part3

#missäköhän kohtaa kuuluisi tmän olla?
if [ ${no_mas} -eq 1 ] ; then
	dqb "no mas senor"
	exit 	
fi

[ ${the_ar} -eq 1 ] || ${sa} autoremove --yes
#exit

#===================================================PART 4(final)==========================================================
#tulisi olla taas tables toiminnassa tässä kohtaa skriptiä
sudo /etc/init.d/dnsmasq restart
clouds 1
ns2 stubby
ns4 stubby

if [ ${debug} -eq 1 ] ; then 
	${snt} -tulpan
	sleep 5
	pgrep stubby*
	sleep 5
fi

echo "${sifu} ${iface} or whåtever"
echo "P.S. if stubby dies, resurrect it with \"restart_stubby.desktop\" "
