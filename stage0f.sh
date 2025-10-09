#!/bin/bash
debug=1 #pois taas kun isolinux.cfg kanssa asiat ok

. ./skripts/common.conf
. ./skripts/common_funcs.sh
. ./skripts/stage0_backend.bsh

if [ -f ./skripts/keys.conf ] ; then
	. ./skripts/keys.conf
fi

dqb "PARAMS OK?"
echo "VAIH:isolubnux.cfg";sleep 5

#TODO:jotenkin kätevösti pitäisi saada menemään juttujen kopioituminen squash-hmiston alle
#TODO:voisi olla jotain default-bootloader-konftdstoja jos ei v/$something alla ole
#TODO:CONF_T parametriksi?
#HUOM.12725:cp -a saattaisi olla fiksumpi kuin nämö kikkailut, graft-points vielä parempi
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
	#${odio} touch ${CONF_target}/${CONF_bloader}/* #saattaa vähän paskoa asioita

	default_process ${CONF_target}/live
	local src2=${2}/${TARGET_pad_dir}

	${scm} o+w ${CONF_target}/${TARGET_pad_dir}
	${odio} touch ${CONF_target}/${TARGET_pad_dir}/${n}.conf
	${scm} 0644 ${CONF_target}/${TARGET_pad_dir}/${n}.conf
	${sco} ${n}:${n} ${CONF_target}/${TARGET_pad_dir}/${n}.conf
	${scm} o-w ${CONF_target}/${TARGET_pad_dir}

	dqb "BEFORE COPY_x"
	csleep 1

	#älämölöt aiemmaksi
	[ -v TARGET_DIGESTS_dir ] || exit 666
	[ -v TARGET_DGST0 ] || exit 666
	dqb "OUYG)(&R()%¤ER"

	#HUOM.04§025:täsä kohtaa tökkää, kts toistuuko
	[ -z ${TARGET_DIGESTS_dir} ] && exit 65
	dqb "56448748765484"

	[ -z ${TARGET_DGST0} ] && exit 66
	dqb "ÄÖ_ÅPÄÖÖÅPO"

	#HUOM.11725:linkitys-syistä oli "/" 1. param lopussa, ehkä pois jatkossa ?
	copy_main ${src2} ${CONF_target}/${TARGET_pad_dir} ${CONF_scripts_dir}
	copy_conf ${src2} ${n} ${CONF_target}/${TARGET_pad_dir}
	copy_sums ${src2}/${TARGET_DGST0} ${CONF_target}/${TARGET_DIGESTS_dir}
	
	dqb "4FT3R COPY_X"
	csleep 1

	${odio} touch ${CONF_target}/${TARGET_pad_dir}/*
	${scm} 0444 ${CONF_tmpdir}/*.conf
	${scm} 0755 ${CONF_tmpdir}/*.sh
	
	#TODO:omaksi fktioksi va maksasko vaivaa 1 rivin takia?
	#TODO:sen pad-hmiston omistajuuden pakotus (d:d ei hyvä, ehkä)
	#keys-hmistossa ei juuri nyt taida olla .gpg-tdstoja... (081025)

	${spc} ${CONF_keys_dir}/*.gpg ${CONF_target}/${TARGET_DIGESTS_dir}
	default_process ${CONF_target}/${TARGET_pad_dir}

	${scm} 0555 ${CONF_target}/${TARGET_pad_dir}/*.sh
	${sco} -R ${n}:${n} ${CONF_target}/${TARGET_DIGESTS_dir}
	
	${scm} 0555 ${CONF_target}/live
	${scm} 0755 ${CONF_target}/${TARGET_DIGESTS_dir}

	dqb "part0 d0ne"
}

make_tgt_dirs ${CONF_target} ${CONF_source} ${3} #CONF_bloader}

if [ -d ${1} ] ; then
	part0 ${1} ${2} ${3}
else
	if [ -s ${1} ] && [ -r ${1} ] ; then #tössö jokin qsee 041025
		dqb "${som} -o loop,ro ${1} ${CONF_source}"
		csleep 3

		${som} -o loop,ro ${1} ${CONF_source} 
		[ $? -eq 0 ] || exit 666
		sleep 6

		#[ ${debug} -eq 1 ] && ls -las ${CONF_target}
		#csleep 4

		part0 ${CONF_source} ${2} ${3}	
		${uom} ${CONF_source} 
	else
		echo "https://www.youtube.com/watch?v=KnH2dxemO5o";exit 666	
	fi 
fi

dqb "MKSUMS.SH"