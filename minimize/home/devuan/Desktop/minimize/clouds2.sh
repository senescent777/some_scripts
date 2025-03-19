#!/bin/bash
debug=1
distro=""
mode=-1

function dqb() {
	[ ${debug} -eq 1 ] && echo ${1}
}

function csleep() {
	[ ${debug} -eq 1 ] && sleep ${1}
}

#TODO:uudelleennimeäminenm changedns.sh voisiolla sopiva jatkossa

if [ $# -gt 1 ] ; then
	if [ -d ~/Desktop/minimize/${2} ] ; then
		distro=${2}
		dqb "asdasdasd.666"
		. ~/Desktop/minimize/${distro}/conf
		csleep 5
	fi

	mode=${1} #VAIH:mode VÄHITELLEn WTTUUN conf:ista
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

	echo "when in trouble, sudo chmod 0755 ${distro}; sudo chmod  0755 ${distro}/*.sh; sudo chmod 0644 ${distro}/conf may help "
fi

#konftdstojen ja tablesin käsittelyn kanssa pieniä eroavaisuuksia
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
