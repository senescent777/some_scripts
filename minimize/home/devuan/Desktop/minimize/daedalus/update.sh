#!/bin/bash
d=$(dirname $0)
debug=1

#VAIH:tämä paska toimimaan 

if [ -s ${d}/conf ] && [ -s ${d}/lib.sh ] ; then
	. ${d}/conf
	. ${d}/lib.sh

	#echo "${scm} a-wx ~/Desktop/minimize/*.sh"
else
	echo "TODO:fallback"
fi

debug=1
[ x"${1}" == "x" ] && exit

dqb "BEFORE"
${som} ${part} ${dir}
csleep 3
${som} | grep ${part} 
csleep 3

e=$(dirname ${1})
f=$(basename ${1})
find ${e} -name ${f}
dqb "find ${e} -name ${f}"
csleep 3

if [ -s ${1} ] ; then
	dqb "${srat} -f ${1} -rp ~/Desktop/*.desktop ~/Desktop/minimize in 3 s3cs"
	csleep 3

	${srat} -f ${1} -rp ~/Desktop/*.desktop ~/Desktop/minimize	
	[ $? -eq 0 ] || echo "${sco} <smthng> ${1} or ${scm} <smthng> ${1} would be a good idea now"
else
	echo "NO SUCH THING AS ${1} "
fi

dqb "AFTER"
csleep 3
${uom} ${part} 
csleep 3
${som} | grep ${part}