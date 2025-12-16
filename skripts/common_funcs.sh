function parse_opts_1() {
	dqb "cpars.op-1(${1})"

	case ${1} in
		-h|--h) #121225:antaa tämän olla vielä tässä (josqs pois?)
			usage
			exit
		;;
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

fq=$(find ${CONF_BASEDIR} -type f -name common_lib.sh | head -n 1)
fr=$(find ${CONF_BASEDIR} -type f -name common_funcs_old.sh | head -n 1)
	
if [ -z ${fq} ] ; then
	. ${fr} #./common_funcs_old.sh
else
	#debug=1 301125:josko jo riittäisi debug-ulostukset

	if [ -x ${fq} ] ; then
		. ${fq}
		
		#151225:jos tästä olisi jotain hyötyä
		check_binaries
		check_binaries2

		#061225:toistaiseksi tässä ellei
		gi=$(${odio} which genisoimage)
		gmk=$(${odio} which grub-mkrescue)
		xi=$(${odio} which xorriso)
	else
		. ${fr} #./common_funcs_old.sh
	fi
fi

unset fq
unset fr