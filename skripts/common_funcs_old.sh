#VAIH:ce common_lib.sh includeointi
odio=$(which sudo) 
#VAIH:sudoon liittyen se sudoers-meshuggah-jekku käyttöön myös näihin remasterointiskripteihimn, varm. vuoksi
#seur. pitäisi testata mitä tapahtuu omegan ajamisen jölkeen
#========================tilapäisesti tässä, common_lib myöh==

sah6=$(${odio} which sha512sum)
sah6=$(${odio} which sha512sum)
[ -x ${sah6} ] || echo "install sha512sum !!!" #vissiin coreutils sisälsi tuon

gg=$(${odio} which gpg)
gv=$(${odio} which gpgv)
gi=$(${odio} which genisoimage)
gmk=$(${odio} which grub-mkrescue)
xi=$(${odio} which xorriso)

##========================tilapäisesti tässä, common_lib myöh==

#tarttisko tälle tehdä jotain?
#sca=$(${odio} which chattr)
#sca="${odio} ${sca}"

svm=$(${odio} which mv) #kts. loitrs_new ...EIQ
svm="${odio} ${svm}"

smd=$(${odio} which mkdir)
smd="${odio} ${smd}"

sco=$(${odio} which chown)
scm=$(${odio} which chmod)
sco="${odio} ${sco} "
scm="${odio} ${scm} "
#
spc=$(${odio} which cp)
spc="${odio} ${spc} "
n=$(whoami)
smr=$(${odio} which rm)
smr="${odio} ${smr} "
#
som=$(${odio} which mount)
uom=$(${odio} which umount)
som="${odio} ${som} "
uom="${odio} ${uom} "

function dqb() {
	[ ${debug} -eq 1 ] && echo ${1}
}

function csleep() {
	[ ${debug} -eq 1 ] && sleep ${1}
}

#VAIH:än asti juttujen korvaaminen toisen projektin common_lib
#============================================

function parse_opts_1() {
	dqb "cpars.op-1(${1})"

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
			source=${2}
		;;
		*)
			parse_opts_real ${1} ${2}
		;;
	esac
}

#====================common_lib.sh==================================
function gpo() {
	dqb "GPO"
	#getopt olisi myös keksitty
	
	local prevopt
	local opt
	prevopt=""

	if [ $# -lt 1 ] ; then
		echo "$0 -h" #VAIH:exit jos ei param
		exit
	fi

	for opt in $@ ; do
		parse_opts_1 ${opt}
		parse_opts_2 ${prevopt} ${opt}
		prevopt=${opt}
	done
}

gpo "$@"
#====================common_lib.sh==================================
