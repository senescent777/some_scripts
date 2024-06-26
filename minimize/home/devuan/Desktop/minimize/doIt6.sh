#!/bin/bash

iface=eth0 
enforce=1
debug=0
pkgdir=/var/cache/apt/archives
tblz4=rules.v4 #linkki osoittanee oikeaan tdstoon
mode=2

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

. ./lib

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
#HUOM.2. ei niitä {sco}-juttuja ao. fktioon
function mangle_s() {
	local tgt

	if [ y"${2}" == "y" ] ; then
		tgt=/etc/sudoers.d/meshuggah
	else
		tgt=/etc/sudoers.d/${2}
	fi

	if [ -s ${1} ] ; then 
		#chattr -ui ${1} #chattr ei välttämättä toimi overlay'n tai squashfs'n kanssa
		csleep 1
		
		sudo chmod 0555 ${1}
		sudo chown root:root ${1} 
		#chattr +ui ${1}

		csleep 1
		local s
		local n

		n=$(whoami) #olisi myös %users...
		s=$(sha256sum ${1})
		sudo echo "${n} localhost=NOPASSWD: sha256: ${s} " >> ${tgt}
		sleep 1
	else
		dqb "no sucg file as ${1} "
	fi
}

function pre_enforce() {
	#HUOM.230624 /sbin/dhclient* joutuisi hoitamaan toisella tavalla q mangle_s	
	if [ -f /etc/sudoers.d/meshuggah ] ; then
		dqb "a51a kun05a"
 	else
		sudo touch /etc/sudoers.d/meshuggah
		#sudo chown 1000:1000  /etc/sudoers.d/meshuggah
		sudo chmod a+w /etc/sudoers.d/meshuggah	

		local f 
		for f in ${CB_LIST1} ; do mangle_s ${f} ; done
		for f in /etc/init.d/stubby /opt/bin/clouds.sh /sbin/halt /sbin/reboot ; do mangle_s ${f} ; done

		sudo chmod a-w /etc/sudoers.d/meshuggah	
		#HUOM.250624:pitäisi kai pakottaa ulosheitto xfce:stä jotta sudo-muutokset tulisivat voimaan?
	fi

	sudo chmod 0440 /etc/sudoers.d/* #ei missään nimessä tähän:-R
	#sudo chmod 0750 /etc/sudoers.d #uskaltaakohan? ehkä ei
	sudo chown -R root:root /etc/sudoers.d
}

function enforce_access() {
	dqb "3nf0rc3_acc355()"

	#ch-jutut siltä varalta että tar sössii oikeudet tai omistajat
	${sco} root:root /home
	${scm} 0755 /home

	${sco} -R root:root /opt
	${scm} -R 0555 /opt

	local n
	n=$(whoami)

	${scm} -R 0755 ~/Desktop/minimize
	dqb "${sco} -R ${n}:${n} ~"
	${sco} -R ${n}:${n} ~
	${sco} -R 101:65534 /home/stubby/

	if [ ${enforce} -eq 1 ] ; then #käyköhän jatkossa turhaksi tämä if-blokki?
		echo "changing /sbin , /etc and /var 4 real"
		${sco} -R root:root /sbin
		${scm} -R 0755 /sbin

		#this part inspired by:https://raw.githubusercontent.com/senescent777/project/main/opt/bin/part0.sh
		#HUOM! ei sitten sorkita /etc sisältöä tässä!!!!
		${sco} -R root:root /etc
		local f

		#erillinen mangle2 /e/s.d tarpeellinen? vissiin juuri sudoers.d/* takia
		for f in $(find /etc/sudoers.d/ -type f) ; do mangle2 ${f} ; done

		for f in $(find /etc -name 'sudo*' -type f | grep -v log) ; do 
			mangle2 ${f}
			csleep 1
		done

		#sudoersin sisältöä voisi kai tiukentaa kanssa
		${sco} -R root:root /var
		${scm} -R go-w /var
		${scm} 0755 /
		${sco} root:root /
	fi
	
	#TODO:konftdstoista toisetkin vkopiot
	if [ -s /etc/resolv.conf.new ] && [ -s /etc/resolv.conf.OLD ] ; then
		sudo rm /etc/resolv.conf
	fi

	[ -s /sbin/dclient-script.OLD ] || sudo cp /sbin/dhclient-script /sbin/dhclient-script.OLD
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
[ ${mode} -eq 0 ] && exit

#if [ -s /etc/apt/sources.list.tmp ] ; then #tämän kanssa tarttisi tehd vielä jotain
#	if [ ${enforce} -eq 1 ] ; then 
#		#https://raw.githubusercontent.com/senescent777/project/main/home/devuan/Dpckcer/buildr/bin/mutilate_sql_2.sh
#		${spc} /etc/apt/sources.list /etc/apt/sources.list.tmp
#		${odio} sed -i 's/DISTRO/chimaera/g' /etc/apt/sources.list.tmp >> /etc/apt/sources.list
#	fi
#fi

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
/opt/bin/clouds.sh 0
#exit

csleep 5
${smr} -rf /run/live/medium/live/initrd.img*
sleep 3

if [ ${debug} -eq 1 ] ; then
	${snt} -tulpan
	sleep 5
fi #

#VAIH:huomioitava tilanne missä libev4 tjsp pois pelistä->ei voi asentaa dnsmasq eikä stubby
#...jospa part3 sanomaan exit
#===================================================PART 3===========================================================
dqb "INSTALLING NEW PACKAGES FROM ${pkgdir} IN 10 SECS"
csleep 3

echo "DO NOT ANSWER \"Yes\" TO A QUESTION ABOUT IPTABLES";sleep 2
echo "... FOR POSITIVE ANSWER MAY BREAK THINGS";sleep 5

${sdi} ${pkgdir}/dns-root-data*.deb 
[ $? -eq 0 ] && ${smr} -rf ${pkgdir}/dns-root-data*.deb 
part3

#toimii miten toimii tämä if-blokki
if [ ${mode} -eq 1 ] ; then
	echo "passwd"
	echo "${odio} passwd"
	echo "${whack} xfce*"

#	dqb "no mas senor"
	exit 	
fi

#TODO:ao-komennolle oma alias yjsp+käyttöön
${sa} autoremove --yes
#exit

#===================================================PART 4(final)==========================================================
#tulisi olla taas tables toiminnassa tässä kohtaa skriptiä
${odio} /etc/init.d/dnsmasq restart
/opt/bin/clouds.sh 1
ns2 stubby
ns4 stubby

if [ ${debug} -eq 1 ] ; then 
	${snt} -tulpan
	sleep 5
	pgrep stubby*
	sleep 5
fi

echo "time to ${sifu} ${iface} or whåtever"
echo "P.S. if stubby dies, resurrect it with \"restart_stubby.desktop\" "
