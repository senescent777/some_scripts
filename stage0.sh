#!/bin/bash
debug=0
. ./skripts/common.conf
base=""
source2=""
bl=${CONF_bloader}

if [ $# -lt 1 ] ; then
	echo "$0 -h"
	exit
fi

function usage() {
	echo "${0} --base <BASE> --add <THINGS_TO_ADD> [--bl BLOADER] [--v <verbosity_level>]"
	echo "${0} --get-devuan <download_dir>"
	echo "${0} -d Destroys contents of ${CONF_tmpdir}"
	echo "${0} --make-dirs creates some dirs under ${CONF_tmpdir}"
}

. ./skripts/stage0_backend.bsh

function parse_opts_real() {
	dqb "douböe(${1} , ${2})"

	case ${1} in
		--base)
			base=${2}
		;;
		--add)
			source2=${2}
		;;
		--get-devuan)
			get_devuan ${2}
			exit
		;;
	esac	
}

function single_param() {
	dqb "subgle(${1} , ${2})"

	case ${1} in
		--make-dirs)
			#init.bash käskyttämään tätä case:a tarvittaessa?
			make_src_dirs ${CONF_bloader}
			make_tgt_dirs ${CONF_target} ${CONF_source} ${CONF_bloader} #VAIH:params
			exit
		;;
		-d)
			[ -v CONF_tmpdir ] || exit 68

			#TODO:man chattr pitkästä aikaa
			#081225:v-hmiston alta jotain siivoilua myös?
			if [ x"${CONF_tmpdir}" != "x" ] ; then 
				echo "${smr} -rf ${CONF_tmpdir}/* IN 6 SECS";sleep 6	
				${smr} -rf ${CONF_tmpdir}/*
			fi

			exit
		;;
	esac

	#exit 13
}

. ./skripts/common_funcs.sh

if [ -d ${CONF_tmpdir0} ] ; then
	dqb "CONF_TMPDIR0 EXISTS"
else
	echo "s.HOULD mkdir ${CONF_TMPDIR0}"
	exit 7
fi

#stage0f==glorified cp
#dqb "mkdir -p ./v/smthing;mkdir -p ./v/smthing/{isolinux,grub};ln -s ~/Desktop/minimize ./v/something/pad ?"
echo "./stage0f.sh ${base} ${source2} ${bl} ${debug}"