#!/bin/bash
echo "EXTERMINATE!!! #"
d=$(dirname $0) #ei niin tarpeellinen koska conf
debug=1
#040626:includointi ohitettu, risuaita alla liittyy asiaan eli älä poista
#. ${d}/common.conf #

[ -v CONF_tmpdir ] || exit 68
[ -z "${CONF_tmpdir}" ] && exit 69
[ "${CONF_tmpdir}" == "/" ] && exit 70

function dqb() {
	[ ${debug} -eq 1 ] && echo ${1}
}

function csleep() {
	[ ${debug} -eq 1 ] && sleep ${1}
}

smr="/bin/rm"
dqb "smr= ${smr}"
csleep 2
scm="/bin/chmod"
odio=""
sco=$(${odio} which chown)
[ y"${sco}" == "y" ] && exit 98
[ -x ${sco} ] || exit 97

smd="/bin/mkdir"
debug=1
	
case "${1}" in
	d1)
		echo "d ) BEFORE CHMOD"
		sleep 2

		if [ x"${CONF_tmpdir}" != "x" ] ; then
			${scm} -R a+w ${CONF_tmpdir}
			echo "CHMOD DONRE"
			sleep 2

			echo "${smr} -rf ${CONF_tmpdir}/* IN 6 SECS";sleep 6	
			${smr} -rf ${CONF_tmpdir}/*
			[ $? -eq 0 ] || echo "sudo daleK.bash d2 ?"
			csleep 5
			${scm} 0755 ${CONF_tmpdir}
		fi

		if [ ${debug} -gt 0 ] ; then
			ls -las ${CONF_tmpdir} 
			sleep 5
		fi
	;;
	d2)
		[ -v CONF_squash0 ] || exit 66
		[ -z "${CONF_squash0}" ] && exit 67
		[ -d ${CONF_squash0} ] || exit 68
		pwd;sleep 6
	
		#onko riittävä tarkistus vai ei?
		if [ x"${CONF_squash0}" != "x/" ] ; then
			#josko nyt prkl?
			${sco} -R devuan:devuan ${CONF_squash0}
			echo $?;sleep 5
			${scm} -R 0777 ${CONF_squash0}
			echo $?;sleep 5

			echo "${smr} -rf ${CONF_squash0}/* IN 6 SECS";sleep 6
			
			${smr} -rf ${CONF_squash0}/*
			echo $?
		fi
	;;
	m)

		
function make_tgt_dirs() {
	dqb "s0b.MAKE_t_DIRS( ${1} , ${2}, ${3})"
	csleep 1

	[ -z "${1}" ] && exit 99
	[ x"${1}" != "x/" ] || exit 100
	[ -z "${2}" ] && exit 101
	[ -z "${3}" ] && exit 102
	
	dqb "PARAMZx OK"
	csleep 1

	dqb "CRS"
	[ -d ${2} ] || ${smd} -p ${2}

	#tämän rivin kanssa oli jotain urputusta 230526
	${sco} 0:0 ${2}

	${scm} 0755 ${2}
	ls -las ${2}
	csleep 10	
	
	dqb "UQS(${CONF_squash_dir})"
	[ -d ${CONF_squash_dir} ] || ${smd} -p ${CONF_squash_dir}
	[ ${debug} -gt 0 ] && ls -las ${CONF_squash_dir}
	csleep 2
	
	dqb "FR0ST"
	#ao. if-blokin pointti?

	if [ ! -d ${1} ] ; then
		${smd} -p ${1}
	else
		dqb "rm ${1}"
		sleep 6
		${smr} -rf ${1}/*
	fi

	csleep 1
	dqb "BLADDER"

	if [ "${3}" != "grub" ] ; then
		[ -d ${1}/${3} ] || ${smd} -p ${1}/${3}
	else
		[ -d ${1}/boot/grub ] || ${smd} -p ${1}/boot/grub
	fi

	csleep 1
	dqb "LIVE-EVIL"
	[ -d ${1}/live ] || ${smd} -p ${1}/live
	csleep 1 

	dqb "DGSTS"
	[ -d ${1}/${TARGET_DIGESTS_dir} ] || ${smd} -p ${1}/${TARGET_DIGESTS_dir}
	csleep 1

	dqb "DAP"
	[ -d ${1}/${TARGET_pad_dir} ] || ${smd} -p ${1}/${TARGET_pad_dir}
	csleep 1

	dqb "TUQ"
	[ -d ${1}/../out ] || ${smd} -p ${1}/../out
	csleep 1

	#josko vähitellen ?
	dqb "FN1AL"
	${sco} -R $(whoami):$(whoami) ${1}
	${scm} -R u+w ${1}
	csleep 10

	dqb "JUST BEFORE scm 0755 ALL SUBDIRS"
	local f

	for f in $(find ${1} -type d ); do
		dqb "${scm} 0755 ${f}"
		${scm} 0755 ${f}
		csleep 1
	 done

	csleep 1
	[ ${debug} -gt 0 ] && ls -laR ${1}
	csleep 17
	dqb "...done\n"
}
		echo "JUST BEFORE make_tgt_drs"
		make_tgt_dirs ${CONF_target} ${CONF_source} ${CONF_bloader}
	;;
	b)
		
function bbb() {
	dqb ";bbb( ${1} ) (OGDRU JAHAD"

	[ -z "${1}" ] && exit 97
	[ x"${1}" == "x/" ] && exit 98
	[ -d ${1} ] || exit 99

	dqb "pars_ok"
	csleep 1

	cd ${1}
	[ ${debug} -eq 1 ] && pwd
	csleep 4

	pwd
	echo "RM STARTS IN 6 SECS";sleep 6 #tämmöisestä rivistä fktio
	
	${smr} -rf ./run/live
	${smr} -rf ./boot/grub/*
	#${smr} -rf ./boot/* #080226 kommentteihin. vöib sotkea
	${smr} -rf ./usr/share/doc/*
	
	#HSIPUT WTTUUN
	for f in $(find . -type f -name "*.deb") ; do
		dqb "${smr} ${f}"
		csleep 1
		${smr} ${f}
	done
	
	csleep 5
	
	${smr} -rf ./var/cache/apt/*.bin
	${smr} -rf ./tmp/*
	
	[ -v TARGET_pad2 ] || exit 64
	${smr} -rf ./${TARGET_pad2}/*.bz3*
	${smr} -rf ./${TARGET_pad2}/*.OLD
	
	for f in $(find ./home -type f -name "*.tar") ; do
		dqb "smr ${f}"
		csleep 1
		${smr} ${f}
	done
	
	csleep 1
	
	${sco} -R 0:0 ./${TARGET_pad2}
	#fix_sudo $(pwd) #qtsuvassa koodissa?
	${scm} -R 0755 ./var/cache/man
	${sco} -R man:man ./var/cache/man

	${smr} ./root/.bash_history
	${smr} ./home/devuan/.bash_history

	#OLD.tar myös pois?

	for f in $(find ./var/log -type f) ; do ${smr} ${f} ; done
	dqb "BARBEQUE PARTY DONE.done()"
}
		bbb ${CONF_squash_dir}
	;;
	*)
		echo "???"
	;;
esac
