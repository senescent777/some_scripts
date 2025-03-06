#!/bin/bash
d=$(dirname $0)

if [ -s ${d}/conf ] && [ -s ${d}/lib.sh ] ; then
	. ${d}/conf
	. ${d}/lib.sh
else
	echo "TO CONTINUE FURTHER IS POINTLESS, ESSENTIAL FILES MISSING"
	exit 111	
fi

#VAIH:tuplavarmistus että validi /e/n/i tulee mukaan?
#(josko ihan kirjoittaisi siihen tdstoon pari riviä?)

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

function mangle_s() {
	local tgt
	[ y"${1}" == "y" ] && exit 
	[ y"${2}" == "y" ] && exit 
	[ -f ${2} ] || exit 
	tgt=${2}
	dqb "fr0m mangle_s(${1}, ${2}) : params_OK"; sleep 3

	if [ -s ${1} ] ; then 
		sudo chmod 0555 ${1} #HUOM. miksi juuri 5? no six six six että suoritettavaan tdstoon ei tartte kirjoittaa
		sudo chown root:root ${1} 

		local s

		s=$(sha256sum ${1})
		sudo echo "${n} localhost=NOPASSWD: sha256: ${s} " >> ${tgt}
	else
		dqb "no sucg file as ${1} "
	fi
}

function pre_enforce() {
	local q
	local f 

	#HUOM.230624 /sbin/dhclient* joutuisi hoitamaan toisella tavalla q mangle_s	
	if [ -f /etc/sudoers.d/meshuggah ] ; then
		dqb "a51a kun05a"
 	else		
		q=$(mktemp -d)	
		sudo touch ${q}/meshuggah
		[ -f ${q}/meshuggah ] || exit

		sudo chown ${n}:${n} ${q}/meshuggah #oli: 1k:1k
		sudo chmod 0660 ${q}/meshuggah	
		
		#HUOM. clouds ja stubby mukaan toisella tavalla jatkossa?
		for f in ${CB_LIST1} ; do mangle_s ${f}  ${q}/meshuggah ; done
		#for f in ~/Desktop/minimize/${distro}/clouds.sh 
		for f in ${d}/clouds.sh /sbin/halt /sbin/reboot ; do mangle_s ${f}  ${q}/meshuggah ; done

		if [ -s ${q}/meshuggah ] ; then
			dqb "sudo mv ${q}/meshuggah /etc/sudoers.d in 5 secs"
			csleep 5

			sudo chmod a-wx ${q}/meshuggah
			sudo chown root:root ${q}/meshuggah	
			sudo mv ${q}/meshuggah /etc/sudoers.d
		fi
	
		#HUOM.250624:pitäisi kai pakottaa ulosheitto xfce:stä jotta sudo-muutokset tulisivat voimaan?
	fi
}

function enforce_access() {
	dqb "3nf0rc3_acc355()"
	local f

	#HUOM. ennen /home:n sorkkimista olevat rivit aiemmin pre_enoirce():ssam takaisin jos qsee
	${sco} 0440 /etc/sudoers.d/* #ei missään nimessä tähän:-R
	${scm} 0750 /etc/sudoers.d #uskaltaakohan? jos vaikka
	${sco} -R root:root /etc/sudoers.d

	#tässä vai enforce_access():issa parempi näiden?
	for f in $(find /etc -name 'sudo*' -type f | grep -v log) ; do 
		mangle2 ${f}
		csleep 1
	done	

	${scm} 0755 /etc 
	${sco} -R root:root /etc

	#HUOM. mangle2 olisi keksitty... ja ne find-jutut alempana
	${sco} -R root:root /sbin
	${scm} -R 0755 /sbin
	
	${sco} -R root:root /var
	${scm} -R 0755 /var

	${sco} root:staff /var/local
	${sco} root:mail /var/mail
		
	${sco} -R man:man /var/cache/man 
	${scm} -R 0755 /var/cache/man

	${scm} 0755 /
	${sco} root:root /

	#ch-jutut siltä varalta että tar sössii oikeudet tai omistajat
	${sco} root:root /home
	${scm} 0755 /home
	${scm} -R 0755 ~/Desktop/minimize
	
	if [ y"${n}" != "y" ] ; then
		dqb "${sco} -R ${n}:${n} ~"
		${sco} -R ${n}:${n} ~
	fi

	#${sco} -R 101:65534 /home/stubby/	
	f=$(date +%F)

	[ -f /etc/resolv.conf.${f} ] || ${spc} /etc/resolv.conf /etc/resolv.conf.${f}
	[ -f /sbin/dhclient-script.${f} ] || ${spc} /sbin/dhclient-script /sbin/dhclient-script.${f}
	[ -f /etc/network/interfaces.${f} ] || ${spc} /etc/network/interfaces /etc/network/interfaces.${f}

	if [ -s /etc/resolv.conf.new ] && [ -s /etc/resolv.conf.OLD ] ; then
		sudo rm /etc/resolv.conf
	fi

	[ -s /sbin/dclient-script.OLD ] || sudo cp /sbin/dhclient-script /sbin/dhclient-script.OLD
}

#==================================PART 1============================================================

function part1() {
	#jos jokin näistä kolmesta hoitaisi homman...
	${sifd} ${iface}
	${sifd} -a
	${sip} link set ${iface} down

	[ $? -eq 0 ] || echo "PROBLEMS WITH NETWORK CONNECTION"
	[ ${debug} -eq 1 ] && /sbin/ifconfig;sleep 5 

	if [ $ic -gt 0 ] ; then
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
	fi
}

if [ $# -gt 0 ] ; then
	for opt in $@ ; do parse_opts_1 $opt ; done
fi

check_params 
[ ${enforce} -eq 1 ] && pre_enforce
enforce_access 

dqb "man date;man hwclock; sudo date --set | sudo hwclock --set --date if necessary" 
part1 
g=$(date +%F)
csleep 5
[ -f /etc/apt/sources.list ] && sudo mv /etc/apt/sources.list /etc/apt/sources.list.${g}

sudo touch /etc/apt/sources.list
${scm} a+w /etc/apt/sources.list

#030325:tässä kusi hommat vähän(jos nyt 050325 kunnossa)
#(jatkossa conf:iin se pakettipalvelin?)
for x in ${distro} ${distro}-updates ${distro}-security ; do echo "deb https://devuan.keff.org/merged ${x} main" >> /etc/apt/sources.list ; done

${scm} a-w /etc/apt/sources.list
${sco} -R root:root /etc/apt 
${scm} -R a-w /etc/apt/
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

#HUOM.0505325:libgetdns10 kanssa oli jokin ongelma
pre_part3 ${d} 
part3 ${d} 

if [ ${mode} -eq 1 ] ; then
	dqb "R (in 6 secs)"; csleep 6
	${odio} passwd
	
	if [ $? -eq 0 ] ; then
		dqb "L (in 6 secs)"; csleep 6
		passwd
	fi

	if [ $? -eq 0 ] ; then
		${whack} xfce* #HUOM. tässä ei tartte jos myöhemmin joka tap
		exit 	
	fi
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
