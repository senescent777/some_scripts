#!/bin/bash
b=0
debug=0
source=""
d=$(dirname $0) #tämäb annettava olla tässä
. ${d}/common.conf
bl=${CONF_bloader}

#010426:"./boot/grub/grub.cfg: FAILED open or read" tdstosta dgsts.1 (sqroot)
#... jos toistuu ni tekisikö jotain?

#TODO?:part123() 2 , pitäisikö sitä miettiä vielä? miksi?

#dgsts.4 ja dgsts.5 , sisältö ok?

function usage() {
	echo "$0 --in <source> [--bl <BLOADER>]"
	echo "$0 --iso"
	echo "$0 --pkgs"
	echo "$0 -h"
	exit 44
}

function parse_opts_real() {
	dqb "asd.asd"
}

if [ -f ${d}/keys.conf ] ; then #tarvitaan, kts sibgle_param
	. ${d}/keys.conf
fi

#141025:toiminee avainten asennuksne jälkeen
function single_param() {
	case ${1} in
		--iso)
			[ -v CONF_ksk ] || exit 68
			${gg} -u ${CONF_ksk} -sb ./*.iso
			exit 61
		;;
		--pkgs)
			[ -v CONF_ksk ] || exit 68
			[ -v CONF_pkgsdir2 ] || exit 67
			[ -v CONF_BASEDIR ] || exit 66
			[ x"${CONF_BASEDIR}" != "x" ] || exit 65
			[ x"${CONF_pkgsdir2}" != "x" ] || exit 64

			cd ${CONF_BASEDIR}/${CONF_pkgsdir2}

			${gg} -u ${CONF_ksk} -sb ./*.deb
			[ $? -eq 0 ] && ${gg} -u ${CONF_ksk} -sb ./*.bz2
			
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

	[ -z "${1}" ] && exit 65
	[ -d ${1} ] || exit 67

	[ -z "${2}" ] && exit 69
	[ "${1}" == "/" ] && exit 71	
	
	grep ${2} /etc/passwd
	csleep 1
	dqb "PARAMS OK"
	csleep 1

	#pot. vaarallinen koska -R
	${sco} -R ${2}:${2} ${1} 
	${scm} 0755 ${1} 
	${scm} u+w ${1}/* 
	dqb "OCD ENOD"
	csleep 1
	
	#oik/omist - asioita voisi miettiä että miten pitää mennä
	local f
	dqb "MARC"
	csleep 1

	[ -v TARGET_DIGESTS_file ] || exit 73
	[ -z "${TARGET_DIGESTS_file}" ] && exit 75
	
	dqb "\${NKVD} W1LL C0M3 F0R ${1}/${TARGET_DIGESTS_file}* SOON"
	csleep 1
	${NKVD} ${1}/${TARGET_DIGESTS_file}*	
	
	dqb "QPOL0"
	csleep 1
	
	[ ${debug} -eq 1 ] && ls -las ${1}/${TARGET_DIGESTS_file}*
	csleep 3
	
	dqb "part0 d0n3"
	csleep 1
}

#HUOM.281125:pad alla julk avaimet .bz2:sessa olisi idea, tosin muitAkin löytyy
function part123() {
	dqb "part123(${1}, ${2} , ${3} )"

	[ -z "${1}" ] && exit 111
	[ -d ${3} ] || exit 113
	#[ -d ${2} ] || exit 114 # -d $2/$3 parempi?

	local old
	local f
	old=$(pwd)

	local t
	t=${TARGET_DIGESTS_dir}/${TARGET_DIGESTS_file}.${1}

	if [ ! -s ${3}/${t} ] ; then
		cd ${3}
		[ ${debug} -eq 1 ] && pwd
		csleep 3

		#HUOM.281125:saattaa joutua muuttamaan vielä jos isolinuxin kanssa alkaa säätää
		for f in $(find ./${2} -type f -name "*.cfg" -or -name "*.lst" -or -name "grubenv") ; do ${sah6} ${f} >> ./${t} ; done
		for f in $(find ./${2} -type f -name "*.mod" -or -name "vmlinuz*" -or -name "initrd*") ; do ${sah6} ${f} >> ./${t} ; done
		for f in $(find ./${2} -type f -name "*.bz2" -or -name "filesystem*") ; do ${sah6} ${f} >> ./${t} ; done
		for f in $(find ./${2} -type f -name "*.conf")  ; do ${sah6} ${f} >> ./${t} ; done

		${scm} 0444 ./${t}
		#${sco} 0:0 ./${t} #ei hyvä idea?
		cd ${old}
	else
		#dgsts.4 luonti ei onnistu?
		dqb "ERROR TERROR"
	fi

	[ ${debug} -eq 1 ] && ls -las ${3}/${TARGET_DIGESTS_dir};sleep 3
}

#HUOM.kandee ajaa tämä vain jos binäärit ja avaimet olemassa
#161225:miten parametrit nykyään? mitä tulee ja mitä tarvitaan?
function part6_5() {
	dqb "mks.part65( $@ ) "

	[ -v CONF_pubk ] || exit 99	
	[ -v TARGET_DIGESTS_dir ] || exit 98
	[ -v TARGET_DIGESTS_file ] || exit 97
	csleep 1

	[ ${debug} -gt 0 ] && pwd
	csleep 1

	for f in $(find ./${TARGET_DIGESTS_dir} -type f -name "${TARGET_DIGESTS_file}.?" ) ; do
		${gg} -u ${CONF_pubk} -sb ${f}
		[ $? -gt 0 ] && dqb "kutl.bash w | x ?"
	done

	dqb "mks.part65dibw"
}

#151225:avainten allek ja const:it ok, pitää vain kopsata kohdehak alle jossain sopivassa kohdassa(TODO)
#TODO:target_dpub-jutut pois sittenq mahd ?
#100326:"gpg --edit-key" ? ehkä ei tähän mutta johonkin

function part7() {
	dqb "mks.part7 ( ${1} , ${2} , ${3} ) " 

	[ -v TARGET_DIGESTS_dir ] || exit 98
	[ -v TARGET_DIGESTS_file ] || exit 97	
	[ ${debug} -gt 0 ] && pwd
	csleep 1

	dqb "${gg} -u ${CONF_ksk} -sb ./${TARGET_Dpubkf}"
	${gg} -u ${CONF_ksk} -sb ./${TARGET_Dpubkf}
	[ $? -gt 0 ] && dqb "kutl.bash  ?"
	csleep 5

	${gg} --verify ./${TARGET_Dpubkf}.sig
	[ $? -gt 0 ] && dqb "kutl.bash  ?"
	csleep 5

	for f in $(find ${TARGET_DIGESTS_dir} -type f -name "${TARGET_DIGESTS_file}.?.sig" ) ; do
		${gg} --verify ${f} 
	done

	echo $?
	csleep 1
	dqb "p7 done"
}

[ -d ${source} ] || exit 99
dqb "${source} exists"
csleep 1
[ ${debug} -eq 1 ] && pwd
part0 ${source}/${TARGET_DIGESTS_dir} $(whoami)

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

#jotebkin toisin jatkossa? hakemistoa kohti 1 tdsto ja täts it? ei erikseen 1,2,3-juttui
#201225:part123() nykyisellään ei tee .sh-tiedostoista tsummia, mutta voisi laittaa tekemään

part123 2 ${TARGET_pad_dir} ${source}
part123 3 live ${source}
cd ${source}

for f in $(find ./${TARGET_DIGESTS_dir} -type f -name "${TARGET_DIGESTS_file}.?" ) ; do
	dqb "p456 ${f}"
	${sah6} -c ${f} --ignore-missing
done

#kts liittyen jlk_main() , että mitä pitäisi sisällöksi laittaa, esim
#niinja nw julk av pitäisi myös tulla mukaan, kts stage0_backend liittyen

if [ ! -z "${gg}" ] ; then 
	part6_5
fi

part7
[ ${debug} -eq 1 ] && pwd

${sco} $(whoami):$(whoami) ./${TARGET_DIGESTS_dir}/* 
${scm} 0644 ./${TARGET_DIGESTS_dir}/* 
[ ${debug} -eq 1 ] && ls -las ./${TARGET_DIGESTS_dir}
csleep 1

dqb "${sah6} ./${TARGET_DIGESTS_dir}/* | grep -v '${TARGET_DIGESTS_file}.4' | grep -v 'cf83e' | head -n 12" 
${sah6} ./${TARGET_DIGESTS_dir}/* | grep -v '${TARGET_DIGESTS_file}.4' | grep -v 'cf83e' | head -n 12 > ./${TARGET_DIGESTS_dir}/${TARGET_DIGESTS_file}.4

${sco} -R 0:0 ./${TARGET_DIGESTS_dir}
${scm} 0555 ./${TARGET_DIGESTS_dir}
${scm} 0444 ./${TARGET_DIGESTS_dir}/*

[ ${debug} -eq 1 ] && ls -laRs ${TARGET_DIGESTS_dir}
echo "loits | squ.ash -j ?"
