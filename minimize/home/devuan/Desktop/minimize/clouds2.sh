#!/bin/bash
debug=0
distro=""

if [ $# -gt 1 ] ; then 
	if [ -d ~/Desktop/minimize/${2} ] ; then
		distro=${2}
		. ~/Desktop/minimize/${distro}/conf
	fi
else
	echo "${0} <mode> <other_param>";exit
fi

. ~/Desktop/minimize/common_lib.sh

if [ -d ~/Desktop/minimize/${distro} ] && [ -x ~/Desktop/minimize/${distro}/lib.sh ] ; then
	.  ~/Desktop/minimize/${distro}/lib.sh 
else
	echo "FALLBACK"

	smr=$(sudo which rm)
	ipt=$(sudo which iptables)
	slinky=$(sudo which ln)
	spc=$(sudo which cp)
	slinky="${slinky} -s "
	sco=$(sudo which chown)
	scm=$(sudo which chmod)	

	function dqb() {
		[ ${debug} -eq 1 ] && echo ${1}
	}

	function csleep() {
		[ ${debug} -eq 1 ] && sleep ${1}
	}

fi

#konftdstojen ja tablesin käsiuttelyn kanssa pieniä eroavaisuuksia
clouds_pre

case ${1} in 
	0)
		clouds_case0
	;;
	1)
		clouds_case1
	;;
	*)
		echo "MEE HIMAAS LEIKKIMÄHÄN"
	;;
esac

#case'n jälkeinen osuus kummankin distron versiossa käytännössä sama	
clouds_post
