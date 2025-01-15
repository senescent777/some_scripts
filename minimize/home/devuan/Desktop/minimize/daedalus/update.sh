#!/bin/bash

d=$(dirname $0)
[ -s ${d}/conf ] && . ${d}/conf
[ -s ${d}/lib.sh ] && . ${d}/lib.sh
${scm} a-wx ~/Desktop/minimize/*.sh

[ x"${1}" == "x" ] && exit
${som} ${part} ${dir}
csleep 3
${som} | grep /dev
[ -s ${1} ] && ${srat} -rpf ${1} ~/Desktop/*.desktop ~/Desktop/minimize
csleep 3
${uom} ${part} 
csleep 3
${som} | grep /dev