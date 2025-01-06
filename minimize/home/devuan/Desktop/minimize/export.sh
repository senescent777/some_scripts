#!/bin/bash
#. ./conf
#
#function parse_opts_1() {
#	case "${1}" in
#		-v|--v)
#			debug=1
#		;;
#		*)
#			archive=${1}
#		;;
#	esac
#}
#
#. ./lib
#
i#f [ $# -gt 0 ] ; then
#	for opt in $@ ; do parse_opts_1 ${opt} ; done
#fi
#
#[ ${debug} -eq 1 ] && echo "part= $part , dir=$dir, archive= $archive"
##exit
#cd /
#
#${som} ${part} ${dir} -o rw
#[ $? -eq 0 ] || exit 1
#sleep 3
#
#[ -f ${dir}/${archive} ] && ${spc} ${dir}/${archive} ${dir}/${archive}.OLD
##[ $? -eq 0 ] || exit 2 #mikähän tässä kusee?
#[ -f /tmp/${archive} ] && ${spc} /tmp/${archive} ${dir}
#
#sleep 3
##jos -T kätevämpi? /sbin tarpeellinen?
#${srat} -uvpf ${dir}/${archive} /opt/bin ~/Desktop/minimize ~/.gnupg /etc/iptables /etc/network/interfaces* /etc/sudoers.d/meshuggah /etc/dhcp/dhclient* /etc/resolv.conf* /sbin/dhclient-*  
#
##gg=$(sudo which gpg)
##if [ -x ${gg} ] ; then
##	if [ -s  ${tgtfile} ] ; then
##		gpg -u tester -sb ${dir}/${archive}
##	fi
##fi
#
#csleep 3
[# ${debug} -eq 1 ] && ls -las ${dir};sleep 5
#sleep 6
#
#${uom} ${part}
#echo $?
#${uom} ${dir}
#cd ~/Desktop/minimize
#mount | grep /dev
#