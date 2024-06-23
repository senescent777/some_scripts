#!/bin/bash
tgtfile=out.tar #jos siirtäisi -> make_tar.sh
. ./lib
check_binaries
check_binaries2

function make_tar() {
	dqb "${sifu} ${iface}"

	${sip} link set ${iface} up
	${sifu} ${iface}	
	${sifu} -a
	
	[ $? -eq 0 ] || echo "PROBLEMS WITH NETWORK CONNECTION"
	csleep 5

	${sag_u} 
	${shary} libip4tc2 libip6tc2 libxtables12 netbase libmnl0 libnetfilter-conntrack3 libnfnetlink0 libnftnl11 iptables
	sudo rm -rf /run/live/medium/live/initrd.img*
	csleep 5

	${shary} init-system-helpers netfilter-persistent iptables-persistent
	sudo rm -rf /run/live/medium/live/initrd.img*
	${shary} python3-ntp ntpsec-ntpdate
	csleep 5

	${shary} dnsmasq-base runit-helper
	sudo rm -rf /run/live/medium/live/initrd.img*

	${shary} libgetdns10 libbsd0 libidn2-0 libssl1.1 libunbound8 libyaml-0-2 stubby
	sudo rm -rf /run/live/medium/live/initrd.img*
	csleep 5

	#some kind of retrovirus
	#TODO:find /etc -type f -name 'stubby*' | -name 'dns*'
	sudo tar -cvpf ${tgtfile} /var/cache/apt/archives/*.deb ~/Desktop/minimize /etc/iptables /etc/dnsmasq* /etc/stubby* /etc/network/interfaces* 
	sudo tar -rvpf ${tgtfile} /etc/sudoers.d/user_shutdown /home/stubby
	sudo tar -rvpf ${tgtfile} /etc/init.d/{stubby,networking,dnsmasq,netfilter-persistent}
	sudo tar -rvpf ${tgtfile} /etc/rcS.d/{S14netfilter-persistent,S15networking}
	sudo tar -rvpf ${tgtfile} /etc/rc2.d/{K01avahi-daemon,K01cups,K01cups-browsed,S03dnsmasq,S03stubby}
	sudo tar -rvpf ${tgtfile} /etc/rc3.d/{K01avahi-daemon,K01cups,K01cups-browsed,S03dnsmasq,S03stubby}	
	csleep 5

	#add some stuff from ghub
	${shary} git
	csleep 5
	#exit

	local p
	local q
	p=$(pwd)
	q=$(mktemp -d)
	dqb "cd ${q}"
	cd ${q}
	csleep 6

	#olisi kiva jos ei tarvitsisi koko projektia vetää, wget -r tjsp
	git clone https://github.com/senescent777/project.git
	csleep 5
	cd project
	[ ${debug} -eq 1 ] && ls -las;sleep 10

	sudo cp /etc/dhcp/dhclient.conf ./etc/dhcp/dhclient.conf.OLD
	sudo cp /etc/resolv.conf ./etc/resolv.conf.OLD
	sudo cp /sbin/dhclient-script ./sbin/dhclient-script.OLD	

	${sco} -R root:root ./etc; ${scm} -R a-w ./etc
	${sco} -R root:root ./sbin; ${scm} -R a-w ./sbin
	sudo tar -rvpf ${tgtfile} ./etc ./sbin
	cd ${p}
	
	sudo tar -tf  ${tgtfile} > MANIFEST
	sudo tar -rvpf ${tgtfile} ${p}/MANIFEST
	
	${sifd} ${iface}	
	${sifd} -a
	${sip} link set ${iface} down

	[ $? -eq 0 ] || echo "PROBLEMS WITH NETWORK CONNECTION"
	[ ${debug} -eq 1 ] && /sbin/ifconfig;sleep 5 
}

#TODO:parse_opts(), main()
make_tar