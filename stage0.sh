#!/bin/bash
debug=1

. ./skripts/common.conf
. ./skripts/common_funcs.sh
. ./skripts/stage0_backend.bsh

base=""
source2=""
n=devuan 

function usage() {
	echo "${0} --base <BASE> --add <THINGS_TO_ADD> [--v <verbosity_level>]"
	echo "(<THINGS_TO_ADD> is path relative to ${CONF_BASEDIR})"
	echo "${0} --get-devuan <download_dir>"
	echo "${0} --make-dirs"
}

function parse_opts_real() {
	case ${1} in
		--base)
			base=${2}
		;;
		--add)
			source2=${2}/${TARGET_pad_dir}
		;;
		--get-devuan)
			get_devuan ${2}
			exit
		;;
	esac	
}

function single_param() {
	case ${1} in
		--make-dirs)
			#HUOM.9725:init.sh voisi hyödyntää tätä
			make_dirs #ei ihan samaq make_target_dirs?
		;;
		--h)
			usage
		;;
	esac
}

[ -d ${CONF_tmpdir0} ] || exit 7

parse_opts ${1} ${2}
parse_opts ${3} ${4}
parse_opts ${5} ${6}
parse_opts ${7} ${8}
parse_opts ${9} ${10}

#stage0f==glorified cp
echo "./stage0f.sh ${base} ${source2} <verbosity_level>"

