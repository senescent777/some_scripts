#!/bin/bash

. ./skripts/common.conf
. ./skripts/common_funcs.sh
. ./skripts/stage0_backend.bsh

#	echo "https://www.youtube.com/watch?v=KnH2dxemO5o";exit 666
#fi

dqb "PARAMS OK?"
n=devuan 
make_tgt_dirs

function part0() {
	dqb "PART0 ${1} ${2} ${3}"

	for f in ./filesystem.squashfs ./vmlinuz ./initrd.img ; do
		if [ -s ${2}/live/${f} ] ; then
			${spc} ${2}/live/${f} ${CONF_target}/live
		else
			${spc} ${1}/live/${f} ${CONF_target}/live
		fi
	done

	default_process ${CONF_target}/live
	local src2=${2}/${TARGET_pad_dir}

	${scm} o+w ${CONF_target}/${TARGET_pad_dir}
	${odio} touch ${CONF_target}/${TARGET_pad_dir}/${n}.conf
	${scm} 0644 ${CONF_target}/${TARGET_pad_dir}/${n}.conf
	${sco} ${n}:${n} ${CONF_target}/${TARGET_pad_dir}/${n}.conf
	${scm} o-w ${CONF_target}/${TARGET_pad_dir}

	copy_main ${src2} ${CONF_target}/${TARGET_pad_dir}
	copy_conf ${src2} ${n} ${CONF_target}/${TARGET_pad_dir}
	copy_sums ${src2} ${CONF_target}/${TARGET_digests_dir}
	
	${odio} touch ${CONF_target}/${TARGET_pad_dir}/*
	${scm} 0444 ${CONF_tmpdir}/*.conf
	${scm} 0755 ${CONF_tmpdir}/*.sh
	
	${spc} ${CONF_keys_dir}/*.gpg ${CONF_target}/${TARGET_DIGESTS_dir}

	default_process ${CONF_target}/${TARGET_pad_dir}
	${scm} 0555 ${CONF_target}/${TARGET_pad_dir}/*.sh
	${sco} -R ${n}:${n} ${CONF_target}/${TARGET_DIGESTS_dir}

	bootloader ${CONF_bloader} ${src2}/.. ${CONF_source}
	${odio} touch ${CONF_target}/${CONF_bloader}/*
	
	${scm} 0555 ${CONF_target}/live
	${scm} 0755 ${CONF_target}/${TARGET_DIGESTS_dir}

	dqb "part0 d0ne"
}

if [ -s ${1} ] ; then
	${som} -o loop,ro ${1} ${CONF_source} 
	[ $? -eq 0 ] || exit 666
	sleep 6

	part0 ${CONF_source} ${2} ${3}	
	${uom} ${CONF_source} 
else
	if [ -d ${1} ] ; then
		part0 ${1} ${2} ${3}
	else
		echo "https://www.youtube.com/watch?v=KnH2dxemO5o";exit 666
	fi
fi 

dqb "MKSUMS.SH"
