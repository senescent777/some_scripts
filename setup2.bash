#!/bin/bash
. ./setup0.conf

if [ -s $0.conf ] ; then
	. $0.conf
else
	exit 67
fi

#=================LIB1==============================================
#skritps/common_funcs, hyödyntäisikö?
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
	[ "${1}" == "/" ] && exit 101

	csleep 1
	${sco} 0:0 ${1}
	${scm} a-w ${1}
}

function fasdfasd() {
	[ -z "${1}" ] && exit 99
	[ "${1}" == "/" ] && exit 101

	csleep 1
	${odio} touch ${1}
	${sco} $(whoami):$(whoami) ${1}
	${scm} 0644 ${1}
}

#common_lib
function efk() {
	${odio} dpkg -i $@
	${smr} $@
}

frist=0

function ekf() {
	dqb "EKF (${1})"
	#[ -z "${1}" ] && exit 99
	csleep 2
	local t=$(${odio} which ${1})

	if [ -z "${t}" ] || [ ! -x ${t} ] ; then
		dqb "jfk"

		if [ ${frist} -eq 0 ] ; then
			efk ${q}/lib*
			frist=1
		fi

		efk ${q}/${1}*
	else #tämä haara uutena (järkee vai ei?)
		dqb "0S.WALD"		
	fi
}

#=========================LIB2=========================================
g_aa=${CONF_aa}
g_ab=${CONF_ab}

function jord() {
	[ -z "${1}" ] && exit 66
	[ -d ${1} ] || exit 65
	
	dqb "jord"
	csleep 1

	${sco} -R 0:0 ${1}/etc	
	${scm} -R 0444 ${1}/etc	

	#toimiva meshuqqah /e alle se kantava idea, yhdestä toimivasta versiosta on vamruuskopio jos tarttee
	#... koitetaan jos mangle_s:n paikallinen versio kykenisi (12726)

	${spc} -a ${1}/etc/* /etc
}

#240526:noista paketeista oikeastaan git lienee välttämättömin tmän skriptin kannalta
#... vaikuttaisi että gdoit.sh kehitysymp saattaa paskoa slimin (v8elä 07/26?)

function aqua() {
	dqb "aqua ) ${1} ("
	csleep 1

	#[ -v CONF_pkgsrc ] || exit 22 
	[ -z "${1}" ] && exit 21
	[ -d ${1} ] || exit 23

	${odio} apt --fix-broken install
	csleep 6

	local q=$(mktemp -d)
	${spc} ${1}/*.deb ${q}
	[ $? -eq 0 ] || exit 4

	# dms ja libdev vielä lähdehmistoon?
	efk ${q}/dmsetup*.deb.deb ${q}/libjte2*.deb ${q}/libdevmapper*
	#efk ${q}/libjte2*.deb
	#efk ${q}/lib*.deb #uutena

	dqb "BEFORE TBLZ"
	csleep 2

	#onbkohan trarpeellinen kikkailu? E22_GG...
	for p in ${CONF_accept_pkgs2} ; do ekf ${p} ; done
	sleep 5

#	${odio} dpkg -i ${q}/*.deb
#	${smr} ${q}/*.deb
#
#	dqb "GENISOIMAGE?"
#	which genisoimage
#	csleep 6
#
#	#common_lib sisältää tuon samaisen listan että sikäli vähän turha
#	if [ -v CONF_part076 ] ; then
#		${odio} apt-get remove --purge --yes ${CONF_part076}
#		#python3-cups ntp* #sharyp from common_lib
#	fi
#
#	${odio} apt autoremove
#	${odio} apt --fix-broken install #tähän vai heti grub-as jälk?
#	${odio} which iptables-restore
#	${odio} iptables-restore /etc/iptables/rules.v4.0
#
#	csleep 2
#	dqb "AFTER iptables-restore "
}

function ignis() {
	dqb "ignis"
	csleep 1

	[ -z "${1}" ] && exit 21
	[ -d ${1} ] || exit 23

	local tig=$(${odio} which git)

	[ -z "${tig}" ] && exit 68
	[ -x ${tig} ] || exit 69

	[ -z "${CONF_ue}" ] || ${tig} config --global user.email ${CONF_ue}
	[ -z "${CONF_un}" ] || ${tig} config --global user.name ${CONF_un}
	dqb "tg1,1,dibe"

	#varmaan olisi hyvä testata tämä blokki josqs
	if [ -s ${1}/.gitignore ] ; then
		echo "not touching ${1}/.gitignore this time"
	else
		echo "setup1 may have done this already?"
	fi

	echo "#VAIH:koklaten niitä got init-juttuja kanssa? testaus myös"
	sleep 5
	local c=0

	if [ -d ${1}/.git ] ; then
		c=$(find ${1}/.git -type f | wc -l)
	fi

	if [ ${c} -lt 1 ] ; then
		echo "SHOULD ${tig} init ${1}"
	fi
}

function luft() {
	dqb "luft"
	csleep 10
	local c4=0

#	if [ -v CONF_dir ] && [ -s /etc/fstab.tmp ] ; then	
#		c4=$(grep ${CONF_dir} /etc/fstab | wc -l)
#		local c5=$(grep ${CONF_dir} /etc/fstab.tmp | wc -l)
#		
#		if  [ ${c5} -lt 1 ] ; then
#			echo "SMTHING WRONG W/ fstab.tmp (or config)"
#			exit 66
#		fi
#	else
#		echo "SMTHING IS WRONG WITH CONFIG, WILL NOT CONTINUE"
#		exit 65
#	fi

	if [ ${c4} -gt 0 ] ; then
		dqb "f-stab 0k"
	else
		fasdfasd /etc/fstab 
		sleep 1

		[ -s /etc/fstab.tmp ] || exit 64
		${odio} cat /etc/fstab.tmp >> /etc/fstab
		echo $?

		sleep 5	
		reqwreqw /etc/fstab  
	fi

	echo "FSTAB MUTILAEDT"
	sleep 5
	#dataosion jakaminen kahtIA myöhemmin?

	for d in $(grep -v '#' /etc/fstab.tmp | awk '{print $2}') ; do
		[ -d ${d} ] || ${odio} mkdir ${d}
	done

	#tartteeko tätä sorkkia vai ei?
	if [ -v CONF_basept2tgt ] ; then
		#/proc/mounts voisi grepAta?
		${odio} mount -a
	else
		echo "SMTHING IS WRONG WITH CONFIG, WILL NOT CONTINUE"
		exit 61
	fi
}

function f5a() {
	dqb "F5.a"
	csleep 5

	[ -z "${1}" ] && exit 99
	[ -z "${2}" ] && exit 98

	#020826:tokan param kanssa ok grepata tnp, ekan kanssa ei tarvitse
	local x=$(echo ${2} | grep tmp | wc -l)
	[ ${x} -gt 0 ] || exit 95 

	[ -z "${3}" ] && exit 97
	[ -d "${3}" ] || exit 96

	fasdfasd ${1} #kuinka tarpeellinen param?
	fasdfasd ${2}

	[ -v CONF_scripts_dir ] || exit 11 #kutsuvaan koodiin

	#muistettava kanssa varmistaa että dalek tulee kaikkiin sitä tarvitseviin juttuihin mukaan?
	#...varmistettu?

	dqb "MAKING OF:dalek.bash"
	[ -f ${3}/dalek.bash ] && ${svm} ${1}/dalek.bash ${1}/dalek.bash.OLD
	csleep 3

	dqb "SHOULD gpg --verify ${3}/dalek.s OR SMTHING, AROUND HERE"
	csleep 3

	head -n 1 ${3}/dalek.s > ${2}
	grep -v "#" ${3}/common.conf >> ${2}
	grep -v "#" ${3}/dalek.s >> ${2}

	reqwreqw ${3}/dalek.s #jos voisi olla renkkaamatta vähän aikaa
	reqwreqw ${2}
	${svm} ${2} ${3}/dalek.bash

	${scm} a+x ${3}/dalek.bash
	ls -las ${3}/dalek.*
	
	csleep 3
	dqb "AFTER DALEK"
	csleep 3
	
	#020826:jospa toimisivat useimmat skriptit sudon kautta
	#btw. miksi erikseen esab? , olisi suoraan tuo $3/dalek ... polut?

	local t=$(${odio} find ${CONF_esab} -type f -name "dalek.bash")
	echo "t= ${t}"
	sleep 6
	[ -z "${t}" ] || g_aa="${g_aa} ${t}"
}

function f5b() {
	dqb "F5.b"
	csleep 5
	local p
	local c
	local c2
	local t

	#mitenkähän tämän tark pitäisi mennä?
	[ -z "${1}" ] && exit 99

	#... toisaalta squashfs-työkaluja ei tarvitsisi sudottaa (?)
	#miten muuten "squ.ash r" ? /bin/chroot saattaa joutua lisäämään sudoersiin mutta mIElellään jos voisi rajata parametrien suhteen

	if [ -v CONF_esab ] ; then #turha kikkailu oikeastaan
		t=$(${odio} find ${CONF_esab} -type f -name "generic_doit.sh")
		echo "t= ${t}"
		sleep 3

		[ -z "${t}" ] || g_aa="${g_aa} ${t}"
	fi

	#g_ab juttuja lukuunottamatta asiat jo kuynnossa?
	#15726: $1 kanssa jokin tr-jekku jatkossa? kts "man 5 sudoers"
	#jekku jo tehty? bissiin

	t=$(echo ${1} | tr -dc a-zA-Z0-9/_-)
	[ -z "${t}" ] && exit 99

	for c in ${g_aa} ; do
		p=$(${sah6} ${c} | cut -d ' ' -f 1 | tr -dc a-fA-F0-9)
		c2=$(echo ${c} | tr -dc a-zA-Z0-9./_)	
		echo "$(whoami) ALL=NOPASSWD:${CONF_algo}:${p} ${c2}" >> ${t}	#oli ennen c sijasta c2, $t tilalla $1	
	done

	#(myös joitain paraMetreja tulisi sallia)
	#15726:syntaksi kusee taas

	for c in ${g_ab} ; do
		c2=$(echo ${c} | tr -dc a-zA-Z0-9./_)
		echo "# $(whoami) ALL=NOPASSWD: ${c2} ${CONF_basept2tgt}/^[:a-zA-Z0-9:]\$" >> ${t}
	done 

	cat ${1}
	${sco} 0:0 ${1}
	${scm} 0440 ${1}
	${odio} mv ${1} /etc/sudoers.d 
}

#==========================MAIN=======================================
jord ${CONF_basedir}

#se "komentorivi-vipu millä pelkstään sorkitaan dalek ja sudoers"
if [ "${1}" != "1" ] ; then
	[ -s ${CONF_scripts_dir}/dalek.bash ] || aqua ${CONF_pkgsrc}
	[ -v CONF_ue ] || exit 34
	[ -v CONF_un ] || exit 35

	ignis ${CONF_basedir}
	[ -v CONF_dir ] || exit 44
	[ -d ${CONF_dir} ] || exit 45

	luft
fi

somefile=$(mktemp qsipasq2-XXXX )
#virhetilanteeseen reagointi mktemp kanssa?
somefile2=$(mktemp) #ehkä pärjäisi ilmankin tuon kanssa kikkailua, suoraan kohde-hmistooon tdsto ja täts it

f5a ${somefile} ${somefile2} ${CONF_scripts_dir}
f5b ${somefile}

echo "kutl v | g_doit -v 1 ?"
