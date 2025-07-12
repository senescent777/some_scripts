#!/bin/bash
if [ -s $0.conf ] ; then
	. $0.conf
else
	exit 67
fi

distro=$(cat /etc/devuan_version)
[ -d /etc/iptables ] || sudo mkdir /etc/iptables
[ -s ${basedir}/rules.v4.0 ] && sudo cp ${basedir}/rules.v4.0 /etc/iptables/rules.v4

if [ -s ${basedir}/interfaces ] ; then
	[ -f /etc/network/interfaces ] && sudo mv /etc/network/interfaces /etc/network/interfaces.$(date +%F)
	sudo cp ${basedir}/interfaces /etc/network/interfaces.${distro}
	sudo chmod 0644 /etc/network/interfaces.${distro} 
	sudo ln -s /etc/network/interfaces.${distro} /etc/network/interfaces
fi

c=$(ls ${pkgsrc}/ip*.deb | wc -l)
#common_lib.part3() ... joutuu ehkä jo järjestyksen kanssa säätämään, iptables-jutut...

if [ ${c} -gt 0 ] ; then
	sudo dpkg -i ${pkgsrc}/lib*.deb
	sudo dpkg -i ${pkgsrc}/iptables_*.deb
	sudo dpkg -i ${pkgsrc}/iptables-*.deb

	#fiksumpikin tapa varmaan olisi, nyt näin
	for f in $(find ${pkgsrc} -type f -name '*.deb' | grep -v 'lib' | grep -v 'ip') ; do
		sudo dpkg -i ${f}	
	done
else
	sudo dpkg -i ${pkgsrc}/*.deb
fi

#uutena tää git-tark
tig=$(sudo which git)
[ x"${tig}" == "x" ] && exit 68
[ -x${tig} ] || exit 69

#git olemassaolo pitäisi testata ennernq etenee pidemmälle
[ -v ue ] && ${tig} config --global user.email ${ue}
[ -v un ] && ${tig} config --global user.name ${un}

[ -s ${basedir}/.gitignore ] || touch ${basedir}/.gitignore
c=$(grep $0.conf ${basedir}/.gitignore | wc -l)
[ ${c} -lt 1 ] && echo $0.conf >> ${basedir}/.gitignore