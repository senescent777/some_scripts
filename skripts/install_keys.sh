#!/bin/bash
ridk=""
d=$(dirname $0) #sittenkin näin

. ${d}/common.conf
. ${d}/common_funcs.sh

if [ -f ${d}/keys.conf ] ; then
	. ${d}/keys.conf
fi


function usage() {
	echo "${0} --kdir <kdir> --i Imports keys from <kdir>"
	echo "${0} --kdir <kdir> --e Exports keys to <kdir>"
	echo "${0} --kdir <kdir> --m Makes 2 keys , <kdir> still needed"
}

function tpop() {
	case ${1} in
		--kdir)
			ridk=${2}
		;;
		--v)
		;;
		*)
			cmd=${1}
		;;
	esac
}


tpop ${1} ${2}
tpop ${3} ${4}

[ x"${ridk}" != "x" ] || echo "https://www.youtube.com/watch?v=KnH2dxemO5o"
[ -d ${ridk} ] || echo "https://www.youtube.com/watch?v=KnH2dxemO5o"


case ${cmd} in
	--i)
		for f in ${TARGET_Dkname1} ${TARGET_Dkname2} ${TARGET_Dkname1}.secret ${TARGET_Dkname2}.secret ; do
			echo "dbg: ${gg} --import ${ridk}/${f}"
			${gg} --import ${ridk}/${f}
		done

	;;
	--e) 
		[ x"${CONF_kay1name}" != "x" ] || exit 666
		[ x"${CONF_kay2name}" != "x" ] || exit 666

		sudo rm ${ridk}/${TARGET_Dkname1}*
		sudo rm ${ridk}/${TARGET_Dkname2}*

		${gg} --export ${CONF_kay1name} > ${ridk}/${TARGET_Dkname1}
		${gg} --export ${CONF_kay2name} > ${ridk}/${TARGET_Dkname2}
	;;
	--m)
		#cd ~
		#mv ~/.gnupg ~/.gnupg.OLD #HUOM.27725:PAREMPI OLLA SORKKIMATTA

		echo "${gg} --generate-key in 5 secs"
		sleep 5


		${gg} --generate-key
		sleep 5
		${gg} --generate-key
		sleep 5
	
		[ -s ${ridk}/k3yz.tar.bz2 ] && mv ${ridk}/k3yz.tar.bz2 ${ridk}/k3yz.tar.bz2.OLD
		tar -jcvf ${ridk}/k3yz.tar.bz2 ~/.gnupg
	
		[ -s ${d}/keys.conf ] || cp  ${d}/keys.conf.example ${d}/keys.conf
		${gg} --list-keys >> ${d}/keys.conf 
		
		 
		nano ${d}/keys.conf #$EDITOR jatkossa

	;;
	*)
		usage
	;;
esac
