#!/bin/bash
ridk=""
d=$(dirname $0) #sittenkin näin
debug=0
. ${d}/common.conf

if [ -f ${d}/keys.conf ] ; then
	. ${d}/keys.conf
fi

function usage() {
	echo "${0} --kdir <kdir> --i Imports (public) keys from <kdir>"
	echo "${0} --kdir <kdir> --e Exports keys to <kdir>"
	echo "${0} --kdir <kdir> --m Makes 2 keys , <kdir> still needed"
	echo "${0} --kdir <kdir> --j: 4 importing private keys (WORK IN PROGRESS)"
}

function single_param() {
	dqb "instk.single-param(${1})"
	cmd=${1}
}

function parse_opts_real () {
	case "${1}" in
		--kdir)
			ridk=${2}
		;;
	esac
}

. ${d}/common_funcs.sh

[ -z "${ridk}" ] && echo "https://www.youtube.com/watch?v=KnH2dxemO5o"
#VAIH:ridk-testaus vähän uusiksi koska --m
#[ -d ${ridk} ] || echo "https://www.youtube.com/watch?v=KnH2dxemO5o"

#aiheeseen liittyen:miten wtussa gpgtarin saa toimimaan? --create ja -t vissiin toimii mutta --extract...

#TODO:joutaisi testata kikki caset
#TODO:josko TARGET_Dk_jutut pois jatkossa, CONF_karray:n alkioilla jatkossa samat jtut?
case ${cmd} in

	--i) #tällä hetkellä julk av varten
		[ -d ${ridk} ] || echo "https://www.youtube.com/watch?v=KnH2dxemO5o"

		#VAIH:array konftdstoon?
		for f in ${TARGET_Dkarray}  ; do #${TARGET_Dkname1}.secret ${TARGET_Dkname2}.secret
			echo "dbg: ${gg} --import ${ridk}/${f}"
			${gg} --import ${ridk}/${f}
		done

		${gg} --list-keys
	;;
	--e) 
		[ -d ${ridk} ] || echo "https://www.youtube.com/watch?v=KnH2dxemO5o"

		#[ -v CONF_kay1name ] || exit 666
		#[ -v CONF_kay2name ] || exit 666
		#[ x"${CONF_kay1name}" != "x" ] || exit 666
		#[ x"${CONF_kay2name}" != "x" ] || exit 666

		#VAIH:array tähänkin
		#${smr} ${ridk}/${TARGET_Dkname1}*
		#${smr} ${ridk}/${TARGET_Dkname2}*

		for f in ${TARGET_Dkarray}  ; do
			echo "${smr} ${ridk}/${f}*"
			${smr} ${ridk}/${f}*"
		done

		#TODO:uusi array näitä varten+etenkin käyttöön?
		${gg} --export ${CONF_kay1name} > ${ridk}/${TARGET_Dkname1}
		${gg} --export ${CONF_kay2name} > ${ridk}/${TARGET_Dkname2}
	;;
	--m)
		echo "${gg} --generate-key in 5 secs"
		sleep 5

		${gg} --generate-key
		sleep 5
		${gg} --generate-key
		sleep 5
	
		#tartteeko joka ketra tehdä tämä?
		#VAIH:jatkossa jos sanoisi ihan arkiston nimen eikä vain hakemiston
		#...sitten alkaisi tämä skripti olla osittain päällekkäinen imp2 ja exp2 kanssa

		#[ -s ${ridk}/k3yz.tar.bz2 ] && mv ${ridk}/k3yz.tar.bz2 ${ridk}/k3yz.tar.bz2.OLD
		#tar -jcvf ${ridk}/k3yz.tar.bz2 ~/.gnupg
	
		[ -s ${ridk} ] && mv ${ridk} ${ridk}.OLD
		tar -jcvf ${ridk} ~/.gnupg

		if [ ! -s ${d}/keys.conf ] ; then
			cp ${d}/keys.conf.example ${d}/keys.conf
			${gg} --list-keys >> ${d}/keys.conf 

			nano ${d}/keys.conf
			#$EDITOR ${d}/keys.conf
		fi
	;;
	--j) #myös sal av
		#TODO:jatkossa ridk-muutos tähänkin
		[ -d ${ridk} ] || echo "https://www.youtube.com/watch?v=KnH2dxemO5o"

		#271125:jatkossa myös erillinen optio salaisia avaima varten vai ei? 
		tar -C / -jxvf ${ridk}/k3yz.tar.bz2
		${gg} --list-keys
	;;
	*)
		usage
	;;
esac