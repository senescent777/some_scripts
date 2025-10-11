#!/bin/bash
debug=0 #1

. ./skripts/common.conf
. ./skripts/common_funcs.sh
. ./skripts/stage0_backend.bsh

base=""
source2=""
bl=${CONF_bloader}
#echo "TEHTY?:isolubnux.cfg";sleep 5

function usage() {
	echo "${0} --base <BASE> --add <THINGS_TO_ADD> [--bl BLOADER] [--v <verbosity_level>]"
	#echo "(<THINGS_TO_ADD> is path relative to ${CONF_BASEDIR})" #pitäisi varmaan huomioida tuo suhteellisuus? T. Albert
	echo "${0} --get-devuan <download_dir>"
	echo "${0} -d Destroys contents of ${CONF_tmpdir}"
	echo "${0} --make-dirs creates some dirs under ${CONF_tmpdir}"
}

#HUOM.031025:toiminee tämä skripti tänään riittävästi
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

#041025:-v mukaan ni kosahtaa suoritus (ei kyl haittaa kun debug asetsttu alussa mutta...)

function single_param() {
	case ${1} in
		--make-dirs)
			#init.bash käskyttämään tätä case:a tarvittaessa?
			make_src_dirs ${CONF_bloader}
			make_tgt_dirs
		;;
		--h)
			usage
		;;
		-d)
			[ -v CONF_tmpdir ] || exit 68

			if [ x"${CONF_tmpdir}" != "x" ] ; then 
				echo "${smr} -rf ${CONF_tmpdir}/* IN 6 SECS";sleep 6	
				${smr} -rf ${CONF_tmpdir}/*
			fi

			exit
		;;
	esac

	exit 13
}

if [ -d ${CONF_tmpdir0} ] ; then
	dqb "CONF_TMPDIR0 EXISTS"
else
	echo "s.HOULD mkdir ${CONF_TMPDIR0}"
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
#dqb "mkdir -p ./v/smthing;mkdir -p ./v/smthing/{isolinux,grub};ln -s ~/Desktop/minimize ./v/something/pad ?"
echo "./stage0f.sh ${base} ${source2} ${bl} <verbosity_level>"