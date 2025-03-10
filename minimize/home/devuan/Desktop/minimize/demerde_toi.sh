#!/bin/bash
#TODO: KOITA NYT SAATANAN TONTTU MUISTAA TUO BASH ALKUUN!!!!!
debug=1

if [ -x  ~/Desktop/minimize/common_lib.sh ] ; then
	echo ". ~/Desktop/minimize/common_lib.sh"
fi
#tästä jnkn verran eteenpäin olisi tarkoitus olla else-blokissa jatkossa
odio=$(which sudo)
[ y"${odio}" == "y" ] && exit 65
[ -x ${odio} ] || exit 66

tig=$(sudo which git)
#if [ x"${tig}" == "x" ] ; then
#	echo "sudo apt-get install git"
#	exit 7
#fi

mkt=$(which mktemp)
if [ x"${mkt}" == "x" ] ; then
	echo "sudo apt-get install mktemp"
	exit 7
fi

function dqb() {
	[ ${debug} -eq 1 ] && echo ${1}
}

function csleep() {
	[ ${debug} -eq 1 ] && sleep ${1}
}
#fi

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

echo "q=\$(${mkt} -d)"
echo "cd \$q"

echo "${tig} clone https://github.com/senescent777/some_scripts"
echo "cd some_scripts/minimize"

if [ -d /home/devuan/Desktop/minimize ] ; then
	#HUOM. pitänee jyrätä minimize-hak. ensin
	dqb "mv ./home/devuan/Desktop/minimize/* ~/Desktop/minimize"
fi

sudo chmod 0755 ~/Desktop/minimize/${1}
sudo chmod 0755 ~/Desktop/minimize/${1}/*.sh

echo "cd ~/Desktop/minimize"
echo "./${1}/export.sh 0 /tmp/vomit.tar"