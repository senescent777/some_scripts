#!/bin/bash
d=$(dirname $0)
#TODO:conf ja common_lib
if [ -s ${d}/conf ] && [ -s ${d}/lib.sh ] ; then
	. ${d}/conf
	. ${d}/lib.sh
else
	echo "TO CONTINUE FURTHER IS POINTLESS, ESSENTIAL FILES MISSING"
	exit 111	
fi

#HUOM.260125: vaikuttaisi toimivan jnkn verran, ainakin sisään loggaus onnistuu
#TODO: testaus uudemman kerrab

${smr} /etc/sudoers.d/live #myös shred keksitty
sudo usermod -G devuan,cdrom,floppy,audio,dip,video,plugdev,netdev devuan
csleep 5
${whack} xfce4-session