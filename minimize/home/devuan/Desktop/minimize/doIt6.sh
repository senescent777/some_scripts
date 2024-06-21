#!/bin/bash

iface=eth0 #grep /e/n/i ?
debug=0
the_ar=0
tblz4=rules.v4.180624
install=0 #debug ja install komentoriviparam kautta jatkossa
tgtfile=/mnt/186/nu.tar
enforce=0
no_mas=0

ipt=$(sudo which iptables)
ip6t=$(sudo which ip6tables)
iptr=$(sudo which iptables-restore)
ip6tr=$(sudo which ip6tables-restore)

#DONE:optioiden parsintaan parannusta, nyt vain -o tarvitsee $2 oikeasti
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
	#parse_opts ${3} ${4}
	#parse_opts ${5} ${6}

	for opt in $@ ; do parse_opts_1 $opt ; done
fi

#DONE:tables-juttujen toiminnan tarkistus tähän samaan
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

	#TODO:muutkin binäärit + ekspliittinen sudo pois missä mahd
	[ -x ${ipt} ] || exit 5
	[ -x ${ip6t} ] || exit 5
	[ -x ${iptr} ] || exit 5
	[ -x ${ip6tr} ] || exit 5

	[ ${debug} -eq 1 ] && echo "b1nar135 0k"
	[ ${debug} -eq 1 ] && sleep 3
}

check_params

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
		echo "https://github.com/senescent777/project/tree/main/sbin can be used as /sbin"
		echo "sudo chown -R root:root /sbin"
		echo "sudo chmod -R 0755 /sbin"
	
		echo "https://github.com/senescent777/project/tree/main/etc can be used as /etc except for stubby-related stuff"
		echo "sudo chown -R root:root /etc"
		echo "sudo chmod -R go-w /etc"
	
		echo "sudo chown -R root:root /var"
		echo "sudo chmod -R go-w /var"
		echo "sudo chown root:root /"
		echo "sudo chmod 0755 /"
	fi
fi

if [ -s /etc/resolv.conf.new ] && [ -s /etc/resolv.conf.OLD ] ; then
	sudo rm /etc/resolv.conf
fi

[ -s /sbin/dclient-script.OLD ] || sudo cp /sbin/dhclient-script /sbin/dhclient-script.OLD

echo "man date;man hwclock; sudo date --set | sudo hwclock --set --date if necessary" #jos tar nalkuttaa päiväyksistä niin date --set hoitaa
sudo ip link set ${iface} down
/sbin/ifconfig;sleep 5 #debug?
#exit

for t in INPUT OUTPUT FORWARD ; do 
	sudo ${ipt} -P ${t} DROP
	sudo ${ip6t} -P ${t} DROP
	sudo ${ip6t} -F ${t}
done

for t in INPUT OUTPUT FORWARD b c e f ; do sudo ${ipt} -F ${t} ; done

[ ${debug} -eq 1 ] && sudo ${ipt} -L
[ ${debug} -eq 1 ] && sudo ${ip6t} -L
[ ${debug} -eq 1 ] && sleep 5

#exit

for s in avahi-daemon bluetooth cups cups-browsed exim4 nfs-common network-manager ntp mdadm saned rpcbind lm-sensors dnsmasq stubby ; do
	sudo /etc/init.d/${s} stop
	sleep 1
done

[ ${debug} -eq 1 ] && echo "shutting down some services in 3 secs"
sleep 3 
sudo /usr/bin/pkill --signal 9 cups*
sudo /usr/bin/pkill --signal 9 avahi*
sudo /usr/bin/pkill --signal 9 dnsmasq*
sudo /usr/bin/pkill --signal 9 stubby*
sleep 3

sudo apt-get remove --purge --yes libblu* network* libcupsfilters* libgphoto*
sudo apt-get remove --purge --yes avahi* blu* cups* exim*
sudo apt-get remove --purge --yes rpc* nfs* ntp* sntp*
sudo apt-get remove --purge --yes modem* wireless* wpa* iw lm-sensors
#sudo apt-get remove --purge --yes  #mdadm jälkimmäisen poisTo saattaa olla huono idea

sudo rm -rf /run/live/medium/live/initrd.img*
sleep 3
#exit

if [ ${the_ar} -eq 1 ] ; then 
	[ ${debug} -eq 1 ] && echo "autoremove in 5 secs"
	[ ${debug} -eq 1 ] && sleep 5
	sudo apt autoremove --yes
else
	[ ${debug} -eq 1 ] && echo "autoremove postponed"
	sleep 5
fi

sudo rm -rf /run/live/medium/live/initrd.img*
sleep 3

[ ${debug} -eq 1 ] && sudo netstat -tulpan
[ ${debug} -eq 1 ] && sleep 5
#exit

add_doT() {
	sudo ${ipt} -A b -p tcp --sport 853 -s ${1} -j c
	sudo ${ipt} -A e -p tcp --dport 853 -d ${1} -j f
}

add_snd() {
	sudo ${ipt} -A b -p udp -m udp -s ${1} --sport 53 -j ACCEPT 
	sudo ${ipt} -A e -p udp -m udp -d ${1} --dport 53 -j ACCEPT 
}

astral_sleep() {
	sudo ${ip6tr} /etc/iptables/rules.v6
	sudo ${iptr} /etc/iptables/${tblz4}

	local s
	for s in $(grep -v '#' /home/stubby/.stubby.yml | grep address_data | cut -d ':' -f 2) ; do add_doT ${s} ; done
	for s in $(grep -v '#' /etc/resolv.conf.OLD | grep names | grep -v 127. | awk '{print $2}') ; do  add_snd ${s} ; done

	[ ${debug} -eq 1 ] && sudo ${ipt} -L
	[ ${debug} -eq 1 ] && sudo ${ip6t} -L
	[ ${debug} -eq 1 ] && sleep 5
}

#part4.sh ?
clouds() {
	echo "coluds(${1})"

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
		echo "sudo ${ip6tr} /etc/iptables/rules.v6"
		#DONE:lennosta rules.v4 mutilointia, yhdestä sun toisesta projektista mallia
		echo "sudo ${iptr} /etc/iptables/${tblz4}"
		echo "sudo ${ipt} -L;sleep 5"
		echo "sudo ${ip6t} -L;sleep 5"
	fi
else
	astral_sleep
fi

#exit

#VAIH:komentoriviparametrin mukaisella ehdolla kaiutettavien komentojen ajo oikeasti
if [ ${install} -eq 1 ] ; then 
	if [ ${debug} -eq 1 ] ; then 
		echo "sudo /sbin/ifup ${iface} | sudo /sbin/ifup -a" #if there is > 1 interfaces...
		echo "sudo apt-get update"
		echo "sudo apt-get --no-install-recommends reinstall libip4tc2 libip6tc2 libxtables12 netbase libmnl0 libnetfilter-conntrack3 libnfnetlink0 libnftnl11 iptables"
		sudo rm -rf /run/live/medium/live/initrd.img*

		echo "sudo apt-get --no-install-recommends reinstall init-system-helpers netfilter-persistent iptables-persistent"
		echo "sudo rm -rf /run/live/medium/live/initrd.img*"

		#VAIH:ntps-juttui mukaan koska tar-nalkutus päiväyksistä
		echo "sudo apt-get --no-install-recommends reinstall python3-ntp ntpsec-ntpdate"

		echo "sudo apt-get --no-install-recommends reinstall dnsmasq-base runit-helper"
		echo "sudo rm -rf /run/live/medium/live/initrd.img*"

		echo "sudo apt-get --no-install-recommends reinstall libgetdns10 libbsd0 libidn2-0 libssl1.1 libunbound8 libyaml-0-2 stubby"
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
	fi
else
	[ ${debug} -eq 1 ] && echo "not fetching pkgs"
fi

#exit
#tässä kohta atai vähän myöh vaihd konftdstpt
#clouds 1

[ ${debug} -eq 1 ] && echo "sleep 5"
[ ${debug} -eq 1 ] && echo "don't save tables rules"

sudo dpkg -i /var/cache/apt/archives/dns-root-data*.deb ; sudo rm -rf /var/cache/apt/archives/dns-root-data*.deb
sudo dpkg -i /var/cache/apt/archives/lib*.deb
[ $? -eq  0 ] && sudo rm -rf /var/cache/apt/archives/lib*.deb
#HUOM. ei kannattane vastata myöntävästi tallennus-kysymykseen?
sudo dpkg -i /var/cache/apt/archives/*.deb
[ $? -eq 0 ] && sudo rm -rf /var/cache/apt/archives/*.deb
[ ${debug} -eq 1 ] && sleep 2

#exit
[ ${the_ar} -eq 1 ] && astral_sleep
#20.6,24 tähän asti vissiin ok
[ ${no_mas} -eq 1 ] && exit 

[ ${debug} -eq 1 ] && echo "starting 2 3nabl3 stubby in 5 secs"
[ ${debug} -eq 1 ] && sleep 5
clouds 1 #tässä vai ennen dpkg ?

#sudo /etc/init.d/netfilter-persistent restart #VARMEMPI TOISELLA TAVALLA PRKL
sudo ${ip6tr} /etc/iptables/rules.v6
sudo ${ipt} -D e 3; sudo ${ipt} -D e 2
sudo ${ipt} -D b 3; sudo ${ipt} -D b 2
sudo ${ipt} -D INPUT 5; sudo ${ipt} -D OUTPUT 6

sudo /etc/init.d/dnsmasq restart
[ ${debug} -eq 1 ] && sudo ${ipt} -L
sleep 3
#exit

#kts. https://github.com/senescent777/some_scripts/blob/main/lib/d227D33.sh.export liittyen

ns2() {
	sudo chmod u+w /home
	sudo /usr/sbin/userdel ${1}
	sudo adduser --system ${1}
	sudo chmod go-w /home
	[ ${debug} -eq 1 ] && ls -las /home;sleep 7
}

ns2 stubby

ns4() {
	[ ${debug} -eq 1 ] && echo "ns4()"
	sudo chmod u+w /run
	sudo touch /run/${1}.pid
	sudo chmod 0600 /run/${1}.pid
	sudo chown $1:65534 /run/${1}.pid
	sudo chmod u-w /run
	[ ${debug} -eq 1 ] && sleep 5

	sudo /usr/bin/pkill --signal 9 ${1}*
	[ ${debug} -eq 1 ] && sleep 5

	[ ${debug} -eq 1 ] && echo "starting ${1} in 5 secs"
	[ ${debug} -eq 1 ] && sleep 5

	sudo -u ${1} ${1} -g
	echo $?
	[ ${debug} -eq 1 ] && sleep 5
}

ns4 stubby

#HUOM.200624:vissiin toimii jo stubby 
#https://raw.githubusercontent.com/senescent777/project/main/sbin/dhclient-script.new

#HUOM.190624:parempi jotta mv, Daedalus nalkutti linkityksestä
#sudo mv /sbin/dhclient-script /sbin/dhclient-script.OLD
#sudo mv /sbin/dhclient-script.new /sbin/dhclient-script

echo "sudo /sbin/ifup whåtever"
