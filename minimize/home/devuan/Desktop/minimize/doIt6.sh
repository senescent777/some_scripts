#!/bin/bash

#=================================================PART 0=====================================
iface=eth0 #grep /e/n/i ?
debug=0
the_ar=0
tblz4=rules.v4 #linkki osoittanee oikeaan tdstoon
install=0 
tgtfile=out.tar
enforce=1 #kokeeksi näin
no_mas=0
pkgdir=/var/cache/apt/archives

odus=$(which sudo)
[ -x ${odus} ] || exit 666
#exit

ipt=$(sudo which iptables)
ip6t=$(sudo which ip6tables)
iptr=$(sudo which iptables-restore)
ip6tr=$(sudo which ip6tables-restore)
sco=$(sudo which chown)
scm=$(sudo which chmod)
whack=$(sudo which pkill)
sag=$(sudo which apt-get)
sa=$(sudo which apt)
sip=$(sudo which ip)
snt=$(sudo which netstat)
sdi=$(sudo which dpkg)
#TODO:ifu ja ifd

function parse_opts_2() {
	case "${1}" in
		-o )
			tgtfile=${2}
		;;
	esac
}

function parse_opts_1() {
	case "${1}" in
		-v|--v)
			debug=1
		;;
		--ar)
			the_ar=1
		;;
		--install)
			install=1
		;;
		--no)
			no_mas=1
		;;
	esac
}

function dqb() {
	[ ${debug} -eq 1 ] && echo ${1}
}

function csleep() {
	[ ${debug} -eq 1 ] && sleep ${1}
}

function check_params() {
	case ${the_ar} in
		0|1)
			dqb "the_ar ok (${the_ar})"
		;;
		*)
			dqb "P.V.H.H"
			exit 1
		;;
	esac

	case ${install} in
		0|1)
			dqb "install = ${install} "
		;;
		*)
			dqb "P.V.H.H"
			exit 2
		;;
	esac

	if [ ${install} -eq 1 ] ; then
		[ -s ${tgtfile} ] && echo "${tgtfile} alr3ady 3x1st5"
		local d
	
		d=$(dirname ${tgtfile})
		[ -d ${d} ] || echo "no such dir as ${d}"	
	
		if [ ${the_ar} -eq 1 ] ; then 
			dqb "make_tar may not work"
			sleep 3
		fi
	fi

	case ${no_mas} in
		0|1)
			dqb " ok ${no_mas}"
		;;
		*)
			dqb "te quiero puta"
			exit 3
		;;
	esac

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

function check_binaries() {
	dqb "ch3ck_b1nar135()"
	dqb "sudo= ${odus} "

	[ -x ${ipt} ] || exit 5
	[ -x ${ip6t} ] || exit 5
	[ -x ${iptr} ] || exit 5
	[ -x ${ip6tr} ] || exit 5
	[ -x ${sco} ] || exit 5
	[ -x ${scm} ] || exit 5
	[ -x ${whack} ] || exit 5
	[ -x ${sag} ] || exit 5
	[ -x ${sa} ] || exit 5
	[ -x ${sip} ] || exit 5
	[ -x ${snt} ] || exit 5
	[ -x ${sdi} ] || exit 5
	
	dqb "b1nar135 0k" 
	csleep 3

	ipt="sudo ${ipt} "
	ip6t="sudo ${ip6t} "
	iptr="sudo ${iptr} "
	ip6tr="sudo ${ip6tr} "
	whack="sudo ${whack} --signal 9 "
	snt="sudo ${snt} "
	sharpy="sudo ${sag} remove --purge --yes "
	sdi="sudo ${sdi} -i "
	shary="sudo ${sag} --no-install-recommends reinstall "
	sco="sudo ${sco} "
	scm="sudo ${scm} "
	sip="sudo ${sip} "
	sa="sudo ${sa} "
}

#VAIH:mangle_s() tähän ja käyttöön? /e/sudoers.d/live kanssa mäkeen?
#HUOM. _s - kutsun oltava ennenq check_binaries() kutsutaaj, tjsp.
mangle_s() {
	if [ -s ${1} ] ; then 
		#chattr -ui ${1}
		[ ${debug} -eq 1 ] && echo "W3NGL3 $1";sleep 5
		chmod 0555 ${1}
		chown root:root  ${1} #uutena tämä
		#chattr +ui ${1}

		echo -n "devuan localhost=NOPASSWD: sha256:" >> /etc/sudoers.d/meshuggah
		local s
		s=$(sha256sum ${1})
		echo ${s} >> /etc/sudoers.d/meshuggah
	fi
}

mangle2() {
	if [ -f ${1} ] ; then #onkohan tää testi hyvä idea?
		dqb "MANGLED $1";sleep 1
		${scm} o-rwx ${1}
		${sco} root:root ${1}
		csleep 1
	fi
}

function enforce_access() {
	dqb "3nf0rc3_acc355()"

	#ch-jutut siltä varalta että tar sössii oikeudet tai omistajat
	${sco} root:root /home
	${scm} 0755 /home
	${sco} -R devuan:devuan /home/devuan/ #~
	${scm} -R 0755 /home/devuan/Desktop/minimize #~/Desktop/minimize
	${sco} -R 101:65534 /home/stubby/

	if [ ${enforce} -eq 1 ] ; then #käykähän jatkossa turhaksi tämä if-blokki?
		echo "changing /sbin , /etc and /var 4 real"
		${sco} -R root:root /sbin
		${scm} -R 0755 /sbin

		#this part inspired by:https://raw.githubusercontent.com/senescent777/project/main/opt/bin/part0.sh
		${sco} -R root:root /etc
		${scm} -R 0755 /etc
		local f

		#erillinen mangle2 /e/s.d tarpeellinen? vissiin juuri sudoers.d/* takia
		for f in $(find /etc/sudoers.d/ -type f) ; do mangle2 ${f} ; done

		for f in $(find /etc -name 'sudo*' -type f | grep -v log) ; do 
			mangle2 ${f}
			csleep 5
		done

		#sudoersin sisältöä voisi kai tiukentaa kanssa
		${sco} -R root:root /var
		${scm} -R go-w /var

		${scm} 0755 /
		${sco} root:root /
	fi
	
	if [ -s /etc/resolv.conf.new ] && [ -s /etc/resolv.conf.OLD ] ; then
		sudo rm /etc/resolv.conf
	fi

	[ -s /sbin/dclient-script.OLD ] || sudo cp /sbin/dhclient-script /sbin/dhclient-script.OLD
}

#kts. https://github.com/senescent777/some_scripts/blob/main/lib/d227D33.sh.export liittyen
add_doT() {
	${ipt} -A b -p tcp --sport 853 -s ${1} -j c
	${ipt} -A e -p tcp --dport 853 -d ${1} -j f
}

add_snd() {
	${ipt} -A b -p udp -m udp -s ${1} --sport 53 -j ACCEPT 
	${ipt} -A e -p udp -m udp -d ${1} --dport 53 -j ACCEPT 
}

#mallia https://github.com/senescent777/project/blob/main/opt/bin/install.sh , https://github.com/senescent777/project/blob/main/opt/bin/install.sh , https://github.com/senescent777/project/blob/main/home/devuan/Dpckcer/buildr/source/scripts/part4.sh 
clouds() {
	[ ${debug} -eq 1 ] && echo "coluds(${1})"

	sudo rm /etc/resolv.conf
	sudo rm /etc/dhcp/dhclient.conf
	sudo rm /sbin/dhclient-script

	#tässä oikea paikka tables-muutoksille vai ei?
	${ipt} -F b;${ipt} -F e
	${ipt} -D INPUT 5; ${ipt} -D OUTPUT 6
	local s

	case ${1} in 
		0)
			sudo ln -s /etc/resolv.conf.OLD /etc/resolv.conf
			sudo ln -s /etc/dhcp/dhclient.conf.OLD /etc/dhcp/dhclient.conf
			sudo cp /sbin/dhclient-script.OLD /sbin/dhclient-script

			${ipt} -A INPUT -p udp -m udp --sport 53 -j b 
			${ipt} -A OUTPUT -p udp -m udp --dport 53 -j e
			for s in $(grep -v '#' /etc/resolv.conf.OLD | grep names | grep -v 127. | awk '{print $2}') ; do add_snd ${s} ; done	
		;;
		1)
			sudo ln -s /etc/resolv.conf.new /etc/resolv.conf
			sudo ln -s /etc/dhcp/dhclient.conf.new /etc/dhcp/dhclient.conf
			sudo cp /sbin/dhclient-script.new /sbin/dhclient-script
		
			${ipt} -A INPUT -p tcp -m tcp --sport 853 -j b
			${ipt} -A OUTPUT -p tcp -m tcp --dport 853 -j e
			for s in $(grep -v '#' /home/stubby/.stubby.yml | grep address_data | cut -d ':' -f 2) ; do add_doT ${s} ; done
		;;
	esac

	${scm} 0444 /etc/resolv.conf*
	${sco} root:root /etc/resolv.conf*

	${scm} 0444 /etc/dhcp/dhclient*
	${sco} root:root /etc/dhcp/dhclient*
	${scm} 0755 /etc/dhcp

	${scm} 0555 /sbin/dhclient*
	${sco} root:root /sbin/dhclient*
	${scm} 0755 /sbin

	${sco} -R root:root /etc/iptables
	${scm} 0400 /etc/iptables/*
	${scm} 0750 /etc/iptables
 
	sleep 2

	if [ ${debug} -eq 1 ] ; then
		${ipt} -L  #
		${ip6t} -L #
		sleep 5
	fi #
}

function make_tar() {
	echo "run ./make_tar.sh"
}

#HUOM.220624:stubbyn asentumisen ja käynnistymisen kannalta sleep saattaa olla tarpeen
ns2() {
	dqb "ns2( ${1} )"
	${scm} u+w /home

	sudo /usr/sbin/userdel ${1}
	sleep 3

	sudo adduser --system ${1}
	${scm} go-w /home

	[ ${debug} -eq 1 ]  && ls -las /home
	sleep 7
}

ns4() {
	dqb "ns4( ${1} )"

	${scm} u+w /run
	sudo touch /run/${1}.pid
	${scm} 0600 /run/${1}.pid
	${sco} $1:65534 /run/${1}.pid
	${scm} u-w /run

	sleep 5
	${whack} ${1}*
	sleep 5

	dqb "starting ${1} in 5 secs"

	sleep 5
	sudo -u ${1} ${1} -g
	echo $?
	sleep 5
}

#==================================PART 1============================================================

if [ $# -gt 0 ] ; then
	parse_opts_2 ${1} ${2}
	for opt in $@ ; do parse_opts_1 $opt ; done
fi

#TODO:näiltä main part1 loppuun funktioksi ja "kirjastoon"
check_params
check_binaries
enforce_access

dqb "man date;man hwclock; sudo date --set | sudo hwclock --set --date if necessary" 
#jos jokin näistä kolmesta hoitaisi homman...
sudo /sbin/ifdown ${iface}
sudo /sbin/ifdown -a
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

#TODO:autoremove:n ehdollisuus pois jatkossa?
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
dqb "INSTALLING NEW PACKAGES FROM ${pkgdir} IN 3 SECS"
csleep 3
echo "DO NOT ANSWER \"Yes\"  TO A QUESTION ABOUT IPTABLES";sleep 1
echo "... FOR POSITIVE ANSWER MAY BREAK THINGS";sleep 6

${sdi} ${pkgdir}/dns-root-data*.deb 
[ $? -eq 0 ] && sudo rm -rf ${pkgdir}/dns-root-data*.deb

#TODO:pari seur. blokkia ennen no_mas, fktioksi myös
${sdi} /var/cache/apt/archives/lib*.deb
[ $? -eq  0 ] && sudo rm -rf ${pkgdir}/lib*.deb

#HUOM. ei kannattane vastata myöntävästi tallennus-kysymykseen?
${sdi} ${pkgdir}/*.deb
[ $? -eq 0 ] && sudo rm -rf ${pkgdir}/*.deb
csleep 2

#missäköhän kohtaa kuuluisi tmän olla?
if [ ${no_mas} -eq 1 ] ; then
	dqb "no mas senor"
	exit 	
fi

[ ${the_ar} -eq 1 ] || ${sa} autoremove --yes

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

echo "sudo /sbin/ifup ${iface} or whåtever"
echo "P.S. if stubby dies, resurrect it with \"restart_stubby.desktop\" "
