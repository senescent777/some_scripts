#!/bin/bash
debug=0
. ./skripts/common.conf
source=""
source2=""
bl=${CONF_bloader} #tähän liittyen oli se juttu toisessa repossa mikä pitäisi (mikä?)
cmd=""

#TODO:josko nimeäisi uudestaan ihan muuten vaan

if [ $# -lt 1 ] ; then
	echo "$0 -h"
	exit
fi

function usage() {
	echo "${0} --in <BASE> --add <THINGS_TO_ADD> [--bl BLOADER] [--v <verbosity_level>]"
	echo "${0} -d Destroys contents of ${CONF_tmpdir}"
	echo "${0} --make-dirs creates some dirs under ${CONF_tmpdir}"
}

function single_param() {
	dqb "subgle(${1} , ${2})"
	[ "${1}" == "-v" ] || cmd=${1}
}

#BTW. "-d -v" miten se hoidetaan?
function parse_opts_real() {
	dqb "douböe(${1} , ${2})"

	case ${1} in
		--add)
			source2=${2}
		;;
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
#180526 alettu renkata sudo-asioita
#240526:taisi jo toimia make-dirs sekä d omegan ajon jälkeen mikä ei tosin suuri ihme chmod+chown - koment5ojen takomisen jälkeen
#pitäisiköhän se odio jyrätä tässä skriptissä? jyrätään varm vuoksi

case "${cmd}" in
	--make-dirs)
		sudo ./skripts/dalek.bash m
	;;
	-d)
		#2605426:ei täysin onnistunut kohteen siivoilu omegan jälkeen, toistuuko?
		#4626:vieläkin oli toivomisen varaa, lisätty pari juttua dalekiin
		#30626:dalek ei oikein pelannut omegan jälkeen, koita keksiä miksi jnpp
		#15726:toimiko taas omegan jälk? ekhä

		sudo ./skripts/dalek.bash d1
	;;
	*)
		#15726:ehkä toimii tuo 0f post-pomega
		#stage0f==glorified cp
		echo "./stage0f.sh ${source} ${source2} ${bl} ${debug}"
	;;
esac
