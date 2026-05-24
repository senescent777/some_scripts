#!/bin/bash
. ./setup0.conf

if [ -s $0.conf ] ; then
	. $0.conf
else
	exit 67
fi

#sktiåptds/common_funcs, hyldyntäisikö?
echo "ko.1"
distro=$(cat /etc/devuan_version)
[ -v CONF_basedir ] || exit 1
[ -d ${CONF_basedir} ] || exit 2

function dqb() {
	[ ${debug} -eq 1 ] && echo ${1}
}

function csleep() {
	[ ${debug} -eq 1 ] && sleep ${1}
}

dqb "base= ${CONF_basedir}"
csleep 5

odio=$(which sudo)
sag=$(${odio} which apt-get)
#sd0=$(${odio} which dpkg)
#sdi="${odio} ${sd0} -i "
#sip=$(${odio} which ip)
#sip="${odio} ${sip} "
#sa=$(${odio} which apt)
#fib="${odio} ${sa} --fix-broken install "
#sharpy="${odio} ${sag} remove --purge --yes "
svm=$(${odio} which mv)
svm="${odio} ${svm} "

sco="${odio} chown"
scm="${odio} chmod"
spc="${odio} cp"
smr="${odio} rm"

#simppelimpi näin
[ -v CONF_iface ] && ${odio} ip link set ${CONF_iface} down

function reqwreqw() {
	[ -z "${1}" ] && exit 99
	[ -f ${1} ] || exit 100
	csleep 1
	${sco} 0:0 ${1}
	${scm} a-w ${1}
}

function fasdfasd() {
	[ -z "${1}" ] && exit 99

	csleep 1
	${odio} touch ${1}
	${sco} $(whoami):$(whoami) ${1}
	${scm} 0644 ${1}
}

function jord() {
	[ -z "${1}" ] && exit 666
	[ -d ${1} ] || exit 666
	
	dqb "jord"
	csleep 1

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
	dqb "EKF (${1})"
	csleep 2
	local t=$(${odio} which ${1})

	if [ -z "${t}" ] || [ ! -x ${t} ] ; then
		dqb "jfk"
		efk ${q}/${1}*
	fi
}

[ -v CONF_pkgsrc ] || exit 22
[ -d ${CONF_pkgsrc} ] || exit 23
#230526:voisiko instailun ulkoistaa -> g_doit?

function aqua() {
	dqb "aqua"
	csleep 1

	${odio} apt --fix-broken install

	local q
	q=$(mktemp -d)
	${spc} ${CONF_pkgsrc}/*.deb ${q}
	[ $? -eq 0 ] || exit 4

	#parempi samaan aikaan dms ja libdev 
	efk ${q}/dmsetup*.deb  ${q}/libdevmapper*.deb
	#efk ${q}/libjte2*.deb
	efk ${q}/lib*.deb

	dqb "BEFORE TBLZ"
	csleep 2

	#onbkohan trarpeellinen kikkailu?
	for p in ${CONF_accept_pkgs2} ; do ekf ${p} ; done
	sleep 10

	#avaimien instauksen voi hoitaa vaikka import2:sella parillakin taballa
	${odio} dpkg -i ${q}/*.deb
	${smr} ${q}/*.deb

	dqb "GENISOIMAGE?"
	which genisoimage
	csleep 6

	#common_lib sisältää tuon samaisen listan että sikäli vähän turha
	if [ -v CONF_part076 ] ; then
		${odio} apt-get remove --purge --yes ${CONF_part076}
		#python3-cups ntp* #sharyp from common_lib
	fi

	${odio} apt autoremove
	${odio} apt --fix-broken install #tähän vai heti grub-as jälk?
	${odio} which iptables-restore
	${odio} iptables-restore /etc/iptables/rules.v4.0

	csleep 2
	dqb "AFTER iptables-restore "
}

[ -s ${CONF_scripts_dir}/dalek.bash ] || aqua
[ -v CONF_ue ] || exit 34
[ -v CONF_un ] || exit 35

function ignis() {
	dqb "ignis"
	csleep 1
	local tig=$(${odio} which git)

	[ -z "${tig}" ] && exit 68
	[ -x ${tig} ] || exit 69

	[ -z "${CONF_ue}" ] || ${tig} config --global user.email ${CONF_ue}
	[ -z "${CONF_un}" ] || ${tig} config --global user.name ${CONF_un}
	dqb "tg1,1,dibe"

	#varmaan olisi hyvä testata tämä blokki josqs
	if [ -s ${CONF_basedir}/.gitignore ] ; then
		echo "not touching ${CONF_basedir}/.gitignore this time"
	else
		echo "setup1 may have done this already?"
	fi
}

ignis #${CONF_basedir}
[ -v CONF_dir ] || exit 44
[ -d ${CONF_dir} ] || exit 45

#lokaalien sorkinta lienee ulkoistettu 04/26 mennessä
function luft() {
	dqb "luft"
	csleep 1
	local c4=0

	if [ -v CONF_dir ] && [ -s /etc/fstab.tmp ] ; then	
		c4=$(grep ${CONF_dir} /etc/fstab | wc -l)
		c5=$(grep ${CONF_dir} /etc/fstab.tmp | wc -l)
		
		if  [ ${c5} -lt 1 ] ; then
			echo "SMTHING WRONG W/ fstab.tmp (or config)"
			exit 66
		fi
	else
		echo "SMTHING IS WRONG WITH CONFIG, WILL NOT CONTINUE"
		exit 65
	fi

	if [ ${c4} -gt 0 ] ; then
		dqb "f-stab 0k"
	else
		fasdfasd /etc/fstab 
		sleep 1

		#tilapäinen sekoilu osiotaulun ja fstabin kanssa toivottavasti ohi
		#... tosin $CONF_basedir vastaavan rivin kanssa semmoinen muna-kana-juttu
		#olisi myös hyväksi päättää mitkä rivit lisää common_lib fktio ja mitkä tämä

		[ -s /etc/fstab.tmp ] || exit 64
		${odio} cat /etc/fstab.tmp >> /etc/fstab

		sleep 1	
		reqwreqw /etc/fstab  
	fi

	#dataosion jakaminen kahtai myöhemmin?

	for d in $(grep -v '#' /etc/fstab.tmp | awk '{print $2}') ; do
		[ -d ${d} ] || ${odio} mkdir ${d}
	done

	#tartteeko tätä sorkkia vai ei?
	if [ -v CONF_basept2tgt ] ; then
		#/proc/mounts voisi grepAta?
		
		#${odio} mount ${CONF_basept2tgt}
		${odio} mount -a
	else
		echo "SMTHING IS WRONG WITH CONFIG, WILL NOT CONTINUE"
		exit 61
	fi
}

luft

#TODO:komentorivi-vipu millä pelkstään sorkitaan dalek ja sudoers
function f5th() {
	dqb "F5"
	csleep 5

	local p
	local c
	local somefile=$(mktemp)
	fasdfasd ${somefile}
	local somefile2=$(mktemp)
	fasdfasd ${somefile2}

	#CB_LIST1="$(${odio} which halt) $(${odio} which reboot) /usr/bin/which ${sifu} ${sifd}"
	#...ao lista mukaan aa:han vaiko common_lib kanssa jogtain jatkosöäätöä?
	[ -v CONF_scripts_dir ] || exit 11
	[ -z "${CONF_scripts_dir}" ] && exit 22
	[ -d ${CONF_scripts_dir} ] || exit 33

	dqb "MAKING OF:dalek.bash"
	[ -f ${CONF_scripts_dir}/dalek.bash ] && ${svm} ${CONF_scripts_dir}/dalek.bash ${CONF_scripts_dir}/dalek.bash.OLD
	csleep 3

	#echo "#!/bin/bash" > ${CONF_scripts_dir}/dalek.sh #vissiin ei näin
	head -n 1 ${CONF_scripts_dir}/dalek.s > ${somefile2}

	#TARKKUUTTA PERKLE TÄSSÄ KOHTAA 666!!!
	grep -v "#" ${CONF_scripts_dir}/common.conf >> ${somefile2}
	grep -v "#" ${CONF_scripts_dir}/dalek.s >> ${somefile2}

	#reqwreqw ${CONF_scripts_dir}/dalek.s #TODO:takaisin kommenteista sittenq mahd
	reqwreqw ${somefile2}
	${svm} ${somefile2} ${CONF_scripts_dir}/dalek.bash

	${scm} a+x ${CONF_scripts_dir}/dalek.bash
	ls -las ${CONF_scripts_dir}/dalek.*
	#exit
	
	csleep 3
	dqb "AFTER DALEK"
	csleep 3
	
	#TODO:pitäisi saada aikaiseksi testata erinäiset skriptit omegan ajon jälkeen, sitä ennen jos toimii niin ei kerro juuri mitään
	#CONF_aa="${CONF_aa} $(find ${CONF_basedir} -type f -name dalek.sh | head -n 1)"
	
	#olisi kai parempi vetää dalek mukaan find:illa
	CONF_aa="${CONF_aa} ${CONF_scripts_dir}/dalek.bash"

	#ei ihan näin taida mennä, pitäisi tarkemmin speksata sallitut parametrit
	for c in ${CONF_aa} ; do 
		#mangle_s()
		p=$(sha256sum ${c} | cut -d ' ' -f 1 | tr -dc a-f0-9)
		echo "$(whoami) localhost=NOPASSWD: sha256: ${p} ${c}" >> ${somefile} 
	done

	#180526:syntaksi saattoi olla oikea hetken aikaa mutta toivottuun tulokseen ei vielä päästy, man-sivuja pitäisi jaksaa selailla taas
	#oli myös se "sudo.sw"-linkki , jsoap menisi dalek.sh - tavalla kuitenkin	

	for c in ${CONF_ab} ; do
		echo "# $(whoami) localhost=NOPASSWD: ${c} ${CONF_basept2tgt}/^[:a-zA-Z0-9:]\$" >> ${somefile}
	done 

	cat ${somefile}
	${sco} 0:0 ${somefile}
	${scm} 0440 ${somefile}
	${odio} mv ${somefile} /etc/sudoers.d 
}

f5th
#se /.chroot luonti jonnekin?, esim. stage0_backend.bash...
echo "kutl v | g_doit -v 1 ?" #ensiksi mainitun kanssa jos testaisi common_lib
echo "VAIH:SE /e/s.d/live HUKKAAMINEN KOKEEKSI "
