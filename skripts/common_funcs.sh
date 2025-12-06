function parse_opts_1() {
	dqb "cpars.op-1(${1})"

	#HUOM.271125:pari ekaa casea eivät ehkä tarpeellisia nykyään koska x
	case ${1} in
		-h|--h)
			usage
			exit
		;;
		-v|--v)
			debug=1
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
			dqb "LIIMANAAMA"
			source=${2}
		;;
		*)
			parse_opts_real ${1} ${2}
		;;
	esac
}

fq=$(find ${CONF_BASEDIR} -type f -name common_lib.sh | head -n 1)

if [ -z ${fq} ] ; then
	. ./common_funcs_old.sh
else
	#debug=1 301125:josko jo riittäisi debug-ulostukset

	if [ -x ${fq} ] ; then
		. ${fq}

		#061225:toistaiseksi tässä kunnes
		gi=$(${odio} which genisoimage)
		gmk=$(${odio} which grub-mkrescue)
		xi=$(${odio} which xorriso)
	else
		. ./common_funcs_old.sh
	fi
fi

unset fq