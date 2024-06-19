#!/bin/sh

iface=eth0
debug=1
the_ar=0
tblz4=rules.v4.180624
install=0 #debug ja install komentoriviparam kautta jatkossa
tgtfile=/mnt/186/nu.tar

#ch-jutut siltä varalta että tar sössii oikeudet tai omistajat
sudo chown root:root /home
sudo chmod 0755 /home
sudo chown -R devuan:devuan /home/devuan/
#sudo chown devuan:devuan /home/devuan/Desktop/
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

sudo /usr/sbin/iptables -P INPUT DROP
sudo /usr/sbin/ip6tables -P INPUT DROP
sudo /usr/sbin/iptables -P OUTPUT DROP
sudo /usr/sbin/ip6tables -P OUTPUT DROP
sudo /usr/sbin/iptables -P FORWARD DROP
sudo /usr/sbin/ip6tables -P FORWARD DROP
sudo /usr/sbin/iptables -L;sleep 5
sudo /usr/sbin/ip6tables -L;sleep 5

for s in avahi-daemon bluetooth cups cups-browsed exim4 nfs-common network-manager ntp mdadm saned rpcbind lm-sensors ; do
sudo /etc/init.d/$s stop
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
	echo "autoremove postponed"
fi

sudo rm -rf /run/live/medium/live/initrd.img*
sleep 3
sudo netstat -tulpan;sleep 5


#Tässä kohtaa mielekästä ajaa tables-komentoja vain jos s.a.autoremove:a EI ajettu.
if [ ${the_ar} -eq 1 ] ; then 
	echo "sudo /usr/sbin/ip6tables-restore /etc/iptables/rules.v6"
	#TODO:lennosta rules.v4 mutilointia, yhdestä sun toisesta projektista mallia
	echo "sudo /usr/sbin/iptables-restore /etc/iptables/${tblz4}"
	echo "sudo /usr/sbin/iptables -L;sleep 5"
	echo "sudo /usr/sbin/ip6tables -L;sleep 5"
else
	sudo /usr/sbin/ip6tables-restore /etc/iptables/rules.v6
	echo "sudo /usr/sbin/iptables-restore /etc/iptables/${tblz4}"
	sudo /usr/sbin/iptables -L
	sudo /usr/sbin/iptables -L
	sleep 5
fi

#exit

#VAIH:komentoriviparametrin mukaisella ehdolla kaiutettavien komentojen ajo oikeasti
if [ ${install} -eq 1 ] ; then 
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

	#TODO:muutama muukin juttu mukaan, mallia https://github.com/senescent777/project/blob/main/opt/bin/install.sh , https://github.com/senescent777/project/blob/main/opt/bin/install.sh , https://github.com/senescent777/project/blob/main/home/devuan/Dpckcer/buildr/source/scripts/part4.sh

	echo "sudo tar -rvpf ${tgtfile}  /var/cache/apt/archives/*.deb"
	echo "sudo /sbin/ifdown ${iface}"
else
	echo "not fetching pkgs"
fi

#exit

echo "sleep 5"
sudo dpkg -i /var/cache/apt/archives/dns-root-data*.deb ; sudo rm -rf /var/cache/apt/archives/dns-root-data*.deb
sudo dpkg -i /var/cache/apt/archives/lib*.deb
[ $? -eq  0 ] && sudo rm -rf /var/cache/apt/archives/lib*.deb
sudo dpkg -i /var/cache/apt/archives/*.deb
[ $? -eq 0 ] && sudo rm -rf /var/cache/apt/archives/*.deb
sleep 2

#sudo /etc/init.d/netfilter-persistent restart #VARMEMPI TOISELLA TAVALLA PRKL
sudo /usr/sbin/ip6tables-restore /etc/iptables/rules.v6
sudo /usr/sbin/iptables-restore /etc/iptables/${tblz4}.b 

sudo /etc/init.d/dnsmasq restart
sleep 3
#exit

#tämän kanssa oli vielä jotain pientä 
#kts. https://github.com/senescent777/some_scripts/blob/main/lib/d227D33.sh.export liittyen
#sudo adduser --system stubby
#sleep 5
#sudo /etc/init.d/stubby start
#sleep 5
#190624:tähän asti vissiin ok

ns2() {
	sudo chmod u+w /home

	sudo /usr/sbin/userdel $1

	sudo adduser --system $1

	sudo chmod go-w /home
	ls -las /home;sleep 7
}

ns2 stubby

ns4() {

	sudo chmod u+w /run
	sudo touch /run/$1.pid
	sudo chmod 0600 /run/$1.pid
	sudo chown $1:65534 /run/$1.pid
	sudo chmod u-w /run
	sleep 5

	#whack $1
	sudo /usr/bin/pkill --signal 9 ${1}*
	sleep 5
	sudo -u $1 $1 -g
}

ns4 stubby

#VAIH:varmista tämä kohdan toimivuus
#https://raw.githubusercontent.com/senescent777/project/main/sbin/dhclient-script.new

#HUOM.190624:parempi jotta mv, Daedalus nalkutti linkityksestä
sudo mv /sbin/dhclient-script /sbin/dhclient-script.OLD
sudo mv /sbin/dhclient-script.new /sbin/dhclient-script

sudo chmod 0555 /sbin/dhclient*
sudo chown root:root /sbin/dhclient*

echo "sudo /sbin/ifup ${iface}"
