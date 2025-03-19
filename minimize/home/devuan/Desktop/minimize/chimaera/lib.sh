#=========================PART 0 ENDS HERE=================================================================
function pr4() {
	dqb "pr4 (${1})"
	${NKVD} ${1}/stubby*
	${NKVD} ${1}/libgetdns*

	#uutena
	${NKVD} ${1}/dnsmasq*
	dqb "d0n3"
}

#HUOM.170325:git näköjään asentuu pr4((), pre3() - vaiheiden aikana vaikka vähän nalkutusta tuleekin(josko nalkutuksen poistaisi)

function pre_part3() {
	dqb "pre_part3( ${1})"
	${sdi} ${1}/dns-root-data*.deb
	${NKVD} ${1}/dns-root-data*.deb

	#uutena, pois jos qsee	
	${sdi} ${1}/perl-modules-*.deb
	${NKVD} ${1}/perl-modules-*.deb
}

function clouds_case0() {
	dqb  "lib.case0 "

	${slinky} /etc/resolv.conf.OLD /etc/resolv.conf
	${slinky} /etc/dhcp/dhclient.conf.OLD /etc/dhcp/dhclient.conf
	${spc} /sbin/dhclient-script.OLD /sbin/dhclient-script

	#samaan tapaan voisi menneä daeDALuksenkin kanssa? s.e. jos a-f - ketjut olemassa ni muutetaan vain dns-säännlt, muussa tapaux pakotetaan rules.v4
	${ipt} -A INPUT -p udp -m udp --sport 53 -j b 
	${ipt} -A OUTPUT -p udp -m udp --dport 53 -j e
	for s in $(grep -v '#' /etc/resolv.conf.OLD | grep names | grep -v 127. | awk '{print $2}') ; do dda_snd ${s} ; done	

	csleep 1
	dqb "... d0n3"	
}

function clouds_case1() {
	echo "lib.case1 (TODO)"
#		${slinky} /etc/resolv.conf.new /etc/resolv.conf
#		${slinky} /etc/dhcp/dhclient.conf.new /etc/dhcp/dhclient.conf
#		${spc} /sbin/dhclient-script.new /sbin/dhclient-script
#		
#		${ipt} -A INPUT -p tcp -m tcp --sport 853 -j b
#		${ipt} -A OUTPUT -p tcp -m tcp --dport 853 -j e
#		for s in $(grep -v '#' /home/stubby/.stubby.yml | grep address_data | cut -d ':' -f 2) ; do tod_dda ${s} ; done

	csleep 1
	dqb "... d0n3"	
}

dqb "BIL-UR-SAG"
check_binaries ${distro}
check_binaries2 #${distro}
dqb "UMULAMAHRI"
