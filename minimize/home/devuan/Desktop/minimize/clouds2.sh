#!/bin/bash
#d=$(dirname $0)
#debug=0
#
#if [ $# -gt 2 ] ; then #TODO:kehittelyä, kts export2 ja import2 
#	if [ -d ~/Desktop/minimize/${3} ] ; then
#		distro=${3}
#		. ~/Desktop/minimize/${3}/conf
#	fi
#fi
#
#. ~/Desktop/minimize/common_lib.sh
#
##HUOM.120325.x:hmiston olemassaolokin olisi hyvä varmistaa
##HUOM.120325.y:miel $distro kuin $3 jatkossa
#if [ -x ~/Desktop/minimize/${3}/lib.sh ] ; then
#	.  ~/Desktop/minimize/${3}/lib.sh 
#else
#	smr=$(sudo which rm)
#	ipt=$(sudo which iptables)
#	slinky=$(sudo which ln)
#	spc=$(sudo which cp)
#	slinky="${slinky} -s "
#	sco=$(sudo which chown)
#	scm=$(sudo which chmod)	
#
#	function dqb() {
#		[ ${debug} -eq 1 ] && echo ${1}
#	}
#
#	function csleep() {
#		[ ${debug} -eq 1 ] && sleep ${1}
#	}
#
#fi
#
#function tod_dda() { 
#	${ipt} -A b -p tcp --sport 853 -s ${1} -j c
#       ${ipt} -A e -p tcp --dport 853 -d ${1} -j f
#}
#
#function dda_snd() {
#	${ipt} -A b -p udp -m udp -s ${1} --sport 53 -j ACCEPT 
#	${ipt} -A e -p udp -m udp -d ${1} --dport 53 -j ACCEPT
#}

#konftdstojen ja tablesin käsiuttelyn kanssa pieniä eroavaisuuksia
echo "lib.clouds_pre() (TODO)"

case ${1} in 
	0)
		echo "lib.case0 (TODO)"
	;;
	1)
		echo "lib.case1 (TODO)"
	;;
	*)
		echo "MEE HIMAAS LEIKKIMÄHÄN"
	;;
esac

#case'n jälkeinen osuus kummankin distron versiossa käytännössä sama	
echo "common_lib.clouds_post() (TODO)"
