#!/bin/bash

iface=eth0 #grep /e/n/i ?
debug=0
the_ar=0
tblz4=rules.v4.180624
install=0 
tgtfile=/mnt/186/nu.tar
enforce=0
no_mas=0

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

parse_opts_2() {
	case "${1}" in
		-o )
			tgtfile=${2}
		;;
	esac
}

parse_opts_1() {
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

if [ $# -gt 0 ] ; then
	parse_opts_2 ${1} ${2}
	for opt in $@ ; do parse_opts_1 $opt ; done
fi

check_params() {
	case ${the_ar} in
		0|1)
			[ ${debug} -eq 1 ] && echo "the_ar ok (${the_ar})"
		;;
		*)
			[ ${debug} -eq 1 ] && echo "P.V.H.H"
			exit 1
		;;
	esac

	case ${install} in
		0|1)
			[ ${debug} -eq 1 ] && echo "install ok(${install} )"
		;;
		*)
			[ ${debug} -eq 1 ] && echo "P.V.H.H"
			exit 2
		;;
	esac

	[ -s ${tgtfile} ] && echo "${tgtfile} alr3ady 3x1st5"
	#TODO:tgtfile'n hakemisto olemassa?	
	
	case ${no_mas} in
		0|1)
			[ ${debug} -eq 1 ] && echo " ok ${no_mas}"
		;;
		*)
			[ ${debug} -eq 1 ] && echo "te quiero puta"
			exit 3
		;;
	esac

	case ${debug} in
		0|1)
			[ ${debug} -eq 1 ] && echo "ko"
		;;
		*)
			echo "MEE HIMAAS LEIKKIMÄÄN"
			exit 4
		;;
	esac
}

check_binaries() {
	#VAIH:muutkin binäärit + ekspliittinen sudo pois missä mahd
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

	if [ ${debug} -eq 1 ] ; then
		echo "b1nar135 0k" #
		sleep 3 #
	fi #

	ipt="sudo ${ipt}"
	ip6t="sudo ${ip6t}"
	iptr="sudo ${iptr}"
	ip6tr="sudo ${ip6tr}"
	whack="sudo ${whack} --signal 9 "
	snt="sudo ${snt}"
	sharpy="sudo ${sag} remove --purge --yes "
	sdi="sudo ${sdi} -i"
	shary="sudo ${sag} --no-install-recommends reinstall "
}

check_params
check_binaries

#ch-jutut siltä varalta että tar sössii oikeudet tai omistajat
sudo chown root:root /home
sudo chmod 0755 /home
sudo chown -R devuan:devuan /home/devuan/
sudo chmod -R 0755 /home/devuan/Desktop/minimize
sudo chown -R 101:65534 /home/stubby/

if [ ${enforce} -eq 1 ] ; then 
	echo "changing /sbin , /etc and /var 4 real"
	sudo chown -R root:root /sbin
	sudo chmod -R 0755 /sbin
	sudo chown -R root:root /etc
	sudo chown -R root:root /var
	sudo chmod -R go-w /var
	sudo chmod 0755 /
else
	if [ ${debug} -eq 1 ] ; then 
		#VAIH:testaa tästä eteenpäin ch-kikkailut (tilap jemmassa)
		echo "#https://github.com/senescent777/project/tree/main/sbin can be used as /sbin"
		echo "#sudo chown -R root:root /sbin"
		echo "#sudo chmod -R 0755 /sbin"
	
		echo "#https://github.com/senescent777/project/tree/main/etc can be used as /etc except for stubby-related stuff"
		echo "#sudo chown -R root:root /etc"
		echo "#sudo chmod -R go-w /etc"
	
		echo "#sudo chown -R root:root /var"
		echo "#sudo chmod -R go-w /var"
		echo "#sudo chown root:root /"
		echo "#sudo chmod 0755 /"
	fi #
fi

if [ -s /etc/resolv.conf.new ] && [ -s /etc/resolv.conf.OLD ] ; then
	sudo rm /etc/resolv.conf
fi

[ -s /sbin/dclient-script.OLD ] || sudo cp /sbin/dhclient-script /sbin/dhclient-script.OLD

[ ${debug} -eq 1 ] && echo "man date;man hwclock; sudo date --set | sudo hwclock --set --date if necessary" #jos tar nalkuttaa päiväyksistä niin date --set hoitaa
sudo ip link set ${iface} down
[ ${debug} -eq 1 ] && /sbin/ifconfig;sleep 5 
#exit

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

[ ${debug} -eq 1 ] && echo "shutting down some services in 3 secs"
sleep 3 
${whack} cups*
${whack} avahi*
${whack} dnsmasq*
${whack} stubby*
${whack} nm-applet
sleep 3

${sharpy} libblu* network* libcupsfilters* libgphoto*
${sharpy} avahi* blu* cups* exim*
${sharpy} rpc* nfs* ntp* sntp*
${sharpy} modem* wireless* wpa* iw lm-sensors
#  #mdadm jälkimmäisen poisTo saattaa olla huono idea

sudo rm -rf /run/live/medium/live/initrd.img*
sleep 3
#exit

if [ ${the_ar} -eq 1 ] ; then 
	if [ ${debug} -eq 1 ] ; then
		echo "autoremove in 5 secs"; sleep 5 #
	fi #
	sudo apt autoremove --yes
else
	[ ${debug} -eq 1 ] && echo "autoremove postponed"
	sleep 5
fi

sudo rm -rf /run/live/medium/live/initrd.img*
sleep 3

if [ ${debug} -eq 1 ] ; then
	${snt} -tulpan
	sleep 5
fi #
#exit

add_doT() {
	${ipt} -A b -p tcp --sport 853 -s ${1} -j c
	${ipt} -A e -p tcp --dport 853 -d ${1} -j f
}

add_snd() {
	${ipt} -A b -p udp -m udp -s ${1} --sport 53 -j ACCEPT 
	${ipt} -A e -p udp -m udp -d ${1} --dport 53 -j ACCEPT 
}

astral_sleep() {
	[ ${debug} -eq 1 ] && echo "astral_sleep()"
	${ip6tr} /etc/iptables/rules.v6
	${iptr} /etc/iptables/${tblz4}

	local s
	for s in $(grep -v '#' /home/stubby/.stubby.yml | grep address_data | cut -d ':' -f 2) ; do add_doT ${s} ; done
	for s in $(grep -v '#' /etc/resolv.conf.OLD | grep names | grep -v 127. | awk '{print $2}') ; do  add_snd ${s} ; done

	if [ ${debug} -eq 1 ] ; then
		${ipt} -L  #
		${ip6t} -L #
		sleep 5
	fi #
}	

#part4.sh ?
clouds() {
	[ ${debug} -eq 1 ] && echo "coluds(${1})"

	sudo rm /etc/resolv.conf
	sudo rm /etc/dhcp/dhclient.conf
	sudo rm /sbin/dhclient-script

	case ${1} in 
		0)
			sudo ln -s /etc/resolv.conf.OLD /etc/resolv.conf
			sudo ln -s /etc/dhcp/dhclient.conf.OLD /etc/dhcp/dhclient.conf
			sudo cp /sbin/dhclient-script.OLD /sbin/dhclient-script
		;;
		1)
			sudo ln -s /etc/resolv.conf.new /etc/resolv.conf
			sudo ln -s /etc/dhcp/dhclient.conf.new /etc/dhcp/dhclient.conf
			sudo cp /sbin/dhclient-script.new /sbin/dhclient-script
		
		;;
	esac

	sudo chmod 0555 /sbin/dhclient*
	sudo chown root:root /sbin/dhclient*
	sleep 2
}

clouds 0

#Tässä kohtaa mielekästä ajaa tables-komentoja vain jos s.a.autoremove:a EI ajettu.
if [ ${the_ar} -eq 1 ] ; then 
	if [ ${debug} -eq 1 ] ; then 
		echo "${ip6tr} /etc/iptables/rules.v6"
		#DONE:lennosta rules.v4 mutilointia, yhdestä sun toisesta projektista mallia
		echo "${iptr} /etc/iptables/${tblz4}"
		echo "${ipt} -L;sleep 5"
		echo "${ip6t} -L;sleep 5"
	fi
else
	astral_sleep
fi

#exit

#VAIH:komentoriviparametrin mukaisella ehdolla kaiutettavien komentojen ajo oikeasti
if [ ${install} -eq 1 ] ; then 
	if [ ${debug} -eq 1 ] ; then 
		echo "sudo /sbin/ifup ${iface} | sudo /sbin/ifup -a" #if there is > 1 interfaces...
		echo "${sag} update"
		echo "${shary} libip4tc2 libip6tc2 libxtables12 netbase libmnl0 libnetfilter-conntrack3 libnfnetlink0 libnftnl11 iptables"
		sudo rm -rf /run/live/medium/live/initrd.img*

		echo "${shary} init-system-helpers netfilter-persistent iptables-persistent"
		echo "sudo rm -rf /run/live/medium/live/initrd.img*"

		#VAIH:ntps-juttui mukaan koska tar-nalkutus päiväyksistä
		echo "${shary} python3-ntp ntpsec-ntpdate"

		echo "${shary} dnsmasq-base runit-helper"
		echo "sudo rm -rf /run/live/medium/live/initrd.img*"

		echo "${shary} libgetdns10 libbsd0 libidn2-0 libssl1.1 libunbound8 libyaml-0-2 stubby"
		echo "sudo rm -rf /run/live/medium/live/initrd.img*"

		#VAIH:muutama muukin juttu mukaan, mallia https://github.com/senescent777/project/blob/main/opt/bin/install.sh , https://github.com/senescent777/project/blob/main/opt/bin/install.sh , https://github.com/senescent777/project/blob/main/home/devuan/Dpckcer/buildr/source/scripts/part4.sh (jatka vielä)
		#Hostilta orig interfaces, tables, dhc, dhc-scr ja res.
		#Lisäksi dnsm, stu.
		#Loput ghub:ista?
		
		echo "sudo cp /sbin/dhclient-script /sbin/dhclient-script.OLD"
		echo "sudo cp /etc/dhcp/dhclient.conf /etc/dhcp/dhclient.conf.OLD"
		echo "sudo cp /etc/resolv.conf /etc/resolv.conf.OLD"

		echo "sudo cp /etc/iptables/rules.v4 /etc/iptables/rules.v4.OLD"
		echo "sudo tar -cvpf ${tgtfile} /sbin/dhclient-script* /etc/dhcp/dhclient.conf* /etc/resolv.conf* /etc/iptables/rules*"
		echo "sudo tar -rvpf ${tgtfile} ~/Desktop/minimize /etc/apt /etc/sysctl.conf /etc/network /etc/init.d/stubby"
		echo "sudo tar -rvpf ${tgtfile} /var/cache/apt/archives/*.deb"
		echo "sudo /sbin/ifdown ${iface} | sudo /sbin/ifdown -a"
	fi #
else
	if [ ${debug} -eq 1 ] ; then
		echo "not fetching pkgs"
	fi #
fi

#exit
#tässä kohta atai vähän myöh vaihd konftdstpt
#clouds 1

if [ ${debug} -eq 1 ] ; then
	echo "don't save tables rules"
	sleep 5
fi #

pkgdir=/var/cache/apt/archives
${sdi} ${pkgdir}/dns-root-data*.deb 
[ $? -eq 0 ] && sudo rm -rf ${pkgdir}/dns-root-data*.deb

${sdi} /var/cache/apt/archives/lib*.deb
[ $? -eq  0 ] && sudo rm -rf ${pkgdir}/lib*.deb

#HUOM. ei kannattane vastata myöntävästi tallennus-kysymykseen?
${sdi} ${pkgdir}/*.deb
[ $? -eq 0 ] && sudo rm -rf ${pkgdir}/*.deb
[ ${debug} -eq 1 ] && sleep 2

#exit
[ ${the_ar} -eq 1 ] && astral_sleep
#20.6,24 tähän asti vissiin ok
[ ${no_mas} -eq 1 ] && exit 

if [ ${debug} -eq 1 ] ; then
	echo "starting 2 3nabl3 stubby in 5 secs"
	sleep 5
fi #

clouds 1 #tässä vai ennen dpkg ?

#sudo /etc/init.d/netfilter-persistent restart #VARMEMPI TOISELLA TAVALLA PRKL
if [ ${debug} -eq 1 ] ; then
	echo "before:
	${ipt} -L
	sleep 5
fi #

#exit

${ip6tr} /etc/iptables/rules.v6
${ipt} -D e 3; ${ipt} -D e 2
${ipt} -D b 3; ${ipt} -D b 2
${ipt} -D INPUT 5; ${ipt} -D OUTPUT 6
sudo /etc/init.d/dnsmasq restart

if [ ${debug} -eq 1 ] ; then 
	echo "after:"
	${ipt} -L
fi #

sleep 5
#exit #210624:kuseeko tämän jälkeen jotain vai ei?
#kts. https://github.com/senescent777/some_scripts/blob/main/lib/d227D33.sh.export liittyen

ns2() {
	sudo chmod u+w /home
	sudo /usr/sbin/userdel ${1}
	sudo adduser --system ${1}
	sudo chmod go-w /home

	if [ ${debug} -eq 1 ] ; then
		ls -las /home;sleep 7
	fi #
}

ns4() {
	if [ ${debug} -eq 1 ] ; then 
		echo "ns4()"
	fi #

	sudo chmod u+w /run
	sudo touch /run/${1}.pid
	sudo chmod 0600 /run/${1}.pid
	sudo chown $1:65534 /run/${1}.pid
	sudo chmod u-w /run

	if [ ${debug} -eq 1 ] ; then
		sleep 5
	fi

	${whack} ${1}*

	if [ ${debug} -eq 1 ] ; then
		sleep 5
		echo "starting ${1} in 5 secs"
		sleep 5
	fi #

	sudo -u ${1} ${1} -g
	echo $?

	if [ ${debug} -eq 1 ] ; then
		sleep 5
	fi
}

ns4 stubby
ns2 stubby

#HUOM.200624:vissiin toimii jo stubby 
#https://raw.githubusercontent.com/senescent777/project/main/sbin/dhclient-script.new

#HUOM.190624:parempi jotta mv, Daedalus nalkutti linkityksestä
#sudo mv /sbin/dhclient-script /sbin/dhclient-script.OLD
#sudo mv /sbin/dhclient-script.new /sbin/dhclient-script

echo "sudo /sbin/ifup whåtever"
