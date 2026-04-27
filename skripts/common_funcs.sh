function parse_opts_1() {
	dqb "cf.pars.op-1( ${1} )"

	case ${1} in
		*)
			single_param ${1}
		;;
	esac
}

function parse_opts_2() {
	case ${1} in
		--bl|-bl)
			bl=${2}
		;;
		--in)
			dqb "TR0LLKAMMAR3N"
			source=${2}
		;;
		*)
			parse_opts_real ${1} ${2}
		;;
	esac
}

# " ] -v [ " - testejä tähän?
fq=$(find ${CONF_BASEDIR} -type f -name common_lib.sh | head -n 1)
fr=$(find ${CONF_BASEDIR} -type f -name common_funcs_old.sh | head -n 1)
	
if [ -z "${fq}" ] ; then
	. ${fr}
else
	[ -v d ] || echo "d n0t set"
	[ -s ${d0}/$(whoami).conf ] || echo "N0 ALT C0NF"	
	[ -s ${d}/conf ] || echo "N0 PR1MARY C0NF"
	sleep 1
	
	if [ -x ${fq} ] ; then
		. ${fq}
		
		#param mukaisen hmiston takaa olisi hyväksi löytyä toivottavaa sisältöä, barm vuoksi
		#,,, vöhön sietäisi kyllä miettiä vielä koska mussunmussun		
		check_binaries ${CONF_testgris}
		check_binaries2

		#061225:toistaiseksi tässä ellei
		gi=$(${odio} which genisoimage)
		gmk=$(${odio} which grub-mkrescue)
		xi=$(${odio} which xorriso)
	else
		. ${fr}
	fi
fi

unset fq
unset fr
