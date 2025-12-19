#!/bin/bash
d=$(dirname $0)
debug=0

. ${d}/common.conf
. ${d}/keys.conf

cmd=""
tgt=""

function usage() {
	echo "TODO:another kind of a wrapper for gpg"
	echo "\r\n"
}

function single_param() {
	dqb "instk.single-param(${1})"
	[ -z "${cmd}" ] && cmd=${1} 
}

function parse_opts_real() {
	dqb "parse_opts_real(${1}, ${2})"
		
	case "${1}" in
		u|v|w|x)
			[ -d ${2} ] && tgt=${2}
		;;
	esac
}

. ${d}/common_funcs.sh

echo "cmd= ${cmd}"
echo "tgt=${tgt}"
sleep 1

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
		#mitä tähän laittaa?
		echo "VAIH: also 4 pblic keys"
		
		[ -v CONF_karray ] || exit 68
		#[ ${tgt} != ${CONF_keys_dir_pub} ] && exit 69 #TODO:voisi laittaa toimimaan ASAP
		
		for k in ${CONF_karray} ; do
			echo "${gg} --export ${k} > ${tgt}/${k}.gpg"
		done
	;;
	x)
		echo "VAIH: also 4 priv keys"
		[ -v CONF_karray ] || exit 68
		#[ ${tgt} == ${CONF_keys_dir_pub} ] && exit 69 #TODO:voisi laittaa toimimaan ASAP
		
		for k in ${CONF_karray} ; do
			echo "${gg} --export-secret-keys ${k} > ${tgt}/${k}.priv.gpg"
		done
	;;
	m)
		echo "VAIH:Make new keys"
		#TODO:testatakin pitäisi...

		echo "${gg} --generate-key"
		sleep 5

		echo "${gg} --generate-key"
		sleep 5
	
		[ -s ${tgt} ] && echo "mv ${tgt} ${tgt}.OLD"
		echo "tar -jcvf ${tgt} ~/.gnupg"

		if [ ! -s ${d}/keys.conf ] ; then
			echo "cp ${d}/keys.conf.example ${d}/keys.conf"
			echo "${gg} --list-keys >> ${d}/keys.conf" 
			echo "EDITOR ${d}/keys.conf"
		fi
	;;
	*)
		usage
	;;
esac
