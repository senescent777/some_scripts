#!/bin/bash
. ./conf
#TODO:lib käyttöön?
#TODO:tuplavarmistus että validi /e/n/i tulee mukaan
function parse_opts_1() {
	case "${1}" in
		-v|--v)
			debug=1
		;;
		*)
			archive=${1}
		;;
	esac
}

if [ $# -gt 0 ] ; then
	for opt in $@ ; do parse_opts_1 $opt ; done
fi

[ ${debug} -eq 1 ] && echo "part= $part , dir=$dir, archive= $archive"
#exit
cd /
sudo mount $part $dir -o rw
[ $? -eq 0 ] || exit 1
sleep 3

[ -f $dir/$archive ] && sudo cp $dir/$archive $dir/$archive.OLD
[ $? -eq 0 ] || exit 2
[ -f /tmp/archive ] && sudo cp /tmp/$archive $dir

sleep 3
#jos -T kätevämpi?
sudo tar -uvpf $dir/$archive /opt/bin ~/Desktop/minimize /etc/iptables /etc/network/interfaces* /etc/sudoers.d/meshuggah /etc/dhcp/dhclient* /etc/resolv.conf* /sbin/dhclient-*  
[ ${debug} -eq 1 ] && sleep 3
[ ${debug} -eq 1 ] && ls -las $dir;sleep 5
sleep 6

sudo umount $part
echo $?
sudo umount $dir
cd ~/Desktop/minimize
mount | grep /dev
