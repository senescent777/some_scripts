#!/bin/bash
debug=0
src=""
bl=""
. ./skripts/common.conf

function usage() {
	echo "$0 <src1> <stuff_to_add> <bloader> [debug?]"
}

function parse_opts_real() {
	dqb "TODO:parse_opts_real() ? "
}

function single_param() {
	dqb "TODO:  single_param() ?"
}

[ $# -gt 3 ] && debug=${4}
. ./skripts/stage0_backend.bash
. ./skripts/common_funcs.sh

if [ -f ./skripts/keys.conf ] ; then #161225 laitettu takaisin syystä
	. ./skripts/keys.conf
fi

dqb "PARAMS OK?"

#TODO:voisi olla jotain default-bootloader-konftdstoja jos ei v/$something alla ole
#HUOM.12725:cp -a saattaisi olla fiksumpi kuin nämä kikkailut, graft-points vielä parempi
function part0() {
	dqb "stg0f.PART0 ${1}, ${2} , ${3} , ${4}"
	pwd
	csleep 2

	dqb "COPY1NG FILES IN 1 SEC"
	csleep 1

	for f in ./filesystem.squashfs ./vmlinuz ./initrd.img ; do
		if [ -s ${2}/live/${f} ] ; then
			${spc} ${2}/live/${f} ${4}/live
		else
			dqb "${1}/live/${f}"
			${spc} ${1}/live/${f} ${4}/live
		fi
		
		dqb "NECKST"
		csleep 1
	done

	#efi uutena 13725
	dqb "${spc} -a ${1}/efi ${4}"
	${spc} -a ${1}/efi ${4}
	csleep 1

	#lähde voi olla muukin kuin mountattu .iso, siksi ei enää CONF_SOURCE
	#191225;josko vähitellen jotain sen oletus-bloader.konfiguraation hyväksi?
	bootloader ${3} ${2} ${1} ${CONF_target}
	
	#default_process ${4}/live
	local src2=${2}/${TARGET_pad_dir}
	${scm} o+w ${4}/${TARGET_pad_dir}

	fasdfasd ${4}/${TARGET_pad_dir}/${n}.conf

	${scm} o-w ${4}/${TARGET_pad_dir}
	dqb "BEFORE COPY_x"
	csleep 1

	[ -v TARGET_DIGESTS_dir ] || exit 666
	[ -v TARGET_DGST0 ] || exit 666
	dqb "QGDRU JbHA D 666"

	[ -z ${TARGET_DIGESTS_dir} ] && exit 65
	dqb "56448748765484"

	[ -z ${TARGET_DGST0} ] && exit 66
	dqb "AAPPO.iPIIPP0"

	#HUOM.11725:linkitys-syistä oli "/" 1. param lopussa, ehkä pois jatkossa ?

	copy_main ${2}/${TARGET_pad_dir} ${4}/${TARGET_pad_dir} ${CONF_scripts_dir}
	copy_conf ${2}/${TARGET_pad_dir} ${4}/${TARGET_pad_dir} ${n}
	copy_sums ${2}/${TARGET_DIGESTS_dir} ${4}/${TARGET_DIGESTS_dir}
	
	dqb "4FT3R COPY_X"
	csleep 1

	${odio} touch ${4}/${TARGET_pad_dir}/*
	${scm} 0444 ${CONF_tmpdir}/*.conf
	${scm} 0555 ${CONF_tmpdir}/*.sh
	
	#161225 liittyen kts keyutl.bash

#	#191225:tarkoituksella eriniminen Const, lisäillään kohdehmistoon vain jos oletusavain-hmisto olemassa
#	#...tosin voi nyt konfliktoida copy_sums():in else-haaran kanssa
#	if [ -v CONF_keys_dir_pub2 ] ; then
#		if [ ! -z ${CONF_keys_dir_pub2}} ] ; then
#			if [ -d ${CONF_keys_dir_pub2} ] ; then
#				dqb "${spc} ${CONF_keys_dir_pub}/*.gpg ${4}/${TARGET_DIGESTS_dir}"
#				csleep 1
#				${spc} ${CONF_keys_dir_pub2}/*.gpg ${4}/${TARGET_DIGESTS_dir}
#			fi
#		fi
#	fi

	#default_process ${4}/${TARGET_pad_dir}
	[ ${debug} -eq 1 ] && ls -las ${4}
	csleep 10

	${scm} 0555 ${4}/${TARGET_pad_dir}/*.sh
	${sco} -R ${n}:${n} ${4}/${TARGET_DIGESTS_dir}
	
	${scm} 0555 ${4}/live
	${scm} 0755 ${4}/${TARGET_DIGESTS_dir}

	dqb "part0 d0ne"
}

dqb "src= ${1} , stc2= ${2} , bl= ${3}"
[ -v CONF_source ] || exit 666
[ -v CONF_target ] || exit 666
make_tgt_dirs ${CONF_target} ${CONF_source} ${3}

if [ -d ${1} ] ; then
	part0 ${1} ${2} ${3} ${CONF_target}
else
	if [ -s ${1} ] && [ -r ${1} ] ; then #151225:nyt toimii kun common_funcs muutettu
		dqb "${som} -o loop,ro ${1} ${CONF_source}"
		csleep 3

		${som} -o loop,ro ${1} ${CONF_source} 
		[ $? -eq 0 ] || exit 666
		sleep 6

		part0 ${CONF_source} ${2} ${3} ${CONF_target}	
		${uom} ${CONF_source} 
	else
		echo "https://www.youtube.com/watch?v=KnH2dxemO5o";exit 666	
	fi 
fi

dqb "MKSUMS.SH"
