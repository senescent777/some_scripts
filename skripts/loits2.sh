#!/bin/bash
debug=1
if [ -s ./common.conf ] ; then
	. ./common.conf
else
	echo "NO CONF"
fi

if [ -x ./common_funcs.sh ] ; then
	. ./common_funcs.sh
else
	echo "N0 FUNCS"
fi

protect_system

ltarget="" 
bloader=""
#exit

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

	#[ x"${CONF_target}" != "x" ] || exit 100
	dqb "TGT OK"
	#[ x"${CONF_bloader}" != "x" ] || exit 101
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
	[ -s ${1}/${TARGET_pad_bak_file} ] && mk_bkup ${1}/${TARGET_pad_bak_file}
	
	local tpop=""
	#To State The Obvious:välistä puuttuu jotain
	tar ${tpop} ${TARGET_DTAR_OPTS} ${TARGET_DTAR_OPTS_LOITS} -cf ${1}/${TARGET_pad_bak_file} ./${TARGET_pad_dir}
}

check_params ${lsrcdir} ${ltarget} ${bloader}
enforce_deps

#[ y"${gv}" != "y" ] || inst_dep 0
#[ x"${gi}" != "x" ] || inst_dep 1

#n=$(whoami)
lsrcdir=./${lsrcdir}

${sco} -R ${n}:${n} ${CONF_target}/../out
${scm} 0755 ${CONF_target}/../out

olddir=$(pwd)
cd ${lsrcdir}

if [ -d ${TARGET_pad_dir} ] ; then 
	make_tar ${CONF_target}/../out

else
	echo "${TARGET_pad_dir} missing"
fi

${sco} -R ${n}:${n} .
${scm} 0755 ./${CONF_bloader}

case ${bloader} in
	isolinux)
		${sco} ${n}:${n} ./isolinux/isolinux*
		${scm} 0644 ./isolinux/isolinux*
		
		${gi} -o ${CONF_target}/../out/${ltarget} ${CONF_gi_opts} .
		[ $? -eq 0 ] || echo "${sco} -R ${n}:${n} ./isolinux && ${scm} 0755 ./isolinux"

	;;
	*)
		echo "bl= ${bloader}"
		echo "https://www.youtube.com/watch?v=KnH2dxemO5o" 
	;;
esac

${scm} 0555 ./${CONF_bloader}
${scm} 0444 ./${CONF_bloader}/*
${sco} -R 0:0 .
cd ${olddir}

sleep 1
echo "stick.sh ?"
