#!/bin/bash
d=$(dirname $0)
debug=0

. ${d}/common.conf
. ${d}/keys.conf

cmd=""
tgt=""

function usage() {
	echo "another kind of a wrapper for gpg"
	echo "${0} <mode> [dir] \r\n"
	echo "abt mode"
	echo "u : imports pUblic keys from [dir] , ${CONF_keys_dir_pub} is used if dir does not exits or not given"
	echo "v : imports priVate keys from [dir] , ${CONF_keys_dir} is used if..."
	echo "w : exports pre-configured public keys 2 dir"
	echo "x : eXports pre-configured private keys 2 dir"
	echo "m: Makes 2 new keys, also creates a backup archive if [dir is given]"
}

function single_param() {
	dqb "qtlu.single-param( ${1} )"
	[ -z "${cmd}" ] && cmd=${1} 
}

function parse_opts_real() {
	dqb "qtlu.parse_opts_real( ${1}, ${2} )"
		
	case "${1}" in
		u|v|w|x)
			[ -d ${2} ] && tgt=${2}
		;;
	esac
}

. ${d}/common_funcs.sh
dqb "cmd= ${cmd}"
dqb "tgt=${tgt}"
csleep 1

case ${cmd} in
	u)
		echo "#VAIH:4 pUblic keys"
		
		if [ -z "${tgt}" ] || [ ! -d ${tgt} ] ; then
			echo "${gg} --import ${CONF_keys_dir_pub}/*.gpg"
		else
			echo "${gg} --import ${tgt}/*.gpg"
		fi
	;;
	v)
		#erilliset u,v-caset turhaa kikkailua oikeastaan mutta olkoon näin jnkn akaa
		echo "#VAIH:4 priV keys"
		
		if [ -z "${tgt}" ] || [ ! -d ${tgt} ] ; then
			echo "${gg} --import ${CONF_keys_dir}/*.gpg"
		else
			echo "${gg} --import ${tgt}/*.gpg"
		fi	
	;;
	w)
		[ -v CONF_karray ] || exit 68
		[ -v CONF_keys_dir_pub ] || exit 69
		#[ ${tgt} != ${} ] && exit 69 #voisi laittaa toimimaan?
		#VAIH:kesksytys tai ulina jos tgt ei annettu tai tyhjä?
		
		[ -z "${tgt}" ] && tgt=${CONF_keys_dir_pub}
		[ -d ${tgt} ] || exit 70
		
		for k in ${CONF_karray} ; do
			dqb "${gg} --export ${k} > ${tgt}/${k}.gpg"
			${gg} --export ${k} > ${tgt}/${k}.gpg
			echo $?
		done
	;;
	x)
		[ -v CONF_karray ] || exit 68
		#[ ${tgt} == ${CONF_keys_dir_pub} ] && exit 69 #TODO:voisi laittaa toimimaan ASAP
		[ -z "${tgt}" ] && tgt=${CONF_keys_dir}
		[ -d ${tgt} ] || exit 70
		
		for k in ${CONF_karray} ; do
			dqb "${gg} --export-secret-keys ${k} > ${tgt}/${k}.priv.gpg"
			${gg} --export-secret-keys ${k} > ${tgt}/${k}.priv.gpg
			echo $?
		done
	;;
	m)
		${gg} --generate-key
		sleep 5

		${gg} --generate-key
		sleep 5
	
		if [ ! -z "${tgt}" ] ; then #vähän aiemmaksi jos tarkistus
			[ -s ${tgt} ] && mv ${tgt} ${tgt}.OLD
			tar -jcvf ${tgt} ~/.gnupg
		fi
		
		if [ ! -s ${d}/keys.conf ] ; then
			cp ${d}/keys.conf.example ${d}/keys.conf
			${gg} --list-keys >> ${d}/keys.conf
		fi
			
		${CONF_editor} ${d}/keys.conf
	;;
	*)
		usage
	;;
esac
