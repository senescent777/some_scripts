#!/bin/bash
. ./common.conf
. ./common_funcs.sh
protect_system

ltarget="" 
bloader=""

function usage() {
	echo "${0} --in <SOURCE_DIR> --out <OUTFILE> [ --bl <BOOTLOADER> ]"
	exit 666
}


function parse_opts_real() {
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

parse_opts ${1} ${2}
parse_opts ${3} ${4}
parse_opts ${5} ${6}
parse_opts ${7} ${8}

function check_params() {
	if [ -d ./${lsrcdir} ] ; then
		echo "k0"
	else
		echo "no such thing as ${lsrcdir}"
		exit 666
	fi
	
	if [ x"${ltarget}" != "x" ] ; then 

		if [ -s out/${ltarget} ] ; then
			echo "out/${ltarget} already exists"
			exit 666
		fi
	else
		exit 666
	fi

	if [ x"${bloader}" != "x" ] ; then
		echo "b"
	else
		bloader=${CONF_bloader}
	fi
}

check_params
enforce_deps

[ y"${gv}" != "y" ] || inst_dep 0
[ x"${gi}" != "x" ] || inst_dep 1


function mk_pad_bak() {
	[ -s ./${1} ] && sudo mv ${1} ${1}.OLD
	
	if [ ! -d ../out ] ; then 
		sudo mkdir ../out
	fi

	local tpop=""
	tar ${tpop} ${TARGET_DTAR_OPTS} ${TARGET_DTAR_OPTS_LOITS} -cf ../out/${1} ./${2}			

}

n=$(whoami)
[ x"${CONF_TARGET}" != "x" ] || exit 666

sudo chown -R ${n}:${n} ${CONF_TARGET}/out
sudo chmod -R 0755 ${CONF_TARGET}/out

cd ${lsrcdir}

mk_pad_bak ${TARGET_pad_bak_file} ${TARGET_pad_dir}
sleep 1



case ${bloader} in
	isolinux)
		
		sudo chown -R ${n}:${n} .
		sudo chmod -R 0755 .

		${gi} -o ${CONF_TARGET}/out/${ltarget} ${CONF_gi_opts} .

	;;
	grub)
		xi=$(sudo which xorriso)
		[ y"${xi}" != "y" ] || echo "apt-get install xorriso";exit 666

		gmk=$(sudo which grub-mkrescue)
		[ z"${gmk}" != "z" ] || echo "apt-get install grub-mkrescue";exit 666
		
		echo "sudo ${gmk} -o ../out/${ltarget} <OTHER_OPTS> . "
	;;
	*)
		echo "bl= ${bloader}"
		echo "https://www.youtube.com/watch?v=PjotFePip2M" 
	;;
esac

sudo chown -R 0:0 ${CONF_TARGET}

sleep 1
echo "stick.sh ?"
