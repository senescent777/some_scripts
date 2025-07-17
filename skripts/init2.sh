#!/bin/bash
if [ -s $0.conf ] ; then
	. $0.conf
else
	exit 67
fi

distro=$(cat /etc/devuan_version)
[ -d /etc/iptables ] || sudo mkdir /etc/iptables

if [ -s ${basedir}/rules.v4.0 ] ; then
	sudo cp ${basedir}/rules.v4.0 /etc/iptables #/rules.v4
	sudo cp ${basedir}/rules.v4.0 /etc/iptables/rules.v4
fi

[ -s ${basedir}/resolv.conf.0 ] && sudo cp ${basedir}/resolv.conf.0 /etc

if [ -s ${basedir}/interfaces ] ; then
	[ -f /etc/network/interfaces ] && sudo mv /etc/network/interfaces /etc/network/interfaces.$(date +%F)
	sudo cp ${basedir}/interfaces /etc/network/interfaces.${distro}
	sudo chmod 0644 /etc/network/interfaces.${distro} 
	sudo ln -s /etc/network/interfaces.${distro} /etc/network/interfaces
fi

c=$(ls ${pkgsrc}/ip*.deb | wc -l)

function efk() {
	sudo dpkg -i $@
	sudo rm $@
}

if [ ${c} -gt 0 ] ; then
	q=$(mktemp -d)
	sudo cp ${pkgsrc}/*.deb ${q}
	
	#parempi samaan aikaan dms ja libdev 
	efk ${q}/dmsetup*.deb  ${q}/libdevmapper*.deb
	#efk ${q}/libjte2*.deb

	sudo dpkg -i ${q}/lib*.deb
	sudo rm ${q}/lib*.deb

	#HUOM.17725:josqo lib-juttujen jälkeen pak as vain tarvittaessa, which...
	echo "BEFORE TBLZ"
	sleep 2

	#DEBIAN_FRONTEND=noninteractive tämän kanssa jokin juttu?
	sudo dpkg -i ${q}/iptables_*.deb
	sudo rm ${q}/iptables_*.deb

	sudo dpkg -i ${q}/net*.deb
	sudo rm ${q}/net*.deb

	#tähän kai uskaltaa laittaa frontend takaisinb
	sudo DEBIAN_FRONTEND=noninteractive dpkg -i ${q}/iptables-*.deb
	sudo rm ${q}/iptables-*.deb

	#deb uig taakse jatqssa
	echo "after tables"
	dpkg -l iptables*
	sleep 2

	#qseeko tässä kohtaa jokin?
	#which git,,,
	sudo dpkg -i $q/git-man*.deb
	sudo rm ${q}/git-man*.deb

	sudo dpkg -i $q/git*.deb
	sudo rm ${q}/git*.deb

	#which grub-mkimage
	sudo dpkg -i $q/grub*.deb
	sudo rm ${q}/grub*.deb

	#ao. rivejä ei kannata unmohtaa
	#which grub geniso
	#which grub xorrisao...
	sudo dpkg -i $q/*.deb
	sudo rm ${q}/*.deb
else
	sudo dpkg -i ${pkgsrc}/*.deb
fi

echo "GENISOIMAGE?"
which genisoimage
sleep 6

#pois kommenteista 14725, takaisin jos qsee
sudo apt-get remove --purge --yes python3-cups ntp* #sharyp from common_lib
sudo apt autoremove
sudo which iptables-restore
sudo iptables-restore /etc/iptables/rules.v4.0
sleep 2
echo "AFTER iptables-restore "

#uutena tää git-tark
tig=$(sudo which git)
[ x"${tig}" == "x" ] && exit 68
[ -x${tig} ] || exit 69

#git olemassaolo pitäisi testata ennernq etenee pidemmälle
[ -v ue ] && ${tig} config --global user.email ${ue}
[ -v un ] && ${tig} config --global user.name ${un}
echo "tg1,1,dibe"

[ -s ${basedir}/.gitignore ] || touch ${basedir}/.gitignore
c=$(grep $0.conf ${basedir}/.gitignore | wc -l)
[ ${c} -lt 1 ] && echo $0.conf >> ${basedir}/.gitignore

sleep 1
echo "#ei joulukuusia turhanbäite"
for f in $(find ${basedir} -type f ) ; do sudo chmod a-x ${f} ; done
for f in $(find ${basedir} -type f -name '*.sh') ; do sudo chmod 0755 ${f} ; done
