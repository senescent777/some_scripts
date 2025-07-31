#!/bin/bash
if [ -s $0.conf ] ; then
	. $0.conf
else
	exit 67
fi

#simppelimpi näin
sudo ip link set ${iface} down

#HUOM.27725: rules/interfaces/yms tarpeen vain mikäli nettiyhteyttä käyttää
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

#common_lib

function efk() {
	sudo dpkg -i $@
	sudo rm $@
}

#HUOM.18725:välillä jos kokeiltu ajaa init2 ennen generic_x- juttui, niinkin taitaa toimia
q=$(mktemp -d)
sudo cp ${pkgsrc}/*.deb ${q}

	
#parempi samaan aikaan dms ja libdev 
efk ${q}/dmsetup*.deb  ${q}/libdevmapper*.deb
#efk ${q}/libjte2*.deb

#tässä joutuisi vähän säätämään
efk ${q}/lib*.deb

echo "BEFORE TBLZ"
sleep 2

#HUOM.27725:josko hyldynbtäisi/prijausi common_lib.common_tbls() jatqssa
#
##DEBIAN_FRONTEND=noninteractive tämän kanssa jokin juttu?
##if_not_iptables
#x=$(sudo which iptables)
#
#if [ ! -x ${x} ] ; then
#	#DEBIAN_FRONTEND=noninteractive kanssa lottoaminen jatqyy
#	sudo dpkg -i ${q}/iptables_*.deb
#	sudo rm ${q}/iptables_*.deb
#
#	efk ${q}/net*.deb
#
#	#DEBIAN_FRONTEND=noninteractive
#	sudo dpkg -i ${q}/iptables-*.deb
#	sudo rm ${q}/iptables-*.deb
#
#	#deb uig taakse jatqssa
#	echo "after tables"
#	dpkg -l iptables*
#	sleep 2
#fi
##/if_not_iptables
#
##qseeko tässä kohtaa jokin?
#if_not_git
x=$(sudo which git)

if [ ! -x ${x} ] ; then
	efk ${q}/git-man*.deb
	efk ${q}/git*.deb
fi
#/if_not_git

#if_not_grub
x=$(sudo which grub-mkrescue)

if [ ! -x ${x} ] ; then
	#sudo dpkg -i $q/grub*.deb
	#sudo rm ${q}/grub*.deb
	efk ${q}/grub*.deb 
fi
#/if_not_grub

#ao. rivejä ei kannata unmohtaa
#which grub geniso
x=$(sudo which genisoimage)

if [ ! -x ${x} ] ; then
	efk ${q}/geniso*.deb
fi

#which grub xorrisao...
x=$(sudo which xorriso)

if [ ! -x ${x} ] ; then
	efk ${q}/xorriso*.deb
fi

sudo dpkg -i $q/*.deb
sudo rm ${q}/*.deb

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

#sleep 1
#echo "#ei joulukuusia turhanbäite"
#for f in $(find ${basedir} -type f ) ; do sudo chmod a-x ${f} ; done
#for f in $(find ${basedir} -type f -name '*.sh') ; do sudo chmod 0755 ${f} ; done
