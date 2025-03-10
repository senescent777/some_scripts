#!/bin/sh
debug=1
odio=$(which sudo)
[ y"${odio}" == "y" ] && exit 665 
[ -x ${odio} ] || exit 666
#jatkossa common_lib.sh käyttöön

function dqb() {
	[ ${debug} -eq 1 ] && echo ${1}
}

function csleep() {
	[ ${debug} -eq 1 ] && sleep ${1}
}

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
	sag=$(${odio} which apt-get)
	shary="${odio} ${sag} --no-install-recommends reinstall --yes "
	sag_u="${odio} ${sag} update "
	sag="${odio} ${sag} "
	${shary} git
	[ $? -eq 0 ] || exit 7
fi

csleep 5
tig=$(${odio} which git)

q=$(mktemp -d)
cd $q

${tig} clone https://github.com/senescent777/some_scripts
cd some_scripts/minimize

if [ -d /home/devuan/Desktop/minimize ] ; then
	mv ./home/devuan/Desktop/minimize/* ~/Desktop/minimize
fi

sudo chmod 0755 ~/Desktop/minimize/${1}
sudo chmod 0755 ~/Desktop/minimize/${1}/*.sh
cd ~/Desktop/minimize
echo "./${1}/export.sh 0 /tmp/vomit.tar"