#!/bin/bash
b=0
debug=0 #1
source=""
d=$(dirname $0)
MKS_parts="1 2 3"
. ${d}/common.conf
bl=${CONF_bloader}

function usage() {
	echo "$0 --in <source> [--bl <BLOADER>]"
	echo "$0 --iso"
	echo "$0 --pkgs"
	echo "$0 -h" #voisi olla vakiovaruste tuo optio ja liityvä fktio
	exit 44
}

#miten se -v?
function parse_opts_real() {
	dqb "asd.asd"
}

if [ -f ${d}/keys.conf ] ; then #tarcitaan, kts sibgle_param
	. ${d}/keys.conf
fi

#141025:toiminee avainten asennuksne jälkeen
function single_param() {
	case ${1} in
		--iso)
			[ -v CONF_kay2name ] || exit 68
			${gg} -u ${CONF_kay2name} -sb ./*.iso
			exit 61
		;;
		--pkgs)
			[ -v CONF_kay2name ] || exit 68
			[ -v CONF_pkgsdir2 ] || exit 67
			[ -v CONF_BASEDIR ] || exit 66
			[ x"${CONF_BASEDIR}" != "x" ] || exit 65
			[ x"${CONF_pkgsdir2}" != "x" ] || exit 64

			cd ${CONF_BASEDIR}/${CONF_pkgsdir2}

			${gg} -u ${CONF_kay2name} -sb ./*.deb
			[ $? -eq 0 ] && ${gg} -u ${CONF_kay2name} -sb ./*.bz2
			
			exit 63
		;;
	esac
}

. ${d}/common_funcs.sh

if [ $# -eq 0 ] ; then
	exit
fi

function part0() {
	dqb "part0( ${1}, ${2})"
	csleep 1

	[ -z ${1} ] && exit 65
	[ -d ${1} ] || exit 67

	[ -z ${2} ] && exit 69
	[ "${1}" == "/" ] && exit 71	
	
	grep ${2} /etc/passwd
	csleep 1
	dqb "PARAMS OK"
	csleep 1

	#pot. vaarallinen koska -R
	${sco} -R ${2}:${2} ${1} 
	${scm} 0755 ${1} 
	${scm} u+w ${1}/* 

	#oik/omist - asioita voisi miettiä että miten pitää mennä
	local f

	for f in $(find ${1} -type f -name '${TARGET_DIGESTS_file}*') ; do
		rm ${f}
	done

	[ ${debug} -eq 1 ] && ls -las ${1}/${TARGET_DIGESTS_file}*
	csleep 6

	local i
	for i in ${MKS_parts} 4 ;  do touch ${1}/${TARGET_DIGESTS_file}.${i} ; done
	
	dqb "part0 d0n3"
	csleep 1
}

#HUOM.281125:pad alla julk avaimet .bz2:sessa olisi idea
function part123() {
	#debug=1
	dqb "part123(${1}, ${2} , ${3} )"

	[ z"${1}" != "z" ] || exit 111
	#[ -d ${2} ] || exit 112 #miksi kommenteissa? testaa syy?
	[ -d ${3} ] || exit 113

	local old
	local f
	old=$(pwd)

	if [ ! -s ${3}/${TARGET_DIGESTS_dir}/${TARGET_DIGESTS_file}.${1} ] ; then
		cd ${3}
		[ ${debug} -eq 1 ] && pwd
		dqb "find ./${2} -type f"
		csleep 3

		#HUOM.281125:saattaa joutua muuttamaan vielä jos isolinuxin kanssa alkaa säätää
		for f in $(find ./${2} -type f -name "*.cfg" -or -name "*.lst" -or -name "grubenv") ; do ${sah6} ${f} >> ./${TARGET_DIGESTS_dir}/${TARGET_DIGESTS_file}.${1} ; done
		for f in $(find ./${2} -type f -name "*.mod" -or -name "vmlinuz*" -or -name "initrd*") ; do ${sah6} ${f} >> ./${TARGET_DIGESTS_dir}/${TARGET_DIGESTS_file}.${1} ; done
		for f in $(find ./${2} -type f -name "*.bz2" -or -name "filesystem*") ; do ${sah6} ${f} >> ./${TARGET_DIGESTS_dir}/${TARGET_DIGESTS_file}.${1} ; done

		#HUOM.siinä aiemmassa virityksessä taisi tulla myös devuan.conf (tjsp) mukaan (TODO)

		${scm} 0444 ./${TARGET_DIGESTS_dir}/${TARGET_DIGESTS_file}.${1}
		#${sco} 0:0 ./${TARGET_DIGESTS_dir}/${TARGET_DIGESTS_file}.${1} #ei hyvä idea?
		cd ${old}
	else
		#dgsts.4 luonti ei onnistu?
		dqb "ERROR TERROR"
	fi

	[ ${debug} -eq 1 ] && ls -las ${3}/${TARGET_DIGESTS_dir};sleep 3
}

function part456() {
	dqb "part456 $1 ; $2 ; $3"
	[ z"${1}" != "z" ] || exit 666
	
	[ ${debug} -eq 1 ] && pwd
	csleep 1

	if [ -s ./${TARGET_DIGESTS_dir}/${TARGET_DIGESTS_file}.${1} ] ; then
		${sah6} -c ./${TARGET_DIGESTS_dir}/${TARGET_DIGESTS_file}.${1} --ignore-missing
	else
		echo "no such thing as ./${TARGET_DIGESTS_dir}/${TARGET_DIGESTS_file}.${1}"		 
	fi
}

#HUOM.kandee ajaa vain jos binäärit ja avaimet olemassa
function part6_5() {
	dqb "part65( ${1}, ${2}, ${3})"
	local i
	pwd
	csleep 1

	for i in ${MKS_parts} ; do
		dqb "${gg} -u ${CONF_kay1name} -sb ./${TARGET_DIGESTS_dir}/${TARGET_DIGESTS_file}.${i}"
		${gg} -u ${CONF_kay1name} -sb ./${TARGET_DIGESTS_dir}/${TARGET_DIGESTS_file}.${i}
		[ $? -gt 0 ] && dqb "install-keys --i ?"
	done

	dqb "dibw"
}

function part7() {
	dqb "part7"	
	[ ${debug} -eq 1 ] && pwd
	csleep 2

	dqb "${gg} -u ${CONF_kay2name} -sb ./${TARGET_Dpubkf}"
	${gg} -u ${CONF_kay2name} -sb ./${TARGET_Dpubkf}

	[ $? -gt 0 ] && dqb "install-keys --i ?"
	csleep 2

	${gg} --verify ./${TARGET_Dpubkf}.sig
	[ $? -gt 0 ] && dqb "install-keys --i ?"
	local i

	for i in ${MKS_parts} ; do
		#${gv} --keyring ./${TARGET_Dpubkf} ${TARGET_DIGESTS_dir}/${TARGET_DIGESTS_file}.${i}.sig ${TARGET_DIGESTS_dir}/${TARGET_DIGESTS_file}.${i}
		${gg} --verify ${TARGET_DIGESTS_dir}/${TARGET_DIGESTS_file}.${i}.sig 
	done

	echo $?
	csleep 1
	dqb "p7 done"
}

[ -d ${source} ] || exit 99
dqb "${source} exists"
csleep 1
[ ${debug} -eq 1 ] && pwd
part0 ${source}/${TARGET_DIGESTS_dir} ${n}

csleep 5
dqb "BOOTLEODER"

case ${bl} in
	grub)
		ls -las  ${source}/boot/grub/*.cfg || exit 99
		part123 1 boot/grub ${source}
	;;
	*)
		ls -las  ${source}/${bl}/*.cfg || exit 99
		csleep 1
		part123 1 ${bl} ${source}
	;;
esac

csleep 5
dqb "BOOTLEREOD ONEDD"
csleep 1

#jotebkin toisin jatkossa? hakemistoa kohti 1 tdsto ja täts it? eio erikseen 1,2,3-juttui
part123 2 ${TARGET_pad_dir} ${source}
part123 3 live ${source}

cd ${source}
for p in ${MKS_parts} ; do part456 ${p}; done

#271125:pitäisiköhän pad-hmiston sisällöstä tehdä dgsts.x kanssa? part123 hoitaa?
#kts liittyen jlk_main() , että mitä pitäisi sisällöksi laittaa, esim
#niinja nw julk av pitäisi myös tulla mukaan

if [ x"${gg}" != "x" ] ; then 
	part6_5
fi

part7 
[ ${debug} -eq 1 ] && pwd

#part8 ${b}
[ ${debug} -eq 1 ] && pwd

${sco} ${n}:${n} ./${TARGET_DIGESTS_dir}/* 
${scm} 0644 ./${TARGET_DIGESTS_dir}/* 
[ ${debug} -eq 1 ] && ls -las ./${TARGET_DIGESTS_dir}
csleep 1

#271125:josko ao. blokki jo kunnossa?
dqb "${sah6} ./${TARGET_DIGESTS_dir}/* | grep -v '${TARGET_DIGESTS_file}.4' | grep -v 'cf83e' | head -n 10" # | grep -v 'SAM' turha?
${sah6} ./${TARGET_DIGESTS_dir}/* | grep -v '${TARGET_DIGESTS_file}.4' | grep -v 'cf83e' | head -n 10 > ./${TARGET_DIGESTS_dir}/${TARGET_DIGESTS_file}.4
part456 4

${sco} -R 0:0 ./${TARGET_DIGESTS_dir}
${scm} 0555 ./${TARGET_DIGESTS_dir}
${scm} 0444 ./${TARGET_DIGESTS_dir}/*

[ ${debug} -eq 1 ] && ls -laRs ${TARGET_DIGESTS_dir}
echo "loits | squ.ash -j ?"