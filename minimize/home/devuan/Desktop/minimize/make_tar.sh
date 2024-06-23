#!/bin/bash
#
#iface=eth0 #grep /e/n/i ?
#debug=0
#the_ar=0
#tblz4=rules.v4 #linkki osoittanee oikeaan tdstoon
#install=0 
#tgtfile=out.tar
#enforce=1 #kokeeksi näin
#no_mas=0
#pkgdir=/var/cache/apt/archives
#
#odus=$(which sudo)
#[ -x ${odus} ] || exit 666
##exit
#
#ipt=$(sudo which iptables)
#ip6t=$(sudo which ip6tables)
#iptr=$(sudo which iptables-restore)
#ip6tr=$(sudo which ip6tables-restore)
#sco=$(sudo which chown)
#scm=$(sudo which chmod)
#whack=$(sudo which pkill)
#sag=$(sudo which apt-get)
#sa=$(sudo which apt)
#sip=$(sudo which ip)
#snt=$(sudo which netstat)
#sdi=$(sudo which dpkg)
#
#function check_binaries() {
#	dqb "ch3ck_b1nar135()"
#	dqb "sudo= ${odus} "
#
#	[ -x ${ipt} ] || exit 5
#	[ -x ${ip6t} ] || exit 5
#	[ -x ${iptr} ] || exit 5
#	[ -x ${ip6tr} ] || exit 5
#	[ -x ${sco} ] || exit 5
#	[ -x ${scm} ] || exit 5
#	[ -x ${whack} ] || exit 5
#	[ -x ${sag} ] || exit 5
#	[ -x ${sa} ] || exit 5
#	[ -x ${sip} ] || exit 5
#	[ -x ${snt} ] || exit 5
#	[ -x ${sdi} ] || exit 5
#	
#	dqb "b1nar135 0k" 
#	csleep 3
#
#	ipt="sudo ${ipt} "
#	ip6t="sudo ${ip6t} "
#	iptr="sudo ${iptr} "
#	ip6tr="sudo ${ip6tr} "
#	whack="sudo ${whack} --signal 9 "
#	snt="sudo ${snt} "
#	sharpy="sudo ${sag} remove --purge --yes "
#	sdi="sudo ${sdi} -i "
#	shary="sudo ${sag} --no-install-recommends reinstall "
#	sco="sudo ${sco} "
#	scm="sudo ${scm} "
#	sip="sudo ${sip} "
#	sa="sudo ${sa} "
#}
#
#function dqb() {
#	[ ${debug} -eq 1 ] && echo ${1}
#}
#
#function csleep() {
#	[ ${debug} -eq 1 ] && sleep ${1}
#}
#
##TODO:erilliseen kirjastoon nuo deltävät rivit
##VAIH:erilliseksi skriptiksi
##VAIH:verkkoyhteyden aktivointi mukaan kanssa
function make_tar() {
#	echo "sudo /sbin/ifup ${iface} | sudo /sbin/ifup -a" #if there is > 1 interfaces...
	sudo /sbin/ifup ${iface}	
	[ $? -eq 0 ] || sudo /sbin/ifup -a
	[ $? -eq 0 ] || ${sip} link set ${iface} up
	[ $? -eq 0 ] || echo "PROBLEMS WITH NETWORK CONNECTION"

	${sag} update
	${shary} libip4tc2 libip6tc2 libxtables12 netbase libmnl0 libnetfilter-conntrack3 libnfnetlink0 libnftnl11 iptables
	sudo rm -rf /run/live/medium/live/initrd.img*

	${shary} init-system-helpers netfilter-persistent iptables-persistent
	sudo rm -rf /run/live/medium/live/initrd.img*
	${shary} python3-ntp ntpsec-ntpdate

	${shary} dnsmasq-base runit-helper
	sudo rm -rf /run/live/medium/live/initrd.img*

	${shary} libgetdns10 libbsd0 libidn2-0 libssl1.1 libunbound8 libyaml-0-2 stubby
	sudo rm -rf /run/live/medium/live/initrd.img*

	#some kind of retrovirus
	sudo tar -cvpf ${tgtfile} /var/cache/apt/archives/*.deb ~/Desktop/minimize /etc/iptables /etc/dnsmasq* /etc/stubby* /etc/network/interfaces* 
	sudo tar -rvpf ${tgtfile} /etc/sudoers.d/user_shutdown /home/stubby
	sudo tar -rvpf ${tgtfile} /etc/init.d/{stubby,networking,dnsmasq,netfilter-persistent}
	sudo tar -rvpf ${tgtfile} /etc/rcS.d/{S14netfilter-persistent,S15networking}
	sudo tar -rvpf ${tgtfile} /etc/rc2.d/{K01avahi-daemon,K01cups,K01cups-browsed,S03dnsmasq,S03stubby}
	sudo tar -rvpf ${tgtfile} /etc/rc3.d/{K01avahi-daemon,K01cups,K01cups-browsed,S03dnsmasq,S03stubby}	

	#add some stuff from ghub
	${shary} git
	local p
	local q
	p=$(pwd)
	q=$(mktemp -d)
	cd $q

	#olisi kiva jos ei tarvitsisi koko projektia vetää, wget -r tjsp
	git clone https://github.com/senescent777/project.git
	cd project

	sudo cp /etc/dhcp/dhclient.conf ./etc/dhcp/dhclient.conf.OLD
	sudo cp /etc/resolv.conf ./etc/resolv.conf.OLD
	sudo cp /sbin/dhclient-script ./sbin/dhclient-script.OLD	

	${sco} -R root:root ./etc; ${scm} -R a-w ./etc
	${sco} -R root:root ./sbin; ${scm} -R a-w ./sbin
	sudo tar -rvpf ${tgtfile} ./etc ./sbin
	cd $p
	
	sudo tar -tf  ${tgtfile} > MANIFEST
	sudo tar -rvpf ${tgtfile} ${p}/MANIFEST
	
	sudo /sbin/ifdown ${iface}
	[ $? -eq 0 ] || ${sip} link set ${iface} down
	[ $? -eq 0 ] || sudo /sbin/ifdown -a
	[ $? -eq 0 ] || echo "PROBLEMS WITH NETWORK CONNECTION"
	[ ${debug} -eq 1 ] && /sbin/ifconfig;sleep 5 
}