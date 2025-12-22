#!/bin/bash
debug=0
. ./skripts/common.conf
source=""
source2=""
bl=${CONF_bloader} #tähän liittyen oli se juttu toisessa repossa mikö pitäisi
cmd=""

if [ $# -lt 1 ] ; then
	echo "$0 -h"
	exit
fi

function usage() {
	echo "${0} --in <BASE> --add <THINGS_TO_ADD> [--bl BLOADER] [--v <verbosity_level>]"
	#echo "${0} --get-devuan <download_dir>"
	echo "${0} -d Destroys contents of ${CONF_tmpdir}"
	echo "${0} --make-dirs creates some dirs under ${CONF_tmpdir}"
}

function single_param() {
	dqb "subgle(${1} , ${2})"
	#-v ei tarttisi kelpuuttaa tässä
	[ "${1}" == "-v" ] || cmd=${1}
}

##... koita päättää mitä tuo $1 edustaa
#function get_devuan() {
#	echo "cd ${1}"
#	echo "wget ${CONF_wget_opts} ${1}"
#	echo "sha256sum -c SHA256SUMS"
#	[ $? -eq 0 ] || echo "https://www.youtube.com/watch?v=PjotFePip2M"
#}

#BTW. "-d -v" miten se hoidetaan?
function parse_opts_real() {
	dqb "douböe(${1} , ${2})"

	case ${1} in
		--add)
			source2=${2}
		;;
#		--get-devuan)
#			#jatkossa kai main() kautta jos tarpeen
#			get_devuan ${2}
#			exit
#		;;
	esac	
}

. ./skripts/common_funcs.sh
. ./skripts/stage0_backend.bash

if [ -d ${CONF_tmpdir0} ] ; then
	dqb "CONF_TMPDIR0 EXISTS"
else
	echo "s.HOULD mkdir ${CONF_TMPDIR0}"
	exit 7
fi

dqb "${cmd}"
csleep 1

#main()

case ${cmd} in
	--make-dirs)
		#181225:lotottu init.bash hoitamaan jatkossa src_dirs-asiat
		#make_src_dirs ${CONF_bloader}

		#onkohan mieltä tehdä noin päin kuin alla?
		make_tgt_dirs ${CONF_target} ${CONF_source} ${CONF_bloader}
		exit
	;;
	-d)
		[ -v CONF_tmpdir ] || exit 68
		[ -z ${CONF_tmpdir} ] && exit 69
		[ "${CONF_tmpdir}" == "/" ] && exit 70

		dqb "CONF_tmp maybe ok"
		csleep 1

		#TODO:man chattr pitkästä aikaa
		#081225:v-hmiston alta jotain siivoilua myös? no ei
		#VAIH:josko jo sudon pudotus smr:stä tai sittense sudoers
		#smr=$(which rm)
		
		dqb "smr= ${smr}"
		csleep 2

		if [ x"${CONF_tmpdir}" != "x" ] ; then 
			echo "${smr} -rf ${CONF_tmpdir}/* IN 6 SECS";sleep 6	
			${smr} -rf ${CONF_tmpdir}/*
		fi

		if [ ${debug} -gt 0 ] ; then
			ls -las ${CONF_tmpdir} 
			sleep 5
		fi

		exit
	;;
	*)
		#stage0f==glorified cp
		echo "./stage0f.sh ${source} ${source2} ${bl} ${debug}"
	;;
esac
