#!/bin/bash
d=$(dirname $0)

if [ -s ${d}/conf ] && [ -s ${d}/lib.sh ] ; then
	. ${d}/conf
	. ${d}/lib.sh
else
	echo "TO CONTINUE FURTHER IS POINTLESS, ESSENTIAL FILES MISSING"
	exit 111	
fi

#260125: vaikuttaisi toimivan jnkn verran, ainakin sisään loggaus onnistuu

${smr} /etc/sudoers.d/live
sudo usermod -G devuan,cdrom,floppy,audio,dip,video,plugdev,netdev devuan
csleep 5
${whack} xfce* 
#sössön sössön stna