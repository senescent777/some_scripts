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
		m)
			[ "${2}" == "-v" ] || tgt=${2}
		;;
	esac
}

. ${d}/common_funcs.sh
dqb "cmd= ${cmd}"
dqb "tgt=${tgt}"
csleep 1

function m0() {
		dqb "m0( ${tgt} )"
		csleep 1
		
		${sco} $(whoami):$(whoami) ${1}/*.gpg
		${scm} 0400 ${1}/*.gpg
		${odio} chattr +ui ${1}/*.gpg
	}

#VAIH:tämä rimpsu varm. vuoksi koko skriptin alkuun?
[ -d ~/.gnupg/private-keys-v1.d ] || mkdir -p ~/.gnupg/private-keys-v1.d
chown -R $(whoami):$(whoami) ~/.gnupg #tarpeen?
chmod 0700 ~/.gnupg/private-keys-v1.d #tai lähes koko ~/.g
chmod 0644 ~/.gnupg/pubring*
csleep 5
		
case ${cmd} in
	u)
		#VAIH:"find -not -name | gg" olisi hyväksi 
		tgt2=${tgt}
		
		if [ -z "${tgt}" ] || [ ! -d ${tgt} ] ; then
			tgt2=${CONF_keys_dir_pub}
			dqb "${gg} --import ${CONF_keys_dir_pub}/*.gpg"
		#else
		#	${gg} --import ${tgt}/*.gpg
		fi
		
		for d in $(find ${tgt2} -type f -name '*.gpg' | grep -v 'priv') ; do
			${gg} --import ${d}
		done
	;;
	v)
		#erilliset u,v-caset turhaa kikkailua oikeastaan mutta olkoon näin jnkn akaa
		
		#jos vetäisi vain array:n mukaiset? tai nitenjos findin kautta? no qhan tämänkertaiset kiukuttelut hoidettu ni
		if [ -z "${tgt}" ] || [ ! -d ${tgt} ] ; then
			dqb "-import ${CONF_keys_dir}/*.priv.gpg"
			${gg} --import ${CONF_keys_dir}/*.priv.gpg
		else
			dqb "-import ${tgt}/stuff"
			${gg} --import ${tgt}/*.priv.gpg
		fi	
	;;
	w)
		[ -v CONF_karray ] || exit 68
		[ -v CONF_keys_dir_pub ] || exit 69
		#[ ${tgt} != ${} ] && exit 69 #voisi laittaa toimimaan?
		
		[ -z "${tgt}" ] && tgt=${CONF_keys_dir_pub}
		[ -d ${tgt} ] || exit 70
		
		for k in ${CONF_karray} ; do
			dqb "${gg} --export ${k} > ${tgt}/${k}.gpg"
			${gg} --export ${k} > ${tgt}/${k}.gpg
			echo $?
		done
		
		#varm vuoksi
		m0 ${tgt}
	;;
	x)
		[ -v CONF_karray ] || exit 68
		#[ ${tgt} == ${CONF_keys_dir_pub} ] && exit 69 #TODO:voisi laittaa toimimaan ASAP
		[ -z "${tgt}" ] && tgt=${CONF_keys_dir}
		[ -d ${tgt} ] || exit 70
		
		#karray:n sisällön jos export-komennolla asettaisi saataville? 
		
		for k in ${CONF_karray} ; do
			dqb "${gg} --export-secret-keys ${k} > ${tgt}/${k}.priv.gpg"
			${gg} --export-secret-keys ${k} > ${tgt}/${k}.priv.gpg
			echo $?
		done
		
		#varm vuoksi
		m0 ${tgt}
	;;
	m)
		#21.12.25: jumittui tällaiseen:
		#gpg: agent_genkey failed: No such file or directory
		#Key generation failed: No such file or directory
		#jos toistuu ni jotain tarttisi tehrä
		
		sleep 5
		${gg} --generate-key
		sleep 5

		${gg} --generate-key
		sleep 5
	
		if [ ! -z "${tgt}" ] ; then #vähän aiemmaksi jos tarkistus?
			[ -s ${tgt} ] && mv ${tgt} ${tgt}.OLD
			tar -jcvf ${tgt} ~/.gnupg
			chmod 0444 ${tgt} 
			${odio} chattr +ui ${tgt}
			dqb "gnupg backup file can be restored with: tar -jxvf  ${tgt} "
		fi
		
		sleep 5
		m0 ${d}/keys.conf.example 
		
		if [ ! -s ${d}/keys.conf ] ; then
			cp ${d}/keys.conf.example ${d}/keys.conf.tmp
			chmod 0644 ${d}/keys.conf.tmp
			chown $(whoami):$(whoami) ${d}/keys.conf.tmp
			sleep 5
			#onko tu o odottaminen se jekku millä sai toimimaan?
		else
			mv ${d}/keys.conf ${d}/keys.conf.$(date +%F)
		fi
			
		${gg} --list-keys >> ${d}/keys.conf.tmp
		sleep 1
			
		${CONF_editor} ${d}/keys.conf.tmp
		#VAIH:voisi kopsata toisellekin nimelle ja sillä editoida, lopuksi oikean niminen tdsto tilap tdstosta typistämällä 12 riviin	
		head -n 12 ${d}/keys.conf.tmp > ${d}/keys.conf
	;;
	*)
		usage
	;;
esac
