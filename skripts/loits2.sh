#!/bin/bash
. ./common.conf
. ./common_funcs.sh
protect_system

ltarget="" 
bloader=""
#exit

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
	[ x"${CONF_target}" != "x" ] || exit 666
	[ x"${CONF_bloader}" != "x" ] || exit 666

	if [ -d ./${1} ] ; then
		echo "DIR OK" #jatkossa dqb
	else
		echo "no such thing as ${1}"
		exit 666
	fi
	
	if [ x"${2}" != "x" ] ; then 

		if [ -s out/${2} ] ; then
			echo "out/${2} already exists"
			exit 666
		fi
	else
		exit 666
	fi

	if [ x"${3}" != "x" ] ; then
		echo "BLOADER OK" #jatkossa dqb
	else
		bloader=${CONF_bloader}
	fi

}

function make_tar() {
	[ -s ${1}/${TARGET_pad_bak_file} ] && mk_bkup ${1}/${TARGET_pad_bak_file}
	
	local tpop=""
	#To State The Obvious:välistä puuttuu jotain
	tar ${tpop} ${TARGET_DTAR_OPTS} ${TARGET_DTAR_OPTS_LOITS} -cf ${1}/${TARGET_pad_bak_file} ./${TARGET_pad_dir}
}

check_params ${lsrcdir} ${ltarget} ${bloader}
enforce_deps

[ y"${gv}" != "y" ] || inst_dep 0
[ x"${gi}" != "x" ] || inst_dep 1

n=$(whoami)
lsrcdir=./${lsrcdir}

sudo chown -R ${n}:${n} ${CONF_target}/../out
chmod 0755 ${CONF_target}/../out

olddir=$(pwd)
cd ${lsrcdir}

if [ -d ${TARGET_pad_dir} ] ; then 
	make_tar ${CONF_target}/../out

else
	echo "${TARGET_pad_dir} missing"
fi

sudo chown -R ${n}:${n} .
chmod 0755 ./${CONF_bloader}

case ${bloader} in
	isolinux)
		sudo chown ${n}:${n} ./isolinux/isolinux*
		chmod 0644 ./isolinux/isolinux*
		
		${gi} -o ${CONF_target}/../out/${ltarget} ${CONF_gi_opts} .
		[ $? -eq 0 ] || echo "sudo chown -R ${n}:${n} ./isolinux && sudo chmod 0755  ./isolinux"

	;;
	*)
		echo "bl= ${bloader}"
		echo "https://www.youtube.com/watch?v=KnH2dxemO5o" 
	;;
esac

chmod 0555 ./${CONF_bloader}
chmod 0444 ./${CONF_bloader}/*
sudo chown -R 0:0 .
cd ${olddir}

sleep 1
echo "stick.sh ?"
