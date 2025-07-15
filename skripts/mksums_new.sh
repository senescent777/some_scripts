#!/bin/bash
b=1
debug=1
source=""

d=$(dirname $0)

. ${d}/common.conf
. ${d}/common_funcs.sh

#protect_system
#exit

function usage() {
	echo "TODO"
}

function parse_opts_real() {

	case ${1} in
		-b)
			b=${2}
		;;
		--in)
			source=${2}
		;;
	esac
}

#[ x$"{TARGET_DIGESTS_dir}" != "x" ] || exit 666
#[ x$"{CONF_BASEDIR}" != "x" ] || exit 666
#[ x"${CONF_target}" != "x" ] || exit 666


function single_param() {
	case ${1} in
		--iso)
	
			${gg} -u ${CONF_kay2name} -sb ./*.iso
		
			exit 666
		;;
		--pkgs)
			[ x"${CONF_BASEDIR}" != "x" ] || exit 664
			[ x"${CONF_pkgsdir2}" != "x" ] || exit 665

			cd ${CONF_BASEDIR}/${CONF_pkgsdir2}

			${gg} -u ${CONF_kay2name} -sb ./*.deb
			[ $? -eq 0 ]  && ${gg} -u ${CONF_kay2name} -sb ./*.bz2
			
			exit 666
		;;
		--h)
			usage
		;;
	esac
}

MKS_parts="1 2 3"
#n=$(whoami)

function part0() {
	dqb "part0( ${1})"
	[ -d ${1} ] || exit 666

	local f
	for f in $(find ${1} -type f -name '${TARGET_DIGESTS_file}*') ; do
		rm ${f}
	done

	local i
	for i in ${MKS_parts} 4 ;  do touch ${1}/${TARGET_DIGESTS_file}.${i} ; done
	
	dqb "part0 d0n3"
	csleep 1
}


function part1234() {
	local olddir=$(pwd)	


	local f

	for f in $(find . -name SAM.${1}.*) ; do
		echo	
	done

	cd ${olddir}
}

#HUOM.15725:jurpoilu vahvana tämän fkrtion kanssa juuri nyt
function part123() {
	debug=1
	dqb "part123(${1}, ${2} , ${3} )"

	[ z"${1}" != "z" ] || exit 666
	[ -d ${2} ] || exit 666
	[ -d ${3} ] || exit 666

	local old
	local f
	old=$(pwd)
	[ ${debug} -eq 1 ] && ls -las ${3}/${TARGET_DIGESTS_dir};sleep 3

	if [ ! -s ${3}/${TARGET_DIGESTS_dir}/${TARGET_DIGESTS_file}.${1} ] ; then
		cd ${3}
		pwd

		for f in $(find ./${2} -type f  | grep -v ${TARGET_patch_name} | grep -v ${TARGET_DIGESTS_file0} | grep -v boot.cat | grep -v isolinux.bin) ; do
			dqb "${sh5} ${f}"
			${sh5} ${f} >> ./${TARGET_DIGESTS_dir}/${TARGET_DIGESTS_file}.${1}			
		done

		cd ${old}
	else
		dqb "ERROR TERROR"
	fi
}

function part456() {
	[ z"${1}" != "z" ] || exit 666

	if [ -s ./${TARGET_DIGESTS_file}.${1} ] ; then
				${sh5} -c ./${TARGET_DIGESTS_file}.${1} --ignore-missing
	else
		echo "no such thing as ./${TARGET_DIGESTS_file}.${1}"		 
	fi
}

function part6_5() {
	local i

	for i in ${MKS_parts} ; do
		${gg} -u ${CONF_kay1name} -sb ./${TARGET_DIGESTS_file}.${i}
		echo "$?"
	done

	if [ $? -gt 0 ] ; then
		dqb "uliuli"
	fi

}

function part7() {
	
	${gg} -u ${CONF_kay2name} -sb ./${TARGET_Dpubkf}
	
		${gv} --keyring ./${TARGET_Dpubkg} ./${TARGET_Dpubkf}.sig ./${TARGET_Dpubkf}
		local i

		for i in ${MKS_parts} ; do
			${gv} --keyring ${TARGET_Dpubkf} ${TARGET_DIGESTS_file}.${i}.sig ${TARGET_DIGESTS_file}.${i}
		done

	echo $?
}

function part8() {
	[ x"${TARGET_patch_name}" != "x" ] || exit 665
	[ x"${1}" != "x" ] || exit 665

	local tfile=${TARGET_patch_name}.tar.bz2
	[ -s ./${TARGET_pad_dir}/${tfile} ] || exit 666		


	local olddir=$(pwd)	
	cp ./${TARGET_pad_dir}/${tfile} ../out
	cd ../out

	case ${1} in
		1)
			${gg} -u ${CONF_kay2name} -sb ${tfile}
			echo $?

				${gv} --keyring ${CONF_target}/${TARGET_Dpubkg} ${tfile}.sig ${tfile}	
			#fi
		;;
		2)
			dqb "2"
		;;
		*)
			dqb "default"
		;;
	esac 

	cd ${olddir}
}

#enforce_deps
parse_opts ${1} ${2}
parse_opts ${3} ${4}

pwd

#[ x"${TARGET_DIGESTS_dir}" != "x" ] || exit 1
#
#if [ ! -d ${TARGET_DIGESTS_dir} ] ; then 
#	mkdir -p ${TARGET_DIGESTS_dir}
#fi

part0 ${source}/${TARGET_DIGESTS_dir}
#exit

#cd ${CONF_target} 
#pwd

part123 1 ${CONF_bloader} ${source}
part123 2 ${TARGET_pad_dir} ${source}
part123 3 live ${source}
exit
cd ${CONF_target}
for p in ${MKS_parts} ; do part456 ${p} ; done

if [ x"${gg}" != "x" ] ; then 
	part6_5
fi

part7 

pwd
part8 ${b}

${sh5} ${TARGET_DIGESTS_dir}/* | grep -v '${TARGET_DIGESTS_file}.4' | grep -v 'cf83e' | grep -v 'SAM' | head -n 10 > ${TARGET_DIGESTS_file}.4

part456 4
sudo chown -R 0:0 ${CONF_target}/${TARGET_DIGESTS_dir}
sudo chmod 0555 ${CONF_target}/${TARGET_DIGESTS_dir}
sudo chmod 0444 ${CONF_target}/${TARGET_DIGESTS_dir}/*

	ls -laRs ${TARGET_DIGESTS_dir}

