#!/bin/sh

iface=eth0
debug=1
the_ar=0
tblz4=rules.v4.180624
install=0 #debug ja install komentoriviparam kautta jatkossa
tgtfile=/mnt/186/nu.tar
ipt=$(sudo which iptables)
ip6t=$(sudo which ip6tables)
iptr=$(sudo which iptables-restore)
ip6tr=$(sudo which ip6tables-restore)

#ch-jutut siltä varalta että tar sössii oikeudet tai omistajat
sudo chown root:root /home
sudo chmod 0755 /home
sudo chown -R devuan:devuan /home/devuan/
sudo chmod -R 0755 /home/devuan/Desktop/minimize
sudo chown -R 101:65534 /home/stubby/

if [ ${debug} -eq 1 ] ; then 
	#TODO:testaa tästä eteenpäin ch-kikkailut (tilap jemmassa)
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
else
	echo "changing /sbin , /etc and /var 4 real"
fi

echo "man date; sudo date --set if necessary" #jos tar nalkuttaa päiväyksistä niin date --set hoitaa
sudo ip link set ${iface} down
/sbin/ifconfig;sleep 5
#exit

for t in INPUT OUTPUT FORWARD ; do sudo ${ipt} -P ${t} DROP ; done
for t in INPUT OUTPUT FORWARD ; do sudo ${ip6t} -P ${t} DROP ; done
for t in INPUT OUTPUT FORWARD b c e f ; do sudo ${ipt} -F ${t} ; done
for t in INPUT OUTPUT FORWARD  ; do sudo ${ip6t} -F ${t} ; done

[ ${debug} -eq 1 ] && sudo ${ipt} -L
[ ${debug} -eq 1 ] && sudo ${ip6t} -L
[ ${debug} -eq 1 ] && sleep 5

#exit

for s in avahi-daemon bluetooth cups cups-browsed exim4 nfs-common network-manager ntp mdadm saned rpcbind lm-sensors ; do
sudo /etc/init.d/${s} stop
sleep 1
done

sleep 3 
sudo /usr/bin/pkill --signal 9 cups*
sudo /usr/bin/pkill --signal 9 avahi*
sleep 3

sudo apt-get remove --purge --yes libblu* network* libcupsfilters* libgphoto*
sudo apt-get remove --purge --yes avahi* blu* cups* exim*
sudo apt-get remove --purge --yes rpc* nfs* ntp* sntp*
sudo apt-get remove --purge --yes modem* wireless* wpa* iw lm-sensors
#sudo apt-get remove --purge --yes  #mdadm jälkimmäisen poisTo saattaa olla huono idea
sudo rm -rf /run/live/medium/live/initrd.img*
sleep 3

if [ ${the_ar} -eq 1 ] ; then 
	sudo apt autoremove --yes
else
	[ ${debug} -eq 1 ] && echo "autoremove postponed"
fi

sudo rm -rf /run/live/medium/live/initrd.img*
sleep 3

[ ${debug} -eq 1 ] && sudo netstat -tulpan
[ ${debug} -eq 1 ] && sleep 5

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

	for s in $(grep -v '#' /home/stubby/.stubby.yml | grep address_data | cut -d ':' -f 2) ; do add_doT ${s} ; done
	for s in $(grep -v '#' /etc/resolv.conf.OLD | grep names | grep -v 127. | awk '{print $2}') ; do  add_snd ${s} ; done

	[ ${debug} -eq 1 ] && sudo ${ipt} -L
	[ ${debug} -eq 1 ] && sudo ${ip6t} -L
	[ ${debug} -eq 1 ] && sleep 5
}

#clouds() {}

#Tässä kohtaa mielekästä ajaa tables-komentoja vain jos s.a.autoremove:a EI ajettu.
if [ ${the_ar} -eq 1 ] ; then 
	if [ ${debug} -eq 1 ] ; then 
		echo "sudo ${ip6tr} /etc/iptables/rules.v6"
		#VAIH:lennosta rules.v4 mutilointia, yhdestä sun toisesta projektista mallia
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
		echo "sudo /sbin/ifup ${iface}"
		echo "sudo apt-get update"
		echo "sudo apt-get --no-install-recommends reinstall libip4tc2 libip6tc2 libxtables12 netbase libmnl0 libnetfilter-conntrack3 libnfnetlink0 libnftnl11 iptables"
		sudo rm -rf /run/live/medium/live/initrd.img*

		echo "sudo apt-get --no-install-recommends reinstall init-system-helpers netfilter-persistent iptables-persistent"
		echo "sudo rm -rf /run/live/medium/live/initrd.img*"

		#VAIH:ntps-juttui mukaan koska tar-nalkutus päiväyksistä
		echo "sudo apt-get --no-install-recommends python3-ntp ntpsec-ntpdate"

		echo "sudo apt-get --no-install-recommends reinstall dnsmasq-base runit-helper"
		echo "sudo rm -rf /run/live/medium/live/initrd.img*"

		echo "sudo apt-get --no-install-recommends reinstall libgetdns10 libbsd0 libidn2-0 libssl1.1 libunbound8 libyaml-0-2 stubby"
		echo "sudo rm -rf /run/live/medium/live/initrd.img*"

		#VAIH:muutama muukin juttu mukaan, mallia https://github.com/senescent777/project/blob/main/opt/bin/install.sh , https://github.com/senescent777/project/blob/main/opt/bin/install.sh , https://github.com/senescent777/project/blob/main/home/devuan/Dpckcer/buildr/source/scripts/part4.sh
		echo "sudo cp /sbin/dhclient-script /sbin/dhclient-script.OLD"
		echo "sudo cp /etc/dhcp/dhclient.conf /etc/dhcp/dhclient.conf.OLD"
		echo "sudo cp /etc/resolv.conf /etc/resolv.conf.OLD"
		echo "sudo cp /etc/iptables/rules.v4 /etc/iptables/rules.v4.OLD"
		echo "sudo tar -cvpf ${tgtfile} /sbin/dhclient-script* /etc/dhcp/dhclient.conf* /etc/resolv.conf* /etc/iptables/rules*"
		
		echo "sudo tar -rvpf ${tgtfile} /var/cache/apt/archives/*.deb"
		echo "sudo /sbin/ifdown ${iface}"
	fi
else
	[ ${debug} -eq 1 ] && echo "not fetching pkgs"
fi

#exit

[ ${debug} -eq 1 ] && echo "sleep 5"
sudo dpkg -i /var/cache/apt/archives/dns-root-data*.deb ; sudo rm -rf /var/cache/apt/archives/dns-root-data*.deb
sudo dpkg -i /var/cache/apt/archives/lib*.deb
[ $? -eq  0 ] && sudo rm -rf /var/cache/apt/archives/lib*.deb
#HUOM. ei kannattane vastata myöntävästi tallennus-kysymykseen?
sudo dpkg -i /var/cache/apt/archives/*.deb
[ $? -eq 0 ] && sudo rm -rf /var/cache/apt/archives/*.deb
[ ${debug} -eq 1 ] && sleep 2

#exit
[ ${the_ar} -eq 1 ] && astral_sleep
#exit

#sudo /etc/init.d/netfilter-persistent restart #VARMEMPI TOISELLA TAVALLA PRKL
sudo ${ip6tr} /etc/iptables/rules.v6
sudo ${ipt} -D e 3; sudo ${ipt} -D e 2
sudo ${ipt} -D b 3; sudo ${ipt} -D b 2
sudo ${ipt} -D INPUT 5; sudo ${ipt} -D OUTPUT 6

sudo /etc/init.d/dnsmasq restart
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

	sudo chmod u+w /run
	sudo touch /run/${1}.pid
	sudo chmod 0600 /run/${1}.pid
	sudo chown $1:65534 /run/${1}.pid
	sudo chmod u-w /run
	sleep 5

	sudo /usr/bin/pkill --signal 9 ${1}*
	sleep 5
	sudo -u ${1} ${1} -g
}

ns4 stubby

#HUOM.200624:vissiin toimii jo stubby 
#https://raw.githubusercontent.com/senescent777/project/main/sbin/dhclient-script.new

#HUOM.190624:parempi jotta mv, Daedalus nalkutti linkityksestä
sudo mv /sbin/dhclient-script /sbin/dhclient-script.OLD
sudo mv /sbin/dhclient-script.new /sbin/dhclient-script

sudo chmod 0555 /sbin/dhclient*
sudo chown root:root /sbin/dhclient*

echo "sudo /sbin/ifup ${iface}"
