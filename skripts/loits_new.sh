#!/bin/bash

debug=1
d=$(dirname $0)

. ${d}/common.conf
. ${d}/common_funcs.sh
#protect_system

ltarget="" 
bloader=""
lsrcdir=""

#HUOM.12725:oliko single_param() kanssa jokin juttu?

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
}

check_params
#enforce_deps #josqs myöhemmin takaisin ed ja id kommenteista
#
#[ y"${gv}" != "y" ] || inst_dep 0
[ x"${gi}" != "x" ] || echo "GENISIOMAGE MISSING"

function mk_pad_bak() {
	dqb "mk_pad_bak (${1} , ${2})"

	if [ -s ./${1} ] ; then
		dqb "${svm} ${1} ${1}.OLD"
		${svm} ${1} ${1}.OLD
	fi

	#näistä tässä alla puuttuu jotain parametreja
#	if [ ! -d ../out ] ; then 
#		${smd} ../out
#	fi
#
#	local tpop=""
#	tar ${tpop} ${TARGET_DTAR_OPTS} ${TARGET_DTAR_OPTS_LOITS} -cf ../out/${1} ./${2}			

}

#n=$(whoami)
#[ x"${CONF_TARGET}" != "x" ] || exit 666


dqb "${sco} -R ${n}:${n} ${CONF_TARGET}/out"
${sco} -R ${n}:${n} ${CONF_TARGET}/out
csleep 1

dqb "${scm} -R 0755 ${CONF_TARGET}/out"
${scm} -R 0755 ${CONF_TARGET}/out
csleep 1

#HUOM.12725:taroeellinen cd?
#koklataan nyt ensin ilman cd:tä
#jos qsee ed ni cd takas+muista muuttaa gi:n vika paramn
#dqb "cd ${lsrcdir}"
#cd ${lsrcdir}
#csleep 1
#HUOM.12725.23.34:joskohan toimisi jo gi:n uloste? ... siis mod Jutut

#mk_pad_bak ${TARGET_pad_bak_file} ${TARGET_pad_dir} tilapäisesti tämkin jemmaan
sleep 1

case ${bloader} in
	iuefi)
		${sco} -R ${n}:${n} .
		${scm} -R 0755 .
		${gi} -o ${ltarget} ${CONF_gi_opts2} ${lsrcdir}	
	;;
	isolinux)
		#TODO:UEFI-lisäsäädöt

		${sco} -R ${n}:${n} .
		${scm} -R 0755 .

		pwd #debug taakse?
		dqb "${gi} -o ${ltarget} ${CONF_gi_opts} ${lsrcdir}"
		csleep 1


		${gi} -o ${ltarget} ${CONF_gi_opts} ${lsrcdir} #. älä ramppaa
		sudo chmod a-x ${ltarget}
	;;
	grub)
		#xi=$(sudo which xorriso)
		#[ y"${xi}" != "y" ] || echo "apt-get install xorriso";exit 666


		#gmk=$(sudo which grub-mkrescue)
		#[ z"${gmk}" != "z" ] || echo "apt-get install grub-mkrescue";exit 666

		
		echo "sudo ${gmk} -o ../out/${ltarget} <OTHER_OPTS> . "
	;;
	*)
		echo "bl= ${bloader}"

		echo "https://www.youtube.com/watch?v=KnH2dxemO5o" 
	;;
esac

#${sco} -R 0:0 ${CONF_TARGET}


sleep 1
echo "stick.sh ?"
