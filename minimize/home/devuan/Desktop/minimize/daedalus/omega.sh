#!/bin/bash
d=$(dirname $0)
[ -s ${d}/conf ] && . ${d}/conf
[ -s ~/Desktop/minimize/common_lib.sh ] && . ~/Desktop/minimize/common_lib.sh 

#HUOM.110325: tarvitseekohan tässä noita tiedostoja vetää mukaan, vähemmälläkin pärjäisi

if [ -s ${d}/lib.sh ] ; then
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