#!/bin/bash

if [ -s $0.conf ] ; then
	. $0.conf
else
	exit 67
fi

echo "ko.1"
distro=$(cat /etc/devuan_version)
[ -v CONF_basedir ] || exit 1
echo "base= ${CONF_basedir}"
sleep 1

#simppelimpi näin
sudo ip link set ${CONF_iface} down

function jord() {
	echo "jord"
	sleep 1

	#HUOM.27725: rules/interfaces/yms tarpeen vain mikäli nettiyhteyttä käyttää
	[ -d /etc/iptables ] || sudo mkdir /etc/iptables

	if [ -s ${CONF_basedir}/rules.v4.0 ] ; then
		sudo cp ${CONF_basedir}/rules.v4.0 /etc/iptables #/rules.v4
		sudo cp ${CONF_basedir}/rules.v4.0 /etc/iptables/rules.v4
	fi

	[ -s ${CONF_basedir}/resolv.conf.0 ] && sudo cp ${CONF_basedir}/resolv.conf.0 /etc

	if [ -s ${CONF_basedir}/interfaces ] ; then
		[ -f /etc/network/interfaces ] && sudo mv /etc/network/interfaces /etc/network/interfaces.$(date +%F)
		sudo cp ${CONF_basedir}/interfaces /etc/network/interfaces.${distro}
		sudo chmod 0644 /etc/network/interfaces.${distro} 
		sudo ln -s /etc/network/interfaces.${distro} /etc/network/interfaces
	fi
}

jord

#common_lib
function efk() {
	sudo dpkg -i $@
	sudo rm $@
}

function ekf() {
	echo "EKF (${1})"
	sleep 2
	local t=$(sudo which ${1})

	if [ ! -x $t} ] ; then
		efk ${q}/${1}*
	fi
}

[ -v CONF_pkgsrc ] || exit 2

function aqua() {
	echo "aqua"
	sleep 1

	sudo apt --fix-broken install

	local q
	q=$(mktemp -d)
	sudo cp ${CONF_pkgsrc}/*.deb ${q}
	
	#parempi samaan aikaan dms ja libdev 
	efk ${q}/dmsetup*.deb  ${q}/libdevmapper*.deb
	#efk ${q}/libjte2*.deb
	efk ${q}/lib*.deb

	echo "BEFORE TBLZ"
	sleep 2

	#onbkohan trarpeellinen kikkailu?
	for p in ${CONF_accept_pkgs2} ; do ekf ${p} ; done

	#avaimien instauksen voi hoitaa vaikka import2:sella parillakin taballa
	sudo dpkg -i $q/*.deb
	sudo rm ${q}/*.deb


#	The following packages have unmet dependencies:
# grub-efi-amd64 : Depends: grub-common (= 2.06-13) but 2.06-13+deb12u1 is installed

	echo "GENISOIMAGE?"
	which genisoimage
	sleep 6

	#common_lib sisältäisi sen listan että sikäli vähän turha
	if [ -v CONF_part076 ] ; then
		sudo apt-get remove --purge --yes CONF_part076
		#python3-cups ntp* #sharyp from common_lib
	fi

	sudo apt autoremove
	sudo which iptables-restore
	sudo iptables-restore /etc/iptables/rules.v4.0

	sleep 2
	echo "AFTER iptables-restore "
}

aqua
[ -v CONF_ue ] || exit 3

function ignis() {
	echo "ignis"
	sleep 1

	local tig
	local c

	#uutena tää git-tark
	tig=$(sudo which git)
	[ x"${tig}" == "x" ] && exit 68
	[ -x${tig} ] || exit 69

	#git olemassaolo pitäisi testata ennernq etenee pidemmälle
	[ -v CONF_ue ] && ${tig} config --global user.email ${CONF_ue}
	[ -v CONF_un ] && ${tig} config --global user.name ${CONF_un}
	echo "tg1,1,dibe"

	[ -s ${CONF_basedir}/.gitignore ] || touch ${CONF_basedir}/.gitignore
	#muitakin tuonne ignoree n voisi laittaa? (VAIH)
	c=$(grep $0.conf ${CONF_basedir}/.gitignore | wc -l)
	[ ${c} -lt 1 ] && echo $0.conf >> ${CONF_basedir}/.gitignore

	c=$(grep .deb ${CONF_basedir}/.gitignore | wc -l)
	[ ${c} -lt 1 ] && echo "*.deb" >> ${CONF_basedir}/.gitignore
}

ignis

#sleep 1
#echo "#ei joulukuusia turhanbäite"
#for f in $(find ${CONF_basedir} -type f ) ; do sudo chmod a-x ${f} ; done
#for f in $(find ${CONF_basedir} -type f -name '*.sh') ; do sudo chmod 0755 ${f} ; done

[ -v CONF_dir ] || exit 4

#121225:pitäisikö tässä niitä lokaaliasetuksia sorkkia? vai ulkoistus g_doit ?
function luft() {
	#VAIH:fstabiin se tikku jo tässä? ei tarttisi g_doit ajaa sen takia
	echo "luft"
	sleep 1

	local c4
	local t

	c4=0
	c4=$(grep ${CONF_dir} /etc/fstab | wc -l)
	t=/dev/disk/by-uuid/${CONF_part0}

	if [ ${c4} -gt 0 ] ; then
		echo "f-stab 0k"
	else
		if [ -b ${t} ] ; then
			sudo chmod a+w /etc/fstab
			sleep 1

			sudo echo " ${t} ${CONF_dir} auto nosuid,noexec,noauto,user 0 2" >> /etc/fstab
			sleep 1

			sudo chmod a-w /etc/fstab
			sleep 1
			ls -las /etc/fstab
		fi
	fi

#TODO:joutaisi miettiä, tilapäisille tdstoille tarkoitettua osiota ei kannattane käyttää pitkäaikaiseen säilytykseen niinqu
#	#tarpeellinen? vissiin
#	if [ -v CONF_basept2tgt ] && [ -v CONF_basept2src ] ; then
#		#/proc/mounts voisi grepta
#		[ -d ${CONF_basept2tgt} ] || sudo mkdir ${CONF_basept2tgt}
#
#		#jnkn ehdon taa tuo mount?
#		[ -b /dev/${CONF_basept2src} ] && sudo mount /dev/${CONF_basept2src} ${CONF_basept2tgt}
#	fi
}

luft
