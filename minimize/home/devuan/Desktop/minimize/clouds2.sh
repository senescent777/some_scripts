#!/bin/bash
debug=0
distro=""
mode=-1

function dqb() {
	[ ${debug} -eq 1 ] && echo ${1}
}

function csleep() {
	[ ${debug} -eq 1 ] && sleep ${1}
}

if [ $# -gt 1 ] ; then
	mode=${1}
 
	if [ -d ~/Desktop/minimize/${2} ] ; then
		distro=${2}
		dqb "asdasdasd.666"
		. ~/Desktop/minimize/${distro}/conf
		csleep 5
	fi
else
	echo "${0} <mode> <other_param>";exit
fi

. ~/Desktop/minimize/common_lib.sh
dqb "mode=${mode}"
dqb "distro=${distro}"
csleep 6

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

fi

#konftdstojen ja tablesin käsiuttelyn kanssa pieniä eroavaisuuksia
clouds_pre

case ${mode} in 
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
