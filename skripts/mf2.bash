#!/bin/bash
#pohjana skripts/mf.bash / this is based on skripts/export/mf.bsh

debug=0 #1
tgt=""
cmd=""
d=$(dirname $0)
. ${d}/common.conf

#jatkossa sanottaisiin moodi? 1 arvolla päivitetään dgsts.5 , toisella taas käsitelään "export2 rp":llä kaikki hmiston al. bz3?
#process_dir voisi ottaa lisäparametrin vaikkapa
#kts. mallia:squ.ash

function parse_opts_real() {
	dqb "fm.parse_opts_real ( ${1} ; ${2} ) "
	
	case "${1}" in
		a)
			cmd=${1}
			[ -d ${2} ] && tgt=${2}
		;;
	esac
}

function single_param() {
	dqb "fm.single_p ( ${1}  ) "
}
	
function usage() {
	echo "${0} <cmd> <dir> [-v] | $0 -h"
}

. ${d}/common_funcs.sh

if [ $# -lt 2 ] ; then
	exit
fi

dqb "cmd=${cmd}"
dqb "tgt=${tgt}"
[ -z "${tgt}" ] && exit 99
[ -d ${tgt} ] || exit 100 #?

p=$(pwd)

case ${cmd} in
	a)
		t=${tgt}/${TARGET_DIGESTS_dir}/${TARGET_DIGESTS_file}.5
		[ -f ${t} ] && mv ${t} ${t}.OLD 
		csleep 1
		fasdfasd ${t}
		
		cd ${tgt}
		#VAIH:pitäisiköhän mennä findin kautta kuitenkin? kun muuallakin
		#./${TARGET_pad_dir}/*.bz3 >
		for f in $(${odio] find ./${TARGET_pad_dir} -type f -name "*.bz3") ; do
			${sah6} ${f} >> ./${TARGET_DIGESTS_dir}/${TARGET_DIGESTS_file}.5 #$t jatkossa?
		done
		
		csleep 2
		
		if [ ${debug} -gt 0 ] ; then
			${sah6} --ignore-missing -c ./${TARGET_DIGESTS_dir}/${TARGET_DIGESTS_file}.5 #$t jatkossa?
		fi
	;;
	*)
		#1 toiminto voisi olla jnkn jokerin mukaisten tdstojen poisto kohdehmiston alta
		exit 65
	;;
esac

cd ${p}
