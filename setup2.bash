#!/bin/bash
. ./setup0.conf

if [ -s $0.conf ] ; then
	. $0.conf
else
	exit 67
fi

#TODO:josqs taas sitä post_omega_testausta
#DONE?:fstab.tmp jutut
#VAIH:selvitä missä kohtaa uuden .ison rakennus kosahtaa, doit+pt2 oli viimeksi liikaa (261126)

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

#20926:tässä fktiossa ainoa globaali tuo frist
function ekf() {
	dqb "EKF (${1})"
	#[ -z "${1}" ] && exit 99
	csleep 2
	local t=$(${odio} which ${1})

	if [ -z "${t}" ] || [ ! -x ${t} ] ; then
		dqb "jfk"

		if [ ${frist} -eq 0 ] ; then
			efk ${2}/lib*
			frist=1
		fi

		efk ${2}/${1}*
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
	
	dqb "i jordens djup"
	csleep 1

	${sco} -R 0:0 ${1}/etc	
	${scm} 0755 ${1}/etc	#ennen -R 0444
	
	${spc} -a ${1}/etc/* /etc
	${scm} 0444 ${1}/etc/*
}

function aqua() {
	dqb "aqua ) ${1} ("
	csleep 1

	[ -z "${1}" ] && exit 21
	[ -d ${1} ] || exit 23

	${odio} apt --fix-broken install
	csleep 6

	local q=$(mktemp -d)
	${spc} ${1}/*.deb ${q}

	if [ $? -eq 0 ] ; then
		dqb "KO"
	else
		echo "SHOULD copy ${CONF_accept_pkgs2} / \*.deb UNDER ${1}"
		exit 4
	fi

	# dms ja libdev vielä lähdehmistoon? tai jos ensin pakettiin (kts e23_st())
	efk ${q}/dmsetup*.deb ${q}/libjte2*.deb ${q}/libdevmapper*

	dqb "BEFORE TBLZ"
	csleep 2

	#VAIH:joitain git-paketteja lisää? (kts e23_st())
	for p in ${CONF_accept_pkgs2} ; do ekf ${p} ${q} ; done
	sleep 5

#	#common_lib sisältää tuon samaisen listan että sikäli vähän turha
#	if [ -v CONF_part076 ] ; then
#		${odio} apt-get remove --purge --yes ${CONF_part076}
#		#python3-cups ntp* #sharyp from common_lib
#	fi
#
}

function ignis() {
	dqb "firepower"
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

	#151126:bissiin init toimaa, pull/push/yms vielä testaamatta
	local c=0

	if [ -d ${1}/.git ] ; then
		c=$(find ${1}/.git -type f | wc -l)
	fi

	if [ ${c} -lt 1 ] ; then
		echo "SHOULD ${tig} init ${1}";sleep 5
		${tig} init ${1}
	fi
}

function luft() {
	dqb "luftwaffe"
	csleep 10
	local c4=0

	#VAIH:jokin tarkistus asettamaan c4:sen, esim. grep BASEpt2tgt /e/fstab | wc
	c4=$(grep ${CONF_basept2tgt} /etc/fstab | grep -v '#' | wc -l)

	if [ ${c4} -gt 0 ] ; then
		dqb "f-stab 0k"
	else
		#161126:toimiiko tämä haara bvai ei? ehkäö js lädhe ko
		fasdfasd /etc/fstab 
		sleep 1

		echo "JUST BEFORE CHANGING /E/F-STAB"
		sleep 10

		#161126:chattr-kikkailut voivay kusta nuop ao. komennot?
		[ -s /etc/fstab.tmp ] || exit 64
		${odio} cat /etc/fstab.tmp >> /etc/fstab
		echo $?

		cat /etc/fstab
		sleep 5	
		reqwreqw /etc/fstab  
	fi

	echo "FSTAB MUTILAEDT"
	sleep 5

	for d in $(grep -v '#' /etc/fstab.tmp | awk '{print $2}') ; do
		[ -d ${d} ] || ${odio} mkdir ${d}
	done

	if [ -v CONF_basept2tgt ] ; then
		${odio} mount -a
		#${scm} 0777 /tmp
		#${scm} o+t /tmp
	else
		echo "SMTHING IS WRONG WITH CONFIG, WILL NOT CONTINUE"
		exit 61
	fi
}

function f5a() {
	dqb "F5.a ) ${1} ) ${2} )) ${3} "
	csleep 5

	[ -z "${1}" ] && exit 99
	[ -z "${2}" ] && exit 98

	local x=$(echo ${2} | grep tmp | wc -l)
	[ ${x} -gt 0 ] || exit 95 

	[ -z "${3}" ] && exit 97
	[ -d "${3}" ] || exit 96

	fasdfasd ${1}
	fasdfasd ${2}

	[ -v CONF_scripts_dir ] || exit 11
	#kutsuvaan koodiin?

	dqb "MAKING OF:dalek.bash"
	[ -f ${3}/dalek.bash ] && ${svm} ${1}/dalek.bash ${1}/dalek.bash.OLD
	csleep 3

	dqb "SHOULD gpg --verify ${3}/dalek.s OR SMTHING, AROUND HERE"
	csleep 3

	head -n 1 ${3}/dalek.s > ${2}
	grep -v "#" ${3}/common.conf >> ${2}
	grep -v "#" ${3}/dalek.s >> ${2}

	reqwreqw ${3}/dalek.s
	reqwreqw ${2}
	${svm} ${2} ${3}/dalek.bash

	${scm} a+x ${3}/dalek.bash
	ls -las ${3}/dalek.*
	
	csleep 3
	dqb "AFTER DALEK"
	csleep 3
	
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

	[ -z "${1}" ] && exit 99

	if [ -v CONF_esab ] ; then
		#turha kikkailu oikeastaan
		t=$(${odio} find ${CONF_esab} -type f -name "generic_doit.sh")
		echo "t= ${t}"
		sleep 3

		[ -z "${t}" ] || g_aa="${g_aa} ${t}"
	fi

	t=$(echo ${1} | tr -dc a-zA-Z0-9/_-)
	[ -z "${t}" ] && exit 99

	for c in ${g_aa} ; do
		p=$(${sah6} ${c} | cut -d ' ' -f 1 | tr -dc a-fA-F0-9)
		c2=$(echo ${c} | tr -dc a-zA-Z0-9./_)	
		echo "$(whoami) ALL=NOPASSWD:${CONF_algo}:${p} ${c2}" >> ${t}
		#oli ennen c sijasta c2, $t tilalla $1	
	done

	for c in ${g_ab} ; do
		c2=$(echo ${c} | tr -dc a-zA-Z0-9./_)
		echo "# $(whoami) ALL=NOPASSWD: ${c2} ${CONF_basept2tgt}/^[:a-zA-Z0-9:]\$" >> ${t}
	done 

	cat ${1}
	${sco} 0:0 ${1}
	${scm} 0440 ${1}
	${odio} mv ${1} /etc/sudoers.d
	
	echo "SHOULD LOG OUT AND BACK IN 4 SUD0-REASONS"
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

CONF_enforce_prefix=qsipasq

somefile=$(mktemp ${CONF_enforce_prefix}2-XXXX )
[ $? -eq 0 ] || exit 69
#virhetilanteeseen reagointi mktemp kanssa?

somefile2=$(mktemp)
#ehkä pärjäisi ilmankin tuon kanssa kikkailua, suoraan kohde-hmistooon tdsto ja täts it

f5a "${somefile}" "${somefile2}" "${CONF_scripts_dir}"
f5b "${somefile}"
echo "kutl v | g_doit -v 1 ?"
