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

function usage() {
	echo "-x <source_file>:eXtracts <source_file> to ${CONF_squash0} source_file NEEDS TO HAVE ABSOLUTE PATH"
	echo "\t (source could be under /r/l/m/live) "

	echo "-y <iso_file> extracts <iso_file>/live/filesystem.squashfs to ${CONF_squash0} NEEDS TO HAVE ABSOLUTE PATH"
	echo "-b is supposed to be run just Before -c but after -r "
	echo "-d Destroys contents of ${CONF_squash0}/ "
	echo "\t if possible, use -b instead\n"

	echo "-c <target_file> [optional_params_4_mksquashfs?] : Compresses ${CONF_squash_dir} to <target_file> (with optional_params?)\n NEEDS TO HAVE ABSOLUTE PATH"
	echo "-r :runs chRoot in ${CONF_squash_dir} "
	
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
			[ -z "${2}" ] && exit 65
			[ -d ${2} ] || exit 66	
		;;
		-x|-y|-j)
			if [ -s ${2} ] || [ -d ${2} ] ; then
				par=${2}
			else
				exit 67
			fi

			cmd=${1}
		;;
		-c)
			par=${2}
			cmd=${1}
		;; 
	esac
}

function single_param() {
	dqb "sp ${1}"

	case "${1}" in
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
			[ -z "${cmd}" ] && cmd=${1}
		;;
	esac
}

. ${d}/common_funcs.sh
dqb "cmd=${cmd}"
dqb "par=${par}"

tmp=$(dirname $0)
. ${tmp}/sq22be.bash

case "${cmd}" in
	-x)
		#15726:tämä eivielä toiminut post-omega, setup2.bash konf sorkkimista jatkettava (VAIH)
		#19726:jo toimii? 

		xxx ${par} ${CONF_squash0}
	;;
	-y) #240526:"failed to setup loop device for " omegan jälk (according to the plan)
		
		[ -s ${par} ] || exit 66
		[ -d ${CONF_source} ] || ${smd} -p ${CONF_source}
		dqb "${som} -o loop,ro ${par} ${CONF_source}"

		${som} -o loop,ro ${par} ${CONF_source}
		[ $? -eq 0 ] || exit
		[ ${debug} -eq 1 ] && ls -las ${CONF_source}/live/

		if [ $? -eq 0 ] ; then
			csleep 3
			[ ${debug} -eq 1 ] && pwd
			csleep 3

			xxx ${CONF_source}/live/filesystem.squashfs ${CONF_squash0}
		fi

		${uom} ${CONF_source}
	;;
	-b)
		#vissiin dalek hoitaa hommansa ok 060626 (19726:toimii?)
		sudo ${tmp}/dalek.bash b
		#	fix_sudo $(pwd)
	;;
	-d)
		#vissiin dalek hoitaa hommansa ok 060626 (19726:toimii)
		odio=$(which sudo)
		${odio} ${tmp}/dalek.bash d2
	;;
	-c)
		#240526: jnkn verran toimi omegan ajon jälkeen
		cfd ${par} ${CONF_squash_dir}
	;;
	-r)
		[ -v CONF_squash_dir ] || exit 111
		[ -z "${CONF_squash_dir}" ] && exit 112

		rst_pre1
		rst ${CONF_squash_dir}
		dqb "how about removung those .bz3-files under squash?"
	;;
	-j)  #HUOM. sqash-hmstoin delliminen saattaa epäonnistua omegan jälkeen, pitäisikö huomioida jotenkin?
		dqb "smd= ${smd} "
		csleep 2

		#15726:saiko tämä jo toimimaan post-omega?
		#19726:jo toisen kerran?

		[ -d ${CONF_squash_dir}/${TARGET_pad2} ] || ${smd} -p ${CONF_squash_dir}/${TARGET_pad2}
		jlk_main ${par}/${TARGET_pad_dir} ${CONF_squash_dir}/${TARGET_pad2} #/
		
		if [ -z "${dir2}" ] ; then
			echo "--dir2 "
			exit 95
		fi

		if [ ! -d ${dir2} ] ; then
			echo "--dir2 "
			exit 96
		fi

		jlk_conf ${dir2}/${TARGET_pad_dir} $(whoami) ${CONF_squash_dir}/${TARGET_pad2}
		jlk_sums ${dir2}/${TARGET_DIGESTS_dir} ${CONF_squash_dir}/${TARGET_pad2}/${TARGET_DGST0}
		fix_sudo ${CONF_squash_dir}
	;;
	-f)  #161225:kai tämäkin toimii
		fix_sudo ${CONF_squash_dir}
	;;
	*)
		usage
	;;
esac
