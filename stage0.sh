#!/bin/bash
debug=1

. ./skripts/common.conf
. ./skripts/common_funcs.sh
. ./skripts/stage0_backend.bsh

base=""
source2=""
bl=${CONF_bloader}

function usage() {
	echo "${0} --base <BASE> --add <THINGS_TO_ADD> [--bl BLOADER] [--v <verbosity_level>]"
	#echo "(<THINGS_TO_ADD> is path relative to ${CONF_BASEDIR})" #pitäisi varmaan huomoida tuo suhteellisuus?
	echo "${0} --get-devuan <download_dir>"
	echo "${0} --make-dirs"
}

function parse_opts_real() {
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
		--bl|-bl)
			bl=${2}
		;;
	esac	
}

function single_param() {
	case ${1} in
		--make-dirs)
			#TODO:init.sh käskyttämään tätä case:a tarvittaessa?
			make_src_dirs
			make_tgt_dirs
		;;
		--h)
			usage
		;;
	esac
}

if [ -d ${CONF_tmpdir0} ] ; then
	dqb "CONF_TMPDIR0 EXISTS"
else
	echo "CONF_TMPDIR0"
	exit 7
fi

if [ $# -gt 0 ] ; then
	parse_opts ${1} ${2}
	parse_opts ${3} ${4}
	parse_opts ${5} ${6}
	parse_opts ${7} ${8}
	parse_opts ${9} ${10}
else
	usage
fi

#stage0f==glorified cp
dqb "mkdir -p ./v/smthing;mkdir -p ./v/smthing/{isolinux,grub};ln -s ~/Desktop/minimize ./v/something/pad ?"
echo "./stage0f.sh ${base} ${source2} ${bl} <verbosity_level>"

