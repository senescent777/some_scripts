#!/bin/bash
#toimii tdsto tietysti ilmankin eksploisiittisesti tylkkua qhan x-oikeus vaan

#pohjana skripts/mf.bash / this is based on skripts/export/mf.bsh

debug=0 #1
tgt=""
cmd=""
d=$(dirname $0)
. ${d}/common.conf

#VAIH:jatkossa sanottaisiin moodi? 1 arvolla päivitetään dgsts.5 , toisella taas käsitelään "export2 rp":llä kaikki hmiston al. bz3?
#process_dir voisi ottaa lisäparametrin vaikkapa
#kts. mallia:squ.ash
function parse_opts_real() {
	dqb "fm.parse_opts_real ( ${1} ; ${2} ) "
	
	case "${1}" in
		a)
			cmd=${1}
			[ -d ${2} ] && tgt=${2}
		;;
#		-v) antaa lla näiuden toistaiseksi kmmenteissa
#			dqb "-v"
#		;;
#		*)
#			exit 66
#		;;
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

#uusi yritys parse_fktioiden kanssa myöhemmin
#cmd=${1}
#tgt=${2}
#
##luusli ettö vash urputtaa puuttuvasta fktiosta...
#function process_row2() {
#		dqb "process_row2( ${1} , ${2}, ${3}) "
#		
#		case ${3} in
#			a)
#				echo "$sah6"
#			;;
#			*)
#				exit 66
#			;;
#		esac
#	}
#
#function process_dir1() {
#	dqb "process_dir( ${1} ,  ${2} , ${3} )"
#	[ -z "${1}" ] && exit 99
#	[ -d ${1} ] || exit 98
#	[ -z "${2}" ] && exit 97
#	[ -d ${1}/${TARGET_DIGESTS_dir} ] || exit 96
#	[ -z "${3}" ] && exit 95
#	csleep 1
#	
#	dqb "pars ok"
#	csleep 1
#			
#	local p
#	local q
#	local r
#	local s
#	
#	p=$(pwd)
#			
#	cd ${1} 
#	pwd
#	csleep 1
#	q=${TARGET_DIGESTS_dir}/${TARGET_DIGESTS_file}.5
#	
#	#dqb "${sah6} ./${TARGET_pad_dir}/*.${2} >> ./${q} "
#	#csleep 1
#
#	#${sah6} ./${TARGET_pad_dir}/*.${2} >> ./${q}
#	dqb "find . -type f -name *.${2}  "
#	csleep 1
#	
#	s=$(find . -type f -name '*.${2}' )
#	dqb "s= ${s}"
#	csleep 1
#	
#	for r in ${s} ; do #mikä tässä qsee?
#		process_row2 ${3} ${r} ${q}
#	done
#
#	#241225:tämäkin pitäisi muuttaa, olisiko nyt hyvä
#	if [ ${debug} -gt 0 ] ; then
#		if [ "$3]" == "a" ] ; then
#			${sah6} 
#			csleep 3
#		fi
#	fi
#
#	cd ${p}	
#}

dqb "cmd=${cmd}"
dqb "tgt=${tgt}"
[ -z "${tgt}" ] && exit 99
[ -d ${tgt} ] || exit 100 #?





# slaughter0 mahd käyttöön ?	
#process_dir1 ${tgt} bz3 ${cmd}
p=$(pwd)

case ${cmd} in
	a)
	#241225; helpompi kuin ylläoleva yritelmä kommentriddsw
#... josko echo "smthing" | bash -s saisi sen toimiaan kuitenkin...

		t=${tgt}/${TARGET_DIGESTS_dir}/${TARGET_DIGESTS_file}.5
		[ -f ${t} ] && mv ${t} ${t}.OLD 
		csleep 1
		fasdfasd ${t}
		
		cd ${tgt}
		#echo "SHOULDA ${sah6} ./pad/*.bz3 > ./pad/dgsts/dgsts.5"
		${sah6} ./${TARGET_pad_dir}/*.bz3 > ./${TARGET_DIGESTS_dir}/${TARGET_DIGESTS_file}.5
		csleep 2
		
		if [ ${debug} -gt 0 ] ; then
			${sah6} --ignore-missing -c ./${TARGET_DIGESTS_dir}/${TARGET_DIGESTS_file}.5
		fi
	;;
	*)
		#1 toiminto voisi olla jnkn jokerin mukaisten tdstojen poisto kohdehmiston alta
		exit 65
	;;
esac

cd ${p}
