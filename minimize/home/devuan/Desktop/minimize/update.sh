#!/bin/bash
. ~/Desktop/minimize/daedalus/conf #jos jotenkin automaagisemmin jatqssa(TODO)
. ~/Desktop/minimize/daedalus/lib.sh
${scm} a-wx ~/Desktop/minimize/*.sh

[ x"${1}" == "x" ] && exit
${som} ${part} ${dir}
csleep 3
${som} | grep /dev
[ -s ${1} ] && ${srat} -rvpf ${1} ~/Desktop/*.desktop ~/Desktop/minimize
csleep 3
${uom} ${part} 
csleep 3
${som} | grep /dev