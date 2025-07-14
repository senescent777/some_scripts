#!/bin/bash

debug=1
d=$(dirname $0)

. ${d}/common.conf
. ${d}/common_funcs.sh

ltarget="" 
bloader=""
lsrcdir=""

function usage() {
	echo "a glorified wrapper for genisoimage"
	echo "${0} --in <SOURCE_DIR> --out <OUTFILE> [ --bl <BOOTLOADER> ]"
	exit 666
}

function parse_opts_real() {
	dqb "parse_opts_real( ${1} , ${2})"

	case ${1} in
		--in)
			lsrcdir=${2}
		;;
		--out)
			ltarget=${2}
		;;
		--bl) 
			bloader=${2}
		;; 
		*)
			usage
		;;
	esac
}

#HUOM.12725:oliko single_param() kanssa jokin juttu? non yt aikakin fktio löytyy
function single_param() {
	dqb "signle_param ( ${1} , ${2} )"
}

if [ $# -gt 0 ] ; then
	parse_opts ${1} ${2}
	parse_opts ${3} ${4}
	parse_opts ${5} ${6}
	parse_opts ${7} ${8}
else
	usage
fi

function check_params() {
	dqb "check_params()"

	if [ x"${lsrcdir}" != "x" ] ; then
		if [ -d ./${lsrcdir} ] ; then
			dqb "k0"
		else
			echo "no such thing as ${lsrcdir}"
			exit 141
		fi
	else
		dqb "lsrcdir missing"
		exit 140
	fi

	if [ x"${ltarget}" != "x" ] ; then 

		if [ -s out/${ltarget} ] ; then
			echo "out/${ltarget} already exists"

			exit 142
		fi
	else
		exit 143

	fi

	if [ x"${bloader}" != "x" ] ; then
		echo "b"
	else
		bloader=${CONF_bloader}
	fi

	dqb "check_params() done"
}

check_params
[ x"${gi}" != "x" ] || echo "GENISIOMAGE MISSING"

function mk_pad_bak() {
	dqb "mk_pad_bak (${1} , ${2})"

	if [ -s ./${1} ] ; then
		dqb "${svm} ${1} ${1}.OLD"
		${svm} ${1} ${1}.OLD
	fi
}

sleep 1

case ${bloader} in
	iuefi)
		#KVG "how to make isolinux work with uefi"
		${sco} -R ${n}:${n} .
		${scm} -R 0755 .
		${gi} -o ${ltarget} ${CONF_gi_opts2} ${lsrcdir}	
	;;
	isolinux)
		${sco} -R ${n}:${n} .
		${scm} -R 0755 .

		pwd #debug taakse?
		dqb "${gi} -o ${ltarget} ${CONF_gi_opts} ${lsrcdir}"
		csleep 1

		${gi} -o ${ltarget} ${CONF_gi_opts} ${lsrcdir} #. älä ramppaa
		sudo chmod a-x ${ltarget}
	;;
	grub)
		#https://bbs.archlinux.org/viewtopic.php?id=219955

		xi=$(sudo which xorriso)
		gmk=$(sudo which grub-mkrescue)

		dqb "${gmk} -o ${ltarget} ${lsrcdir}"
		${gmk} ${CONF_GRUB_OPTS} -o ${ltarget} ${lsrcdir}
	;;
	*)
		echo "bl= ${bloader}"
		echo "https://www.youtube.com/watch?v=KnH2dxemO5o" 
	;;
esac

#TODO:chmod a-wx $target_dir/*.iso a-k.a joukukuuset wttuun

sleep 1
echo "stick.sh ?"
