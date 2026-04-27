#!/bin/bash
. ./setup0.conf

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
sleep 10

odio=$(which sudo)
sag=$(${odio} which apt-get)
#sd0=$(${odio} which dpkg)
#sdi="${odio} ${sd0} -i "
#sip=$(${odio} which ip)
#sip="${odio} ${sip} "
#sa=$(${odio} which apt)
#fib="${odio} ${sa} --fix-broken install "
#sharpy="${odio} ${sag} remove --purge --yes "
#svm=$(${odio} which mv)
#svm="${odio} ${svm} "

sco="${odio} chown"
scm="${odio} chmod"
spc="${odio} cp"
smr="${odio} rm"

#simppelimpi näin
[ -v CONF_iface ] && ${odio} ip link set ${CONF_iface} down

function jord() {
	#231225:oikeudet olisi basedir/e alla hyvä olla järkevät, init1.sh saa nyt hoitaa
	[ -z "${1}" ] && exit 666
	[ -d ${1} ] || exit 666
	
	echo "jord"
	sleep 1

	${sco} -R 0:0  ${1}/etc	
	${scm} -R 0444 ${1}/etc	
	${spc} -a ${1}/etc/* /etc
}

jord ${CONF_basedir}

#common_lib
function efk() {
	${odio} dpkg -i $@
	${smr} $@
}

function ekf() {
	echo "EKF (${1})"
	sleep 2
	local t=$(${odio} which ${1})

	if [ -z "${t}" ] || [ ! -x ${t} ] ; then
		echo "jfk"
		efk ${q}/${1}*
	fi
}

[ -v CONF_pkgsrc ] || exit 22
[ -d ${CONF_pkgsrc} ] || exit 23

#HUOM.211225:jos hoitaa tietyt asiat g_doit.sh:lla ni ei tässä skriptissä tartte ninn paljoa säätää
function aqua() {
	echo "aqua"
	sleep 1

	${odio} apt --fix-broken install

	local q
	q=$(mktemp -d)
	${spc} ${CONF_pkgsrc}/*.deb ${q}
	[ $? -eq 0 ] || exit 4

	#parempi samaan aikaan dms ja libdev 
	efk ${q}/dmsetup*.deb  ${q}/libdevmapper*.deb
	#efk ${q}/libjte2*.deb
	efk ${q}/lib*.deb

	echo "BEFORE TBLZ"
	sleep 2

	#onbkohan trarpeellinen kikkailu?
	for p in ${CONF_accept_pkgs2} ; do ekf ${p} ; done
	sleep 10

	#avaimien instauksen voi hoitaa vaikka import2:sella parillakin taballa
	${odio} dpkg -i ${q}/*.deb
	${smr} ${q}/*.deb

#	The following packages have unmet dependencies:
# grub-efi-amd64 : Depends: grub-common (= 2.06-13) but 2.06-13+deb12u1 is installed
#olisikohan tuolle jo 211225 mennessä tehty jotain?

	echo "GENISOIMAGE?"
	which genisoimage
	sleep 6

	#common_lib sisältää tuon samaisen listan että sikäli vähän turha
	if [ -v CONF_part076 ] ; then
		${odio} apt-get remove --purge --yes ${CONF_part076}
		#python3-cups ntp* #sharyp from common_lib
	fi

	${odio} apt autoremove
	${odio} apt --fix-broken install #tähän vai heti grub-as jälk?
	${odio} which iptables-restore
	${odio} iptables-restore /etc/iptables/rules.v4.0

	sleep 2
	echo "AFTER iptables-restore "
}

aqua
[ -v CONF_ue ] || exit 34
[ -v CONF_un ] || exit 35

function ignis() {
	echo "ignis"
	sleep 1

	local tig
	#local c

	#uutena tää git-tark
	tig=$(${odio} which git)
	[ -z "${tig}" ] && exit 68
	[ -x ${tig} ] || exit 69

	[ -z "${CONF_ue}" ] || ${tig} config --global user.email ${CONF_ue}
	[ -z "${CONF_un}" ] || ${tig} config --global user.name ${CONF_un}
	echo "tg1,1,dibe"

	#varmaan olisi hyvä testata tämä blokki josqs
	if [ -s ${CONF_basedir}/.gitignore ] ; then
		echo "not touching ${CONF_basedir}/.gitignore this time"
	else
		echo "setup1 may have done this already"
	fi
}

ignis

[ -v CONF_dir ] || exit 44
[ -d ${CONF_dir} ] || exit 45

#lokaalien sorkinta lienee ulkoistettu 04/26 mennessä
function luft() {
	echo "luft"
	sleep 1

	local c4
	c4=0

	if [ -v CONF_dir ] ; then	
		c4=$(grep ${CONF_dir} /etc/fstab | wc -l)
	else
		echo "SMTHING IS WRONG WITH CONFIG, WILL NOT CONTINUE"
		exit 665
	fi

	if [ ${c4} -gt 0 ] ; then
		echo "f-stab 0k"
	else
		${scm} a+w /etc/fstab #TODO:fasdfasd/reqwreqw
		sleep 1
		${odio} cat /etc/fstab.tmp >> /etc/fstab
		sleep 1	
		${scm} a-wx /etc/fstab*
		${sco} 0:0 /etc/fstab*
	fi

	#TODO?:joutaisi miettiä, tilapäisille tdstoille tarkoitettua osiota ei kannattane käyttää pitkäaikaiseen säilytykseen niinqu

	if [ -v CONF_basept2tgt ] ; then
		#/proc/mounts voisi grepAta
		[ -d ${CONF_basept2tgt} ] || ${odio} mkdir ${CONF_basept2tgt}
		
		${odio} mount ${CONF_basept2tgt}
		#TODO:tai sitten mount -a + vastaava muutos fstab.tmp:iin , saisi samalla sen oman osion .iso-tdstoille
		#...vielä tarpeellinen 040426?
	else
		echo "SMTHING IS WRONG WITH CONFIG, WILL NOT CONTINUE"
		exit 666
	fi
}

luft

#HUOM.241225:/e/s.d alle tehdyn tdston syntaksi oli jo ok, omegaa ajeltu testiksi
#... vähän saattaa joutua vielä viilaamaan sisältöä
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

	#voi miettiä vielä tätä, jos basen alla asettaa omistajudet ja oikeudet sopivasti, ei tarttisi ${odio}ttaa
	for c in ${CONF_ab} ; do
		echo "$(whoami) localhost=NOPASSWD: ${c} ${CONF_basept2tgt}/*" >> ${somefile}
	done 

	cat ${somefile}
	${sco} 0:0 ${somefile}
	${scm} 0440 ${somefile}
	${odio} mv ${somefile} /etc/sudoers.d 

	#/.chroot luonti ja seuraukset $CONF_basedir alaisille skripteille? miksi?
	#yhteinen konfiguraatio jo siirretty -> setup0 ?
}

f5th
#se /.chroot luonti jonnekin?, esim. stage0_backend.bash...
echo "kutl v | g_doit -v 1 ?"
echo "TODO:SE &e&s.d/live HUKKAAMINEN KOKEEKSI"
