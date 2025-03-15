##!/bin/bash
#d=$(dirname $0)
#debug=1
#
##VAIH:tämä paska toimimaan (tai jokin git-viritys olisi kanssa idea)
##HUOM.jos toimimaan ni common_lib mukaan ja conf mukaan eri tavalla
#
i#f [ -s ${d}/conf ] && [ -s ${d}/lib.sh ] ; then
#	. ${d}/conf
#	. ${d}/lib.sh
#else
#	som="sudo /bin/mount"
#	uom="sudo /bin/umount"
#	srat="sudo /bin/tar"
#	sco="sudo /bin/chown"
#	scm="sudo /bin/chmod"
#
#	function dqb() {
#		[ ${debug} -eq 1 ] && echo ${1}
#	}
#	
#	function csleep() {
#		[ ${debug} -eq 1 ] && sleep ${1}
#	}
#
#fi
#
#part=/dev/disk/by-uuid/${part0}
#debug=1
#[ x"${1}" == "x" ] && exit
#
#dqb "BEFORE"
#${som} ${part} ${dir}
#[ $? -eq 0 ] || exit
#
#csleep 3
#${som} | grep ${dir} 
#csleep 3
#
#e=$(dirname ${1})
#f=$(basename ${1})
#find ${e} -name ${f}
#dqb "find ${e} -name ${f}"
#csleep 3
#
#if [ -s ${1} ] ; then
#	dqb "${srat} -f ${1} -rp ~/Desktop/*.desktop ~/Desktop/minimize in 3 s3cs"
#	csleep 3
#
#	${srat} -f ${1} -rp ~/Desktop/*.desktop ~/Desktop/minimize	
#	[ $? -eq 0 ] || echo "${sco} <smthng> ${1} or ${scm} <smthng> ${1} would be a good idea now"
#else
#	echo "NO SUCH THING AS ${1} "
#fi
#
#dqb "AFTER"
#csleep 3
#${uom} ${dir} 
#csleep 3
#${som} | grep ${dir}