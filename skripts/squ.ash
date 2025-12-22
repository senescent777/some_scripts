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
			[ -z ${2} ] && exit 65
			[ -d ${2} ] || exit 66	
		;;
		-x|-y|-j)
			if [ -s ${2} ] || [ -d ${2} ] ; then
				par=${2}
			else
				exit 67
			fi

			#[ -z ${2} ] && exit 65
			#191225:pitäisikö jotain lisätarkistruksia?
			cmd=${1}
		;;
		-c)
			#[ -z "${2}" ] && exit 68 jotain syystä ei toimi 
			#[ -s ${2} ] && exit 69

			par=${2}
			cmd=${1}
		;; 
	esac

	#if [ "${1}" != "--dir2" ] ; then #EI NÄIN
	#	cmd=${1} 
	#fi
}

#12125:cmd kantsisi asettaa vain jos tyhjä
function single_param() {
	dqb "sp ${1}"

	case ${1} in
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
dqb "cmd=${cmd}"
dqb "par=${par}"
#exit

tmp=$(dirname $0)
. ${tmp}/sq22be.ash

case ${cmd} in
	-x) #221225:toimii
	# ensin tämä sitten -j (vesi/happo/käsi/rakko) , -r nalq jos ei ./etc löydy
		xxx ${par} ${CONF_squash0}
	;;
	-y) #191225:toimii
		[ -s ${par} ] || exit 66 #xxx kyllä ...
		[ -d ${CONF_source} ] || ${smd} -p ${CONF_source}
		dqb "${som} -o loop,ro ${par} ${CONF_source}"

		${som} -o loop,ro ${par} ${CONF_source}
		[ $? -eq 0 ] || exit
		[ ${debug} -eq 1 ] && ls -las ${CONF_source}/live/

		if [ $? -eq 0 ] ; then
			csleep 3

			#[ ${debug} -eq 1 ] && dirname $0
			[ ${debug} -eq 1 ] && pwd
			csleep 3

			xxx ${CONF_source}/live/filesystem.squashfs ${CONF_squash0}
		fi

		${uom} ${CONF_source}
	;;
	-b) #221225:jos vaikka toimisi
		bbb ${CONF_squash_dir}
	;;
	-d)  #221225:toimii
		#TODO:pudon sudotus josqs? vaiko se sudoers?
		
		[ -v CONF_squash0 ] || exit 66
		[ -z "${CONF_squash0}" ] && exit 67
		pwd;sleep 6

		if [ x"${CONF_squash0}" != "x" ] ; then
			echo "${smr} -rf ${CONF_squash0}/* IN 6 SECS";sleep 6
			${smr} -rf ${CONF_squash0}/*
		fi
	;;
	-c)  #221225:toimii
		#HUOM:$par tarkistus löytyy fktiosta cfd
		cfd ${par} ${CONF_squash_dir}
	;;
	-r)
		#221225:toimii
		#tulisi sqroot-ymp ajaa se locale-gen mahd aik ni ehkä nalkutukset vähenisivät
		#081225:pitäisiköhän urputtaa jo ennen rst_kutsuja jos ei ole "$0 -x" ajettu?
		#TODO:muista myös roiskaista ne kuvakkeet filesystem.sqyash sisälle		

		#HUOM.221225:sqrootissa kandee poistaa ajo-oik common_lib:stä ni avaimet saa asennettua kätevästi
	
		[ -v CONF_squash_dir ] || exit 111
		[ -z "${CONF_squash_dir}" ] && exit 112

		#optionaalinen ajettava komento?
		rst_pre1
		rst ${CONF_squash_dir}
		
		dqb "how about removung those .bz3-files under squash?"
	;;
	-j)  #221225:taitaa toimia:
		dqb "smd= ${smd} "
		csleep 2

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

		#j_cnf tuo mukanaan sen sq-chroot-spesifisen konffin (tai siis muokkaa moisen olemaan)
		jlk_conf ${dir2}/${TARGET_pad_dir} ${n} ${CONF_squash_dir}
		
		#HUOM.201225:tarvitseekoko koko ko target_dgsts - hmistoa kopsata kohteeseen? riittäisikö vähempi?
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
