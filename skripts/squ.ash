#!/bin/bash
debug=0 #1
dir2=""
cmd=""
md=0
mp=0
ms=0
par=""

d=$(dirname $0)
. ${d}/common.conf

#ennen vai jälkeen parse_opts esittelyn?
function usage() {
	echo "-x <source_file>:eXtracts <source_file> to ${CONF_squash0} source_file NEEDS TO HAVE ABSOLUTE PATH"
	echo "\t (source could be under /r/l/m/live) "

	echo "-y <iso_file> extracts <iso_file>/live/filesystem.squashfs to ${CONF_squash0} NEEDS TO HAVE ABSOLUTE PATH"
	echo "-b is supposed to be run just Before -c but after -r "
	echo "-d Destroys contents of ${CONF_squash0}/ "
	echo "\t if possible, use -b instead\n"

	echo "-c <target_file> [optional_params_4_mksquashfs?] : Compresses ${CONF_squash_dir} to <target_file> (with optional_params?)\n NEEDS TO HAVE ABSOLUTE PATH"
	echo "-r :runs chRoot in ${CONF_squash_dir} "
	
	#echo "-i <src> : Installs scripts 2 chroot_dir  "
	echo "-j <src> [ --dir2 <stuff> ] : extracts dir 2 chroot_dir  NEEDS TO HAVE ABSOLUTE PATH"
	echo "\t to state the obvious:"
	echo "\t <stuff> in --dir2 has to contain sub-directory ${TARGET_DIGESTS_dir} , for example ${CONF_target} "
	echo "\t ... and <src> has to contain subdirectory ${TARGET_pad_dir} \n"

	echo "-f attempts to Fix some problems w/ sudo "
	echo "--v 1 adds Verbosity\n"

	echo "--mp,--md, --ms:abt mounting some pseudo-filesystems 4 -r " 
	echo "\t potentially dangerous, so disabled by default , 1 enables"
}

function parse_opts_real() {
	dqb "squash.parse_opts_real(${1}, ${2})"

	case ${1} in
		--dir2)
			dir2=${2}
			[ -z ${2} ] && exit 65
			[ -d ${2} ] || exit 66	
		;;
		-x|-y|-i|-j)
			if [ -s ${2} ] || [ -d ${2} ] ; then
				par=${2}
			else
				exit 67
			fi

			#[ -z ${2} ] && exit 65	
			cmd=${1}
		;;
		-c)
			[ -z ${2} ] && exit 68
			[ -s ${2} ] && exit 69

			par=${2}
			cmd=${1}
		;; 
	esac

	#if [ "${1}" != "--dir2" ] ; then #EI NÄIN
	#	cmd=${1} 
	#fi
}

function single_param() {
	dqb "sp ${1}"

	case ${1} in
		#ao.jutut jatkossa single_param
		-mp|--mp)
			mp=1
		;;
		-md|--md)
			md=1
		;;
		-ms|--ms)
			ms=1
		;;
		-f|-r|-d|-b)
			cmd=${1}
		;;
	esac
}

. ${d}/common_funcs.sh
#VAIH:JOSKO JO SE PARSETUSONGELMA

dqb "cmd=${cmd}"
dqb "par=${par}"
#exit

tmp=$(dirname $0)
. ${tmp}/sq22be.ash

case ${cmd} in
	-x) #HUOM.091025:havaittu toimivaksi (myös 141025)
		xxx ${par} ${CONF_squash0}
	;;
	-y) #TODO:TESTAA UUDESTAAN
		#... vaan miten se -v tämän option kanssa?

		[ -s ${par} ] || exit 666
		[ -d ${CONF_source} ] || ${smd} -p ${CONF_source}
		dqb "${som} -o loop,ro ${par} ${CONF_source}"

		oldd=$(pwd)
		${som} -o loop,ro ${par} ${oldd}/${CONF_source}

		[ $? -eq 0 ] || exit
		[ ${debug} -eq 1 ] && ls -las ${oldd}/${CONF_source}/live/
		csleep 3

		#[ ${debug} -eq 1 ] && dirname $0
		[ ${debug} -eq 1 ] && pwd
		csleep 3

		xxx ${oldd}/${CONF_source}/live/filesystem.squashfs ${CONF_squash0}
		${uom} ${oldd}/${CONF_source}
	;;
	-b) #141025:OK?
		bbb ${CONF_squash_dir}
		#TODO;jhnkin se squash/pad-hmistn omistajuuden pakotus
	;;
	-d)  #141025:OK
		[ -v CONF_squash0 ] || exit 66
		[ -z CONF_squash0 ] && exit 67
		pwd;sleep 6

		if [ x"${CONF_squash0}" != "x" ] ; then
			echo "${smr} -rf ${CONF_squash0}/* IN 6 SECS";sleep 6
			${smr} -rf ${CONF_squash0}/*
		fi
	;;
	-c)  #TODO:TESTAA UUDESTAAN
		#HUOM.tässäkin -v aiheutti urputuksen, tee jotain(TODO)
		cfd ${par} ${CONF_squash_dir}
	;;
	-r)  #141025:OK?
		[ -v CONF_squash_dir ] || exit 666
		[ -z ${CONF_squash_dir} ] && exit 666

		#optionaalinen ajettava komento?
		rst_pre1
		rst ${CONF_squash_dir}
	;;
	-j)  #OK?
		#jlk_jutut jollain atavlla yhdistäen stage0_backend:in juttujen kanssa?
		[ -d ${CONF_squash_dir}/${TARGET_pad2} ] || ${smd} -p ${CONF_squash_dir}/${TARGET_pad2}

		jlk_main ${par}/${TARGET_pad_dir} ${CONF_squash_dir}/${TARGET_pad2}/
		
		#jatkossa jo s ei erikseen dir2? , vaan -j jälkeen voisi tulla uaseampi hakemisto?
		#VAIH:joko jo alkaisi suorittaa dor2 suhteen?

		[ z"${dir2}" != "z" ] || echo "--dir2 "
		[ -d ${dir2} ] || echo "--dir2 "

		#j_cnf tuomaan mukanaan sen sq-chroot-spesifisaen konffin?
		jlk_conf ${dir2}/${TARGET_pad_dir} ${n} ${CONF_squash_dir}

		jlk_sums ${dir2}/${TARGET_DIGESTS_dir} ${CONF_squash_dir}/${TARGET_pad_dir}/${TARGET_DGST0}
		fix_sudo ${CONF_squash_dir}
	;;
	-f)  #151025:OK?
		fix_sudo ${CONF_squash_dir}
	;;
	*)
		usage
	;;
esac
