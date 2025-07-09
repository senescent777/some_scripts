#!/bin/bash

. ./skripts/common.conf
. ./skripts/common_funcs.sh
. ./skripts/stage0_backend.bsh

#	echo "https://www.youtube.com/watch?v=KnH2dxemO5o";exit 666
#fi

echo "PARAMS OK"
n=devuan 
make_tgt_dirs

function part0() {
	echo "PART0 ${1} ${2} ${3}"

	for f in ./filesystem.squashfs ./vmlinuz ./initrd.img ; do
		if [ -s ${2}/live/${f} ] ; then
			sudo cp ${2}/live/${f} ${CONF_target}/live
		else
			sudo cp ${1}/live/${f} ${CONF_target}/live
		fi
	done

	default_process ${CONF_target}/live
	local src2=${2}/${TARGET_pad_dir}

	sudo chmod o+w ${CONF_target}/${TARGET_pad_dir}
	sudo touch ${CONF_target}/${TARGET_pad_dir}/${n}.conf
	sudo chmod 0644 ${CONF_target}/${TARGET_pad_dir}/${n}.conf
	sudo chown ${n}:${n} ${CONF_target}/${TARGET_pad_dir}/${n}.conf
	sudo chmod o-w ${CONF_target}/${TARGET_pad_dir}

	copy_main ${src2} ${CONF_target}/${TARGET_pad_dir}
	copy_conf ${src2} ${n} ${CONF_target}/${TARGET_pad_dir}
	copy_sums ${src2} ${CONF_target}/${TARGET_digests_dir}
	
	sudo touch ${CONF_target}/${TARGET_pad_dir}/*
	sudo chmod 0444 ${CONF_tmpdir}/*.conf
	sudo chmod 0755 ${CONF_tmpdir}/*.sh
	
	sudo cp ${CONF_keys_dir}/*.gpg ${CONF_target}/${TARGET_DIGESTS_dir}

	default_process ${CONF_target}/${TARGET_pad_dir}
	sudo chmod 0555 ${CONF_target}/${TARGET_pad_dir}/*.sh
	sudo chown -R ${n}:${n} ${CONF_target}/${TARGET_DIGESTS_dir}

	bootloader ${CONF_bloader} ${src2}/.. ${CONF_source}
	sudo touch ${CONF_target}/${CONF_bloader}/*
	
	sudo chmod 0555 ${CONF_target}/live
	sudo chmod 0755 ${CONF_target}/${TARGET_DIGESTS_dir}
}

if [ -s ${1} ] ; then
	sudo mount -o loop,ro ${1} ${CONF_source} 
	[ $? -eq 0 ] || exit 666
	sleep 6

	part0 ${CONF_source} ${2} ${3}	
	sudo umount ${CONF_source} 
else
	if [ -d  ${1} ] ; then
		part0 ${1} ${2} ${3}
	else
		echo "https://www.youtube.com/watch?v=KnH2dxemO5o";exit 666
	fi
fi 

echo "MKSUMS.SH"
