#!/bin/bash
#pohjana skripts/mf.bash / this is based on skripts/mf.bsh

debug=0 #1
source=""
d=$(dirname $0)
. ${d}/common.conf

#VAIH:jatkossa sanottaisiin moodi? 1 arvolla päivitetään dgsts.5 , toisella taas käsitelään "export2 rp":llä kaikki hmiston al. bz3?
#process_dir voisi ottaa lisäparametrin vaikkapa
#kts. mallia:kutl.bash
function parse_opts_real() {
	#dqb "fm.parse_opts_real ( ${1}. ${2} ) "
}

function single_param() {
	#	dqb "fm.single_p ( ${1}  ) "
}
	
function usage() {
	#echo "${0} --in <dir> "
}

. ${d}/common_funcs.sh

if [ $# -lt 2 ] ; then
	exit
fi

function process_dir1() {
	dqb "process_dir( ${1} ,  ${2} , ${3} )"
	[ -z "${1}" ] && exit 99
	[ -d ${1} ] || exit 98
	[ -z "${2}" ] && exit 97
	[ -d ${1}/${TARGET_DIGESTS_dir} ] || exit 96
	[ -z "${3}" ] && exit 95
	csleep 1
	
	dqb "pars ok"
	csleep 1
			
	local p
	local q
	local r
	
	p=$(pwd)
			
	cd ${1} 
	q=${TARGET_DIGESTS_dir}/${TARGET_DIGESTS_file}.5
	
	dqb "${sah6} ./${TARGET_pad_dir}/*.${2} >> ./${q} "
	csleep 1

	#${sah6} ./${TARGET_pad_dir}/*.${2} >> ./${q}
	for r in $(find . -name './${TARGET_pad_dir}/*.${2}' ) ; do
		process_row ${3} ${r} ${q}
	done

	#tömökin pitäisi muuttaa
	if [ ${debug} -gt 0 ] ; then
		${sah6} --ignore-missing -c ./${q} 
		csleep 3
	fi

	cd ${p}	
}

dqb "source=${source}"
[ -d ${source} ] || exit 100 #?

t=${source}/${TARGET_DIGESTS_dir}/${TARGET_DIGESTS_file}.5
#VAIH:ao. rivin muuttaminen sikäli mikäli iteroidaan useampia päätteitä hmiston sisällä, main() -metodista käsin
[ -f ${t} ] && mv ${t} ${t}.OLD 
csleep 1
fasdfasd ${t}

# slaughter0 mahd käyttöön ?	
process_dir1 ${source} bz3
