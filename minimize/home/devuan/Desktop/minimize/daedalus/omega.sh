#!/bin/bash
d=$(dirname $0)

if [ -s ${d}/conf ] && [ -s ${d}/lib.sh ] ; then
	. ${d}/conf
	. ${d}/lib.sh
else
	echo "TO CONTINUE FURTHER IS POINTLESS, ESSENTIAL FILES MISSING"
	exit 111	
fi

#HUOM.260215: ainakin onnistuu loggaamaan takaisin sisään tämän ajon jälkeen

${smr} /etc/sudoers.d/live
sudo usermod -G devuan,cdrom,floppy,audio,dip,video,plugdev,netdev devuan
csleep 5
${whack} xfce* 
