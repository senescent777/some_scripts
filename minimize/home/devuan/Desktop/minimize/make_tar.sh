#!/bin/bash
. ./lib

function make_tar() {
#	echo "sudo /sbin/ifup ${iface} | sudo /sbin/ifup -a" #if there is > 1 interfaces...
	${sifu} ${iface}	
	${sifu} -a
	${sip} link set ${iface} up
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
	
	${sifd} ${iface}
	${sip} link set ${iface} down
	${sifd} -a
	[ $? -eq 0 ] || echo "PROBLEMS WITH NETWORK CONNECTION"
	[ ${debug} -eq 1 ] && /sbin/ifconfig;sleep 5 
}