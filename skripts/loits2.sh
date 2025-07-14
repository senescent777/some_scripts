#!/bin/bash

debug=1
d=$(dirname $0)

if [ -s ${d}/common.conf ] ; then
	. ${d}/common.conf
else
	echo "NO CONF"
fi

if [ -x ${d}/common_funcs.sh ] ; then
	. ${d}/common_funcs.sh
else
	echo "N0 FUNCS"
fi

ltarget="" 
bloader=""

function usage() {

	echo "${0} --in <SOURCE_DIR> --out <OUTFILE> [ --bl <BOOTLOADER> ]"
	exit 666
}

function parse_opts_real() {
	dqb "parse_opts_real( ${1}, ${2})"

	case ${1} in
		--in)
			lsrcdir=${2}
		;;
		--out)
			ltarget=${2}
		;;
		--bl) 
			bloader=${2}
		;; 
		*)
			usage
		;;
	esac
}

function single_param() {
	dqb "signle_param ( ${1} , ${2} )"
}

if [ $# -gt 0 ] ; then
	parse_opts ${1} ${2}
	parse_opts ${3} ${4}
	parse_opts ${5} ${6}
	parse_opts ${7} ${8}
else
	usage
fi

function check_params() {
	dqb "check_pars( ${1}, ${2}, ${3})"
	dqb "TGT OK"
	dqb "BLDR 0K"

	if [ -d ./${1} ] ; then
		echo "DIR OK" #jatkossa dqb
	else
		echo "no such thing as ${1}"
		exit 102
	fi
	
	if [ x"${2}" != "x" ] ; then 

		if [ -s out/${2} ] ; then
			echo "out/${2} already exists"

			exit 103
		fi
	else
		exit 104
	fi

	if [ x"${3}" != "x" ] ; then
		echo "BLADDER OK" #jatkossa dqb

	else
		bloader=${CONF_bloader}
	fi

	dqb "check_pars_done"
}

function make_tar() {
	dqb "make_tar(${1})"
	[ -s ${1}/${TARGET_pad_bak_file} ] && mk_bkup ${1}/${TARGET_pad_bak_file}
	
	local tpop=""
	#To State The Obvious:välistä puuttuu jotain
	[ ${debug} -eq 1 ] && tpop="-v "
	dqb "tar ${tpop} ${TARGET_DTAR_OPTS} ${TARGET_DTAR_OPTS_LOITS} -cf ${1}/${TARGET_pad_bak_file} ./${TARGET_pad_dir}"

	tar ${tpop} ${TARGET_DTAR_OPTS} ${TARGET_DTAR_OPTS_LOITS} -cf ${1}/${TARGET_pad_bak_file} ./${TARGET_pad_dir}
}

check_params ${lsrcdir} ${ltarget} ${bloader}
enforce_deps

case ${bloader} in
	isolinux)
		${sco} ${n}:${n} ./isolinux/isolinux*
		${scm} 0644 ./isolinux/isolinux*
		
		dqb "next: ${gi} -o ${ltarget} ${CONF_gi_opts} ."
		${gi} -o ${ltarget} ${CONF_gi_opts} .
		[ $? -eq 0 ] || echo "${sco} -R ${n}:${n} ./isolinux && ${scm} 0755 ./isolinux"
	;;
	*)
		echo "bl= ${bloader}"

		echo "https://www.youtube.com/watch?v=KnH2dxemO5o" 
	;;
esac

sleep 1
echo "stick.sh ?"
