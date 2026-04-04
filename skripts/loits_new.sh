#!/bin/bash
debug=0
d=$(dirname $0)
ltarget="" 
source=""
. ${d}/common.conf
bl=${CONF_bloader}

function usage() {
	echo "a glorified wrapper for genisoimage (or grub-mkrescue)"
	echo "${0} --in <SOURCE_DIR> --out <OUTFILE> [ --bl <BOOTLOADER> ]"
	exit 666
}

function parse_opts_real() {
	dqb "parse_opts_real( ${1} , ${2})"

	case ${1} in
		--out)
			ltarget=${2}
		;;
	esac
}

#HUOM.12725:oliko single_param() kanssa jokin juttu? non yt aikakin fktio löytyy
function single_param() {
	dqb "signle_param ( ${1} , ${2} )"
}

. ${d}/common_funcs.sh

function check_params() {
	dqb "check_params()"
	
	if [ -z "${source}" ] ; then
		dqb "source missing"
		exit 140
	fi
	
	if [ -d ${source} ] ; then
		dqb "k0"
	else
		echo "no such d1r as ${source}"
		exit 141
	fi

	if [ -z "${ltarget}" ] ; then
		exit 143
	fi
	
	if [ -s out/${ltarget} ] ; then
		echo "out/${ltarget} already exists"
		exit 142
	fi

	if [ x"${bl}" != "x" ] ; then #-z
		echo "b"
	fi

	dqb "check_params() done"
}

#030426:edelleen kykenee tmivan tdston muodostamaan (grub)
check_params
[ -z "${gi}" ] && echo "GENISIOMAGE MISSING"
sleep 1
dqb "bl=${bl}"
csleep 4

dqb "TODO: https://wiki.debian.org/RepackBootableISO + CONF_gi_opts" #JOKO JO 04/26???
csleep 4

case ${bl} in
	isolinux)
		#VAIH:toimivuuden testaus (jäänee kiinni muusta kuin .cfg puutteesta, KVG:juttuja)
		${sco} -R ${n}:${n} .
		${scm} -R 0755 .

		ls -las ${source}/${bl}/*.cfg || exit 99
		csleep 2

		[ ${debug} -eq 1] && pwd 
		dqb "${gi} -o ${ltarget} ${CONF_gi_opts} ${source}"
		csleep 1

		${gi} -o ${ltarget} ${CONF_gi_opts} ${source} #. älä ramppaa
	;;
	grub)
		ls -las ${source}/boot/${bl}/*.cfg || exit 99
		csleep 2

		#https://bbs.archlinux.org/viewtopic.php?id=219955
		#ehkä ei tartte sudottaa jos kohde-hakemisto sopiva (esim /tmp)
		
		dqb "${gmk} -o ${ltarget} ${source} soon"
		csleep 1
		${gmk} ${CONF_GRUB_OPTS} -o ${ltarget} ${source}
		[ $? -eq 0 ] || echo "chown | chmod | smthing else"
	;;
	*)
		echo "bl= ${bl}"
		echo "https://www.youtube.com/watch?v=KnH2dxemO5o" 
	;;
esac
