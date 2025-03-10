#!/bin/sh
debug=1

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

tig=$(sudo which git)	
csleep 1

if [ x"${tig}" == "x" ] ; then
	${shary} git
	[ $? -eq 0 ] || exit 7
fi

csleep 5
tig=$(sudo which git)

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