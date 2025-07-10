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
			#make_dirs #ei ihan samaq make_target_dirs?

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
#HUOM.9725:saattanee jo onnistua "--add"-vivulla lisäillä asioita
#tosin muistettava sitten viskoa isolinux.cfg ~ alle ja muuta kikkailua kunnes x

dqb "mkdir -p ./v/smthing;mkdir -p ./v/smthing/{isolinux,grub};ln -s ~/Desktop/minimize ./v/something/pad ?"
#HUOM.9725.2:.iso-tiedoston mounttaus vielä testattava

echo "./stage0f.sh ${base} ${source2} <verbosity_level>"

