#!/bin/bash
echo "DSTROY!!!"
exit

case "${1}"
	d1)
	#	
	#	[ -v CONF_tmpdir ] || exit 68
	#	[ -z ${CONF_tmpdir} ] && exit 69
	#	[ "${CONF_tmpdir}" == "/" ] && exit 70
#
#		dqb "CONF_tmp maybe ok"
#		csleep 1
#
#		#TODO:man chattr pitkästä aikaa
#		#081225:v-hmiston alta jotain siivoilua myös? no ei
#		
#		#VAIH:josko jo sudon pudotus smr:stä tai sittense sudoers
#		#... jokerit eivät ekalla yrityksellä oikein		
#
#		dqb "TODO:dalek.sh ?"
#
#		[ -v CONF_testgris ] && smr="/bin/rm"
#		dqb "smr= ${smr}"
#		csleep 2
#		dqb "SHDOULD scm+sco ${CONF_tmpdir}/ ¸* 1st"
#		#exit
#	
#		#ehkä tämä nimenomainen komento sudoersiin jos ei ala onnata jokerien kanssa
#		#tai dellimiset erilliseen skriptiin jnpp
#		sudo chown -R $(whoami):$(whoami) ${CONF_tmpdir}
#		sudo chmod -R u+w ${CONF_tmpdir}
#		csleep 2
#
#		if [ x"${CONF_tmpdir}" != "x" ] ; then 
#			echo "${smr} -rf ${CONF_tmpdir}/* IN 6 SECS";sleep 6	
#			${smr} -rf ${CONF_tmpdir}/*
#		fi
#
#		if [ ${debug} -gt 0 ] ; then
#			ls -las ${CONF_tmpdir} 
#			sleep 5
#		fi
#
		exit
	;;
	d2) #squ
		[ -v CONF_squash0 ] || exit 66
#		[ -z "${CONF_squash0}" ] && exit 67
#		[ -d ${CONF_squash0} ] || exit 68
#		pwd;sleep 6
#		
#		[ -v CONF_testgris ] && smr="/bin/rm"
#		dqb "smr= ${smr}"
#		csleep 2
#		dqb "SHDOULD scm+sco ${CONF_tmpdir}/* 1st"
#		exit
#	
#		#onko riittävä tarkistus vai ei?
#		if [ x"${CONF_squash0}" != "x/" ] ; then
#			echo "${smr} -rf ${CONF_squash0}/* IN 6 SECS";sleep 6
#			${smr} -rf ${CONF_squash0}/*
#			echo $?
#		fi
	;;
	m)
			exit

#	[ -z "${1}" ] && exit 99
#	[ x"${1}" != "x/" ] || exit 100
#	[ -z "${2}" ] && exit 101
#	[ -z "${3}" ] && exit 102
#	
#	dqb "PARAMZx OK"
#	csleep 1
#
#	dqb "CRS"
#	[ -d ${2} ] || ${smd} -p ${2}
#	${sco} 0:0 ${2}
#	${scm} 0755 ${2}
#	csleep 1	
#	
#	dqb "UQS(${CONF_squash_dir})"
#	[ -d ${CONF_squash_dir} ] || ${smd} -p ${CONF_squash_dir}
#	[ ${debug} -gt 0 ] && ls -las ${CONF_squash_dir}
#	
#	dqb "FR0ST"
#	
#	if [ ! -d ${1} ] ; then
#		#dqb "mkdir ${1}";sleep 6
#		${smd} -p ${1}
#	else
#		dqb "rm ${1}"
#		sleep 6
#		${smr} -rf ${1}/*
#	fi
#
#	csleep 1
#	dqb "BLADDER"
#
#	if [ "${3}" != "grub" ] ; then
#		#tapauksessa grub menee mettään näin
#		[ -d ${1}/${3} ] || ${smd} -p ${1}/${3}
#	else
#		[ -d ${1}/boot/grub ] || ${smd} -p ${1}/boot/grub
#	fi
#
#	csleep 1
#
#	dqb "LIVE-EVIL"
#	[ -d ${1}/live ] || ${smd} -p ${1}/live
#	csleep 1 
#
#	dqb "DGSTS"
#	[ -d ${1}/${TARGET_DIGESTS_dir} ] || ${smd} -p ${1}/${TARGET_DIGESTS_dir}
#	csleep 1
#
#	dqb "DAP"
#	[ -d ${1}/${TARGET_pad_dir} ] || ${smd} -p ${1}/${TARGET_pad_dir}
#	csleep 1
#
#	dqb "TUQ"
#	[ -d ${1}/../out ] || ${smd} -p ${1}/../out
#	csleep 1
#
#	dqb "FN1AL"
#	${sco} -R $(whoami):$(whoami) ${1}
#	local f
#	for f in $(find ${1} -type d ); do ${scm} 0755 ${f} ; done
#
#	csleep 1
#	[ ${debug} -gt 0 ] && ls -laR ${1}
#	csleep 7
#	dqb "...done\n"
	;;
esac
