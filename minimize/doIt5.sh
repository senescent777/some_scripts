#!/bin/sh

man date #jos tar nalkuttaa päiväyksistä niin date --set hoitaa
sudo ip link set eth0 down
/sbin/ifconfig;sleep 5

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
done

sleep 3 
sudo /usr/bin/pkill --signal 9 cups*
sudo /usr/bin/pkill --signal 9 avahi*
sleep 3

sudo apt-get remove --purge --yes libblu* network*
sudo apt-get remove --purge --yes libcupsfilters* libgphoto*
sudo apt-get remove --purge --yes avahi* blu* cups* exim*
sudo apt-get remove --purge --yes rpc* nfs* ntp* sntp*
sudo apt-get remove --purge --yes modem* wireless* wpa* iw
sudo apt-get remove --purge --yes lm-sensors #mdadm jälkimmäisen poisro saattaa olla huono idea
sudo rm -rf /run/live/medium/live/initrd.img*
sleep 3

#TODO:komentoriviparametrin taakse ar
sudo apt autoremove --yes
sudo rm -rf /run/live/medium/live/initrd.img*
sleep 3

sudo netstat -tulpan;sleep 5

#Tässä kohtaa mielekästä ajaa tables-komentoja vain jos s.a.autoremove:a EI ajettu.
echo "sudo /usr/sbin/ip6tables-restore /etc/iptables/rules.v6"
echo "sudo /usr/sbin/iptables-restore /etc/iptables/rules.v4.180624"
echo "sudo /usr/sbin/iptables -L;sleep 5"
echo "sudo /usr/sbin/ip6tables -L;sleep 5"

#TODO:komentoriviparametrin mukaisella ehdolla kaiutettavien komentojen ajo oikeasti
echo "sudo /sbin/ifup eth0"
echo "sudo apt-get update"
echo "sudo apt-get --no-install-recommends reinstall libip4tc2 libip6tc2 libxtables12 netbase libmnl0 libnetfilter-conntrack3 libnfnetlink0 libnftnl11 iptables"
sudo rm -rf /run/live/medium/live/initrd.img*

echo "sudo apt-get --no-install-recommends reinstall init-system-helpers netfilter-persistent iptables-persistent"
echo "sudo rm -rf /run/live/medium/live/initrd.img*"

echo "sudo apt-get --no-install-recommends reinstall dnsmasq-base runit-helper"
echo "sudo rm -rf /run/live/medium/live/initrd.img*"

echo "sudo apt-get --no-install-recommends reinstall libgetdns10 libbsd0 libidn2-0 libssl1.1 libunbound8 libyaml-0-2 stubby"
echo "sudo rm -rf /run/live/medium/live/initrd.img*"

echo "sudo tar -rvpf /mnt/186/nu.tar /var/cache/apt/archives/*.deb"
echo "sudo /sbin/ifdown eth0"

echo "sleep 5"
sudo dpkg -i /var/cache/apt/archives/dns-root-data*.deb ; sudo rm -rf /var/cache/apt/archives/dns-root-data*.deb
sudo dpkg -i /var/cache/apt/archives/lib*.deb
[ $? -eq  0 ] && sudo rm -rf /var/cache/apt/archives/lib*.deb
sudo dpkg -i /var/cache/apt/archives/*.deb
[ $? -eq 0 ] && sudo rm -rf /var/cache/apt/archives/*.deb
sleep 2

#sudo /etc/init.d/netfilter-persistent restart #VARMEMPI TOISELLA TAVALLA PRKL
sudo /usr/sbin/ip6tables-restore /etc/iptables/rules.v6
sudo /usr/sbin/iptables-restore /etc/iptables/rules.v4.180624b 

sudo /etc/init.d/dnsmasq start
sleep 3

#tämän kanssa oli vielä jotain pientä 
sudo adduser --system stubby
sleep 5
sudo /etc/init.d/stubby start
sleep 5

#TODO:varmista tämä kohdan toimivuus
#https://raw.githubusercontent.com/senescent777/project/main/sbin/dhclient-script.new
sudo chmod 0555 /sbin/dhclient*
sudo chown root:root /sbin/dhclient*
sudo mv /sbin/dhclient-script /sbin/dhclient-script.OLD
sudo mv /sbin/dhclient-script.new /sbin/dhclient-script

echo "sudo /sbin/ifup eth0"
