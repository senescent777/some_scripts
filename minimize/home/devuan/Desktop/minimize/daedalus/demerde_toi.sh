#!/bin/sh
#TODO: conf mukaan
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
	mv ./home/devuan/Desktop/minimize/* /home/devuan/Desktop/minimize
fi

sudo chmod 0755 /home/devuan/Desktop/minimize/${distro}
sudo chmod 0755 /home/devuan/Desktop/minimize/${distro}/*.sh
cd /home/devuan/Desktop/minimize
echo "./${distro}/export.sh 0 /tmp/vomit.tar"