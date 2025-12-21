#
#tgt=""
#d=$(dirname $0)
#debug=0
#. ${d}/common.conf
#
#if [ -f ${d}/keys.conf ] ; then
#	. ${d}/keys.conf
#fi
#
#function usage() {
#	echo "kind of a wrapper for gpg"
#	echo \r\n
#
#	#echo "${0} --tgt <tgt> --i Imports (public) keys from <tgt>"
#	#echo "${0} --tgt <tgt> --e Exports keys to <tgt>"
#	#echo "${0} --tgt <tgt> --m Makes 2 keys , <tgt> still needed"
#	echo "${0} --tgt <tgt> --j: 4 importing (private) keys from archiive"
#}
#
#function single_param() {
#	dqb "instk.single-param(${1})"
#	[ "${1}" == "-v" ] || cmd=${1} #pitäisikö se -v?
#}
#
#function parse_opts_real () {
#	case "${1}" in
#		--tgt)
#			tgt=${2}
#		;;
#	esac
#}
#
#. ${d}/common_funcs.sh
#[ -z "${tgt}" ] && echo "https://www.youtube.com/watch?v=KnH2dxemO5o"
##aiheeseen liittyen:miten wtussa gpgtarin saa toimimaan? --create ja -t vissiin toimii mutta --extract...
#
#
##
##VAIH:myös skriptin nimeäminen uudelleen, ei kaikki caset asennusta
##DONE?:josko TARGET_Dk_jutut pois jatkossa, CONF_karray:n alkioilla jatkossa samat jtut?
#
#case ${cmd} in
##	--i) #tällä hetkellä julk av varten
##vähän niinqu "import2 k" ... mikä sekin voisi mennä s.e. iteroidaan jostain hmistosta .gpg-päätteiset
##		[ -d ${tgt} ] || echo "https://www.youtube.com/watch?v=KnH2dxemO5o"
##
##		for f in Dkarray}  ; do
##			echo "dbg: ${gg} --import ${tgt}/${f}"
##			${gg} --import ${tgt}/${f}
##		done
##
##		${gg} --list-keys
##	;;
##	--e) 
##		[ -d ${tgt} ] || echo "https://www.youtube.com/watch?v=KnH2dxemO5o"
##
##		for f in karray}  ; do
##			echo "${smr} ${tgt}/${f}*"
##			${smr} ${tgt}/${f}*"
##		done
##
##		${gg} --export ${CONF_kay1name} > ${tgt}/Dkname1
##		${gg} --export ${CONF_kay2name} > ${tgt}/Dkname2
##	;;
##	--m) #vähän niinqu "export2 c"
##
##
##
##	;;
#	--j)
#		#vähän niinqu "export2 c" käänteisenä
#		[ -f ${tgt} ] || echo "https://www.youtube.com/watch?v=KnH2dxemO5o"
#		tar -C / -jxvf ${tgt} #/k3yz.tar.bz2
#		${gg} --list-keys
#	;;
#	*)
#		usage
#	;;
#esac
#
