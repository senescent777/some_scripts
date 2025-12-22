#!/bin/bash
#pohjana skripts/mf.bash / this is based on skripts/mf.bsh

debug=0 #1
source=""
d=$(dirname $0)
. ${d}/common.conf

#yhteistyö >"-v" - vivun kanssa kai toimii

function parse_opts_real() {
	dqb "fm.parse_opts_real ( ${1}. ${2} ) "
}

function single_param() {
		dqb "fm.single_p ( ${1}  ) "
}
	
function usage() {
	echo "${0} --in <dir> "
}

. ${d}/common_funcs.sh

if [ $# -lt 2 ] ; then
	exit
fi

function process_dir() {
	dqb "process_dir( ${1} ,  ${2} )"
	[ -z "${1}" ] && exit 99
	[ -d ${1} ] || exit 98
	[ -z "${2}" ] && exit 97
	[ -d ${1}/${TARGET_DIGESTS_dir} ] || exit 96
	csleep 1
	
	dqb "pars ok"
	csleep 1
			
	local p
	local q
	p=$(pwd)
			
	cd ${1} 
	local t=${TARGET_DIGESTS_dir}/${TARGET_DIGESTS_file}.5
	
	#TODO:ao. rivin muuttaminen sikäli mikäli iteroidaan useampia päätteitä hmiston sisällä, main() -metodista käsin
	[ -f ./${t} ] && mv ./${t} ./${t}.OLD 

	${sah6} ./${TARGET_pad_dir}/*.${2} > ./${t} 
	#${sah6} ./${TARGET_pad_dir}/*.conf >> ./${t} 	#tarvitaanko oikeasti?	ei kuitenkaan näin	

	#VAIH:${sah6} -c
	if [ ${debug} -gt 0 ] ; then
		${sah6} --ignore-missing -c ./${t} 
		csleep 3
	fi

	cd ${p}	
}

dqb "source=${source}"
[ -d ${source} ] || exit 100

# slaughter0 mahd käyttöön ?

process_dir ${source} bz3
