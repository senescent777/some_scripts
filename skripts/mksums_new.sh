#!/bin/bash
b=0
debug=0 #1
source=""

d=$(dirname $0)
. ${d}/common.conf
. ${d}/common_funcs.sh

if [ -f ${d}/keys.conf ] ; then
	. ${d}/keys.conf
fi

#jos jatkossa common_funcs tai common_lib
if [ $# -eq 0 ] ; then
	echo "-h"
	exit
fi

function usage() {
	echo "$0 --in <source> [-b <mode>]"
	echo "$0 --iso"
	echo "$0 --pkgs"
	echo "$0 -h" #voisi olla vakiovaruste tuo optio ja liityvä fktio
}

function parse_opts_real() {

	case ${1} in
		-b)
			b=${2}
		;;
		--in)
			source=${2}
		;;
	esac
}

#VAIH:näiden opioitden testaus (gg-jutut mielekkäitä sittenq)
function single_param() {
	case ${1} in
		--iso)
	
			${gg} -u ${CONF_kay2name} -sb ./*.iso
			exit 66
		;;
		--pkgs)
			[ x"${CONF_BASEDIR}" != "x" ] || exit 65
			[ x"${CONF_pkgsdir2}" != "x" ] || exit 64

			cd ${CONF_BASEDIR}/${CONF_pkgsdir2}

			${gg} -u ${CONF_kay2name} -sb ./*.deb
			[ $? -eq 0 ] && ${gg} -u ${CONF_kay2name} -sb ./*.bz2
			
			exit 63
		;;
		--h|-h)
			usage
		;;
	esac
}

MKS_parts="1 2 3"

function part0() {
	dqb "part0( ${1})"
	[ -d ${1} ] || exit 67

	local f

	#pot. vaarallinen koska -R
	${sco} -R ${n}:${n} ${1}  #TODO; $n parametriksi
	${scm} 0755 ${1} 
	${scm} u+w ${1}/* 
	#oik/omist - asioita vosi miettiä jossain vaih että miten pitää mennä

	for f in $(find ${1} -type f -name '${TARGET_DIGESTS_file}*') ; do
		rm ${f}
	done

	local i
	for i in ${MKS_parts} 4 ;  do touch ${1}/${TARGET_DIGESTS_file}.${i} ; done
	
	dqb "part0 d0n3"
	csleep 1
}

#function part1234() {
#	local olddir=$(pwd)	
#
#
#	local f
#
#	for f in $(find . -name SAM.${1}.*) ; do
#		echo	
#	done
#
#	cd ${olddir}
#}

function part123() {
	#debug=1
	dqb "part123(${1}, ${2} , ${3} )"

	[ z"${1}" != "z" ] || exit 111
	#[ -d ${2} ] || exit 112
	[ -d ${3} ] || exit 113

	local old
	local f
	old=$(pwd)

	if [ ! -s ${3}/${TARGET_DIGESTS_dir}/${TARGET_DIGESTS_file}.${1} ] ; then
		cd ${3}
		[ ${debug} -eq 1 ] && pwd
		dqb "find ./${2} -type f"
		csleep 1

		for f in $(find ./${2} -type f  | grep -v ${TARGET_patch_name} | grep -v ${TARGET_DIGESTS_file0} | grep -v boot.cat | grep -v isolinux.bin | grep -v '.mod' | grep -v '.c32') ; do
			dqb "${sh5} ${f}"
			${sh5} ${f} >> ./${TARGET_DIGESTS_dir}/${TARGET_DIGESTS_file}.${1}			
		done

		${scm} 0444 ./${TARGET_DIGESTS_dir}/${TARGET_DIGESTS_file}.${1}
		#${sco} 0:0 ./${TARGET_DIGESTS_dir}/${TARGET_DIGESTS_file}.${1}
		cd ${old}
	else
		dqb "ERROR TERROR"
	fi

	[ ${debug} -eq 1 ] && ls -las ${3}/${TARGET_DIGESTS_dir};sleep 3
}

function part456() {
	#debug=1
	dqb "part456 $1 ; $2 ; $3"
	[ z"${1}" != "z" ] || exit 666
	
	[ ${debug} -eq 1 ] && pwd
	csleep 1

	if [ -s ./${TARGET_DIGESTS_dir}/${TARGET_DIGESTS_file}.${1} ] ; then
		${sh5} -c ./${TARGET_DIGESTS_dir}/${TARGET_DIGESTS_file}.${1} --ignore-missing
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
		${gg} -u ${CONF_kay1name} -sb ./${TARGET_DIGESTS_file}.${i}
		echo "$?"
	done

	if [ $? -gt 0 ] ; then
		dqb "uliuli"
	fi

	dqb "dibw"
}

function part7() {
	dqb "part7"	

	${gg} -u ${CONF_kay2name} -sb ./${TARGET_Dpubkf}
	${gv} --keyring ./${TARGET_Dpubkg} ./${TARGET_Dpubkf}.sig ./${TARGET_Dpubkf}
	local i

	for i in ${MKS_parts} ; do
		${gv} --keyring ${TARGET_Dpubkf} ${TARGET_DIGESTS_file}.${i}.sig ${TARGET_DIGESTS_file}.${i}
	done

	echo $?
	csleep 1
	dqb "p7 done"
}

function part8() {
	dqb "p8 ${1}"
	[ x"${TARGET_patch_name}" != "x" ] || exit 665
	[ x"${1}" != "x" ] || exit 665

	dqb "params ok"

	local tfile=${TARGET_patch_name}.tar.bz2
	#[ -s ./${TARGET_pad_dir}/${tfile} ] || exit 666		

	local olddir=$(pwd)	
	[ -s ./${TARGET_pad_dir}/${tfile} ] && cp ./${TARGET_pad_dir}/${tfile} ../out
	cd ../out

	case ${1} in
		1)
			${gg} -u ${CONF_kay2name} -sb ${tfile}
			echo $?

			${gv} --keyring ${CONF_target}/${TARGET_Dpubkg} ${tfile}.sig ${tfile}
		;;
		2)
			dqb "2"
		;;
		*)
			dqb "default"
		;;
	esac 

	cd ${olddir}
}

#enforce_deps
parse_opts ${1} ${2}
parse_opts ${3} ${4}

[ -d ${source} ] || exit 99
dqb "${source} exists"
csleep 1
[ ${debug} -eq 1 ] && pwd
part0 ${source}/${TARGET_DIGESTS_dir}

#HUOM.18725:toisinkin voisi tehdä, nyt näin
case ${CONF_bloader} in
	grub)
		part123 1 boot/grub ${source}
	;;
	*)
		part123 1 ${CONF_bloader} ${source}
	;;
esac

part123 2 ${TARGET_pad_dir} ${source}
part123 3 live ${source}

cd ${source}  #${CONF_target}
for p in ${MKS_parts} ; do part456 ${p}; done

#6_5-8 mielekästä ajaa vatsa wittenq avaimet olemassa
if [ x"${gg}" != "x" ] ; then 
	part6_5
fi

part7 
[ ${debug} -eq 1 ] && pwd

part8 ${b}
[ ${debug} -eq 1 ] && pwd

${sco} ${n}:${n} ./${TARGET_DIGESTS_dir}/* 
${scm} 0644 ./${TARGET_DIGESTS_dir}/* 
[ ${debug} -eq 1 ] && ls -las ./${TARGET_DIGESTS_dir}
csleep 1

#HUOM.18726: dgsts.4 kassa myös jotain jurpoilua?
dqb "${sh5} ./${TARGET_DIGESTS_dir}/* | grep -v '${TARGET_DIGESTS_file}.4' | grep -v 'cf83e' | grep -v 'SAM' | head -n 10"
${sh5} ./${TARGET_DIGESTS_dir}/* | grep -v '${TARGET_DIGESTS_file}.4' | grep -v 'cf83e' | grep -v 'SAM' | head -n 10 > ./${TARGET_DIGESTS_dir}/${TARGET_DIGESTS_file}.4
part456 4

${sco} -R 0:0 ./${TARGET_DIGESTS_dir}
${scm} 0555 ./${TARGET_DIGESTS_dir}
${scm} 0444 ./${TARGET_DIGESTS_dir}/*

[ ${debug} -eq 1 ] && ls -laRs ${TARGET_DIGESTS_dir}

