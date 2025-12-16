
odio=$(which sudo) 
#VAIH:sudoon liittyen se sudoers-meshuggah-jekku käyttöön myös näihin remasterointiskripteihimn, varm. vuoksi
#seur. pitäisi testata mitä tapahtuu omegan ajamisen jölkeen

sah6=$(${odio} which sha512sum)
sah6=$(${odio} which sha512sum)
[ -x ${sah6} ] || echo "install sha512sum !!!" #vissiin coreutils sisälsi tuon

gg=$(${odio} which gpg)
gv=$(${odio} which gpgv)
gi=$(${odio} which genisoimage)
gmk=$(${odio} which grub-mkrescue)
xi=$(${odio} which xorriso)

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

#josko toimisi kuteb tarkoitettu 141025
function fix_sudo() {
	dqb "sq22.fix_sudo( ${1}) "
	[ x"${1}" == "x" ] && exit 97
	[ -d ${1} ] || exit 98
	dqb "pars ok"
	csleep 1

	cd ${1}
	[ ${debug} -eq 1 ] && pwd
	csleep 1 

	${sco} -R 0:0 ./etc/sudo*
	${scm} -R a-w ./etc/sudo*
	${sco} -R 0:0 ./usr/lib/sudo/*

	#${sco} -R 0:0 ./usr/bin/sudo*
	#RUNNING SOME OF THESE COMMANDS OUTSIDE CHROOT ENV STARTED TO SEEM LIKE A BAD IDEA
	#AND BESIDES: CHATTR MAY NOT WORK WITH SOME FILESYSTEMS	

	#miten nuo jutut taas olikaan ennen siirtelyä?
	${scm} 0750 ./etc/sudoers.d
	${scm} 0440 /etc/sudoers.d/*

	${scm} -R a-w ./usr/lib/sudo/*
	${scm} -R a-w ./usr/bin/sudo*
	#${scm} 4555 ./usr/bin/sudo
	#${scm} 0444 ./usr/lib/sudo/sudoers.so

	#${sca} +ui ./usr/bin/sudo
	#${sca} +ui ./usr/lib/sudo/sudoers.so	
}

function gpo() {
	dqb "GPO"
	#getopt olisi myös keksitty
	
	local prevopt
	local opt
	prevopt=""

	if [ $# -lt 1 ] ; then
		echo "$0 -h" #:exit jos ei param?
		exit
	fi

	for opt in $@ ; do
		parse_opts_1 ${opt}
		parse_opts_2 ${prevopt} ${opt}
		prevopt=${opt}
	done
}

gpo "$@"