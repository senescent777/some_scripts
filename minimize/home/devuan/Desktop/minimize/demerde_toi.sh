#!/bin/sh
debug=1

#VAIH:jatkossa common_lib.sh käyttöön
if [ -x ~/Desktop/minimize/common_lib.sh ] ; then
	#TODO:jatkossa dirname, ehkä
	. ~/Desktop/minimize/common_lib.sh
else	
	echo "ALT. LIB"

	#odio=$(which sudo)
	#[ y"${odio}" == "y" ] && exit 665 
	#[ -x ${odio} ] || exit 666
	
	#
	#function dqb() {
	#	[ ${debug} -eq 1 ] && echo ${1}
	#}
	#
	#function csleep() {
	#	[ ${debug} -eq 1 ] && sleep ${1}
	#}
fi

if [ $# -gt 0 ] ; then
	dqb "params_ok"
else
	echo "P.V.HH"
	exit 66
fi

if [ -d ~/Desktop/minimize/${1} ] ; then
	dqb "tgt dir exists"
else
	echo "NO SUCH THING AS  ~/Desktop/minimize/${1} "
	exit 67
fi

tig=$(${odio} which git)	
csleep 1

if [ x"${tig}" == "x" ] ; then
	#sag=$(${odio} which apt-get)
	#shary="${odio} ${sag} --no-install-recommends reinstall --yes "
	#sag_u="${odio} ${sag} update "
	#sag="${odio} ${sag} "
	${shary} git
	[ $? -eq 0 ] || exit 7
fi

csleep 5
tig=$(${odio} which git)

#VAIH:tarkistus että mktemp olemassa
mtk=$(${odio} which mktemp)
if [ z"${mtk}" == "z" ] ; then 
	echo "sudo apt-get install mktemp"
	exit 8
fi

if [ ! -x ${mtk} ] ; then
	echo "sudo apt-get reinstall mktemp"
	exit 9
fi

q=$(mktemp -d)
cd $q

${tig} clone https://github.com/senescent777/some_scripts
cd some_scripts/minimize

if [ -d /home/devuan/Desktop/minimize ] ; then
	#HUOM. pitänee jyrätä minimize-hak. ensin
	dqb "mv ./home/devuan/Desktop/minimize/* ~/Desktop/minimize"
fi

sudo chmod 0755 ~/Desktop/minimize/${1}
sudo chmod 0755 ~/Desktop/minimize/${1}/*.sh
cd ~/Desktop/minimize
echo "./${1}/export.sh 0 /tmp/vomit.tar"