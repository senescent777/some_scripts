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
. ./skripts/stage0_backend.bsh
. ./skripts/common_funcs.sh
#if [ -f ./skripts/keys.conf ] ; then #HUOM.141025:kts. copy_sums()
#	. ./skripts/keys.conf
#fi

dqb "PARAMS OK?"

#TEHTY?:jotenkin kätevösti pitäisi saada menemään juttujen kopioituminen squash-hmiston alle
#TODO:voisi olla jotain default-bootloader-konftdstoja jos ei v/$something alla ole
#TODO:CONF_T parametriksi?
#HUOM.12725:cp -a saattaisi olla fiksumpi kuin nämä kikkailut, graft-points vielä parempi
function part0() {
	#debug=1
	dqb "PART0 ${1}, ${2} , ${3}"
	pwd
	csleep 2

	dqb "COPY1NG FILES IN 1 SEC"
	csleep 1

	#ei aina tarttisi näiTä renkata
	for f in ./filesystem.squashfs ./vmlinuz ./initrd.img ; do
		if [ -s ${2}/live/${f} ] ; then
			${spc} ${2}/live/${f} ${CONF_target}/live
		else
			dqb "${1}/live/${f}"
			${spc} ${1}/live/${f} ${CONF_target}/live
		fi
		
		dqb "NECKST"
		csleep 1
	done

	#efi uutena 13725
	dqb "${spc} -a ${1}/efi ${CONF_target}"
	${spc} -a ${1}/efi ${CONF_target}
	csleep 1

	#lähde voi olla muukin kuin mountattu .iso, siksi ei enää 	CONF_SOURCE
	bootloader ${3} ${2} ${1} 
	
	default_process ${CONF_target}/live
	local src2=${2}/${TARGET_pad_dir}

	${scm} o+w ${CONF_target}/${TARGET_pad_dir}
	${odio} touch ${CONF_target}/${TARGET_pad_dir}/${n}.conf
	${scm} 0644 ${CONF_target}/${TARGET_pad_dir}/${n}.conf
	${sco} ${n}:${n} ${CONF_target}/${TARGET_pad_dir}/${n}.conf
	${scm} o-w ${CONF_target}/${TARGET_pad_dir}

	dqb "BEFORE COPY_x"
	csleep 1

	[ -v TARGET_DIGESTS_dir ] || exit 666
	[ -v TARGET_DGST0 ] || exit 666
	dqb "OUYG)(&R()%¤ER"

	[ -z ${TARGET_DIGESTS_dir} ] && exit 65
	dqb "56448748765484"

	[ -z ${TARGET_DGST0} ] && exit 66
	dqb "ÄÖ_ÅPÄÖÖÅPO"

	#HUOM.11725:linkitys-syistä oli "/" 1. param lopussa, ehkä pois jatkossa ?

	copy_main ${2}/${TARGET_pad_dir} ${CONF_target}/${TARGET_pad_dir} ${CONF_scripts_dir}
	copy_conf ${2}/${TARGET_pad_dir} ${n} ${CONF_target}/${TARGET_pad_dir}
	copy_sums ${2}/${TARGET_DIGESTS_dir} ${CONF_target}/${TARGET_DIGESTS_dir}
	
	dqb "4FT3R COPY_X"
	csleep 1

	${odio} touch ${CONF_target}/${TARGET_pad_dir}/*
	${scm} 0444 ${CONF_tmpdir}/*.conf
	${scm} 0755 ${CONF_tmpdir}/*.sh
	
	#keys-hmistossa ei juuri nyt taida olla .gpg-tdstoja... (081025)

	${spc} ${CONF_keys_dir}/*.gpg ${CONF_target}/${TARGET_DIGESTS_dir}
	default_process ${CONF_target}/${TARGET_pad_dir}
	[ ${debug} -eq 1 ] && ls -las ${CONF_target}
	csleep 10

	${scm} 0555 ${CONF_target}/${TARGET_pad_dir}/*.sh
	${sco} -R ${n}:${n} ${CONF_target}/${TARGET_DIGESTS_dir}
	
	${scm} 0555 ${CONF_target}/live
	${scm} 0755 ${CONF_target}/${TARGET_DIGESTS_dir}

	dqb "part0 d0ne"
}

dqb "src= ${1} , stc2= ${2} , bl= ${3}"
[ -v CONF_source ] || exit 666
[ -v CONF_target ] || exit 666
make_tgt_dirs ${CONF_target} ${CONF_source} ${3}

if [ -d ${1} ] ; then
	part0 ${1} ${2} ${3}
else
	if [ -s ${1} ] && [ -r ${1} ] ; then #vieläkö tässä jokin qsee 111025?
		dqb "${som} -o loop,ro ${1} ${CONF_source}"
		csleep 3

		${som} -o loop,ro ${1} ${CONF_source} 
		[ $? -eq 0 ] || exit 666
		sleep 6

		part0 ${CONF_source} ${2} ${3}	
		${uom} ${CONF_source} 
	else
		echo "https://www.youtube.com/watch?v=KnH2dxemO5o";exit 666	
	fi 
fi

dqb "MKSUMS.SH"