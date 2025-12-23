#!/bin/bash

if [ -s $0.conf ] ; then
	. $0.conf
else
	exit 67
fi

echo "ko.1"
distro=$(cat /etc/devuan_version)
[ -v CONF_basedir ] || exit 1
[ -d ${CONF_basedir} ] || exit 2
echo "base= ${CONF_basedir}"
sleep 1

#simppelimpi näin
[ -v CONF_iface ] && sudo ip link set ${CONF_iface} down

function jord() {
	#231225:oikeudet olisi basedir/e alla hyvä olla järkevät, init1.sh saa nyt hoitaa
	echo "jord"
	sleep 1
	#TODO:lähteen oikeuksien/omistajien pakotus?
	sudo cp -a ${CONF_basedir}/etc/* /etc

	#HUOM.27725: rules/interfaces/yms tarpeen vain mikäli nettiyhteyttä käyttää
	#[ -d /etc/iptables ] || sudo mkdir /etc/iptables
	#
	#if [ -s ${CONF_basedir}/rules.v4.0 ] ; then
	#	sudo cp ${CONF_basedir}/rules.v4.0 /etc/iptables #/rules.v4
	#	sudo cp ${CONF_basedir}/rules.v4.0 /etc/iptables/rules.v4
	#fi
	#
	#[ -s ${CONF_basedir}/resolv.conf.0 ] && sudo cp ${CONF_basedir}/resolv.conf.0 /etc
	#
	#if [ -s ${CONF_basedir}/etc/network/interfaces ] ; then
	#	[ -f /etc/network/interfaces ] && sudo mv /etc/network/interfaces /etc/network/interfaces.$(date +%F)
	#	sudo cp ${CONF_basedir}/interfaces /etc/network/interfaces.${distro}
	#	sudo chmod 0644 /etc/network/interfaces.${distro} 
	#	sudo ln -s /etc/network/interfaces.${distro} /etc/network/interfaces
	#fi
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

[ -v CONF_pkgsrc ] || exit 22
[ -d ${CONF_pkgsrc} ] || exit 23

#HUOM.211225:jos hoitaa tietyt asiat g_doit.sh:lla ni ei tässä skriptissä tartte ninn paljoa säätää
function aqua() {
	echo "aqua"
	sleep 1

	sudo apt --fix-broken install

	local q
	q=$(mktemp -d)
	sudo cp ${CONF_pkgsrc}/*.deb ${q}
	[ $? -eq 0 ] || exit 4

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
#olisikohan tuolle jo 211225 mennessä tehty jotain?

	echo "GENISOIMAGE?"
	which genisoimage
	sleep 6

	#common_lib sisältäisi sen listan että sikäli vähän turha
	if [ -v CONF_part076 ] ; then
		sudo apt-get remove --purge --yes ${CONF_part076}
		#python3-cups ntp* #sharyp from common_lib
	fi

	sudo apt autoremove
	sudo apt --fix-broken install #tähän vai heti grub-as jälk?
	sudo which iptables-restore
	sudo iptables-restore /etc/iptables/rules.v4.0

	sleep 2
	echo "AFTER iptables-restore "
}

aqua
[ -v CONF_ue ] || exit 34
[ -v CONF_ue ] || exit 35

function ignis() {
	echo "ignis"
	sleep 1

	local tig
	local c

	#uutena tää git-tark
	tig=$(sudo which git)
	[ -z "${tig}" ] && exit 68
	[ -x ${tig} ] || exit 69

	#-z ? 
	[ -v CONF_ue ] && ${tig} config --global user.email ${CONF_ue}
	[ -v CONF_un ] && ${tig} config --global user.name ${CONF_un}
	echo "tg1,1,dibe"

	#varmaan olisi hyvä testata tämä blokki josqs
	if [ -s ${CONF_basedir}/.gitignore ] ; then
		echo "not touching ${CONF_basedir}/.gitignore this time"
	else
		echo "init1 may have done this already"
	fi

	#sudo chown $(whoami):$(whoami) ${CONF_basedir}/.gitignore
	#sudo chmod 0644 ${CONF_basedir}/.gitignore
}

ignis

#sleep 1
#echo "#ei joulukuusia turhanbäite"
#for f in $(find ${CONF_basedir} -type f ) ; do sudo chmod a-x ${f} ; done
#for f in $(find ${CONF_basedir} -type f -name '*.sh') ; do sudo chmod 0755 ${f} ; done

[ -v CONF_dir ] || exit 44
[ -d ${CONF_dir} ] || exit 45

#121225:pitäisikö tässä niitä lokaaliasetuksia sorkkia? vai ulkoistus g_doit ?
function luft() {
	echo "luft"
	sleep 1

	local c4
	local t

	c4=0
	c4=$(grep ${CONF_dir} /etc/fstab | wc -l)
	t=/dev/disk/by-uuid/${CONF_part0}

	#TODO:jos cat:illa jatkossa? , cat $some_file >> /e/fstab tai miten se /e/a/s-list-jekku?
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

	#jos ei tartte mountata niin sitten ei knffissa muuttujaa aseta
	if [ -v CONF_basept2tgt ] && [ -v CONF_basept2src ] ; then
		#/proc/mounts voisi grepta
		[ -d ${CONF_basept2tgt} ] || sudo mkdir ${CONF_basept2tgt}

		#jnkn ehdon taa tuo mount? riittääkö -b ehdoksi?
		[ -b /dev/${CONF_basept2src} ] && sudo mount /dev/${CONF_basept2src} ${CONF_basept2tgt}
	fi
}

luft

function f5th() {
	local p
	local c

	somefile=$(mktemp)
	touch ${somefile}

	for c in ${CONF_aa} ; do 
		#mangle_s()
		p=$(sha256sum ${c} | cut -d ' ' -f 1 | tr -dc a-f0-9)
		echo "$(whoami) localhost=NOPASSWD: sha256: ${p} ${c}" >> ${somefile} 
	done

	#TARKKUUTTA PRKL

	#voi miettiä vielä tätä, jos basen alla asettaa omistajudet ja oikeudet sopivasti, ei tarttisi sudottaa
	for c in ${CONF_ab} ; do
		echo "$(whoami) localhost=NOPASSWD: ${c} ${CONF_basept2tgt}/*" >> ${somefile}
	done 

	cat ${somefile}
	sudo chown 0:0 ${somefile}
	sudo chmod 0440 ${somefile}
	sudo mv ${somefile} /etc/sudoers.d 

	#TODO:/.chroot luonti ja seuraukset $CONF_basedir alaisille skripteille
	#TODO:init1.sh ja init2.sh konfiguraation koordinointi, yhjteiset osat yhteiseen tdstoon 
}

f5th
#TODO:se /.chroot luonti jonnekin, esim. stage0_backend.bash...
