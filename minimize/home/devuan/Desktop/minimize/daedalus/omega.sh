#!/bin/bash
d=$(dirname $0)

if [ -s ${d}/conf ] && [ -s ${d}/lib.sh ] ; then
	. ${d}/conf
	. ${d}/lib.sh
else
	echo "TO CONTINUE FURTHER IS POINTLESS, ESSENTIAL FILES MISSING"
	exit 111	
fi

${smr} /etc/sudoers.d/live
#TODO:kjän ryhistä vielä sudo pois
csleep 5
${whack} xfce* 
