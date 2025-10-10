odio=$(which sudo) 
##TODO:sudoon liittyen se sudoers-meshuggah-jekku käyttöön myös näöhin remasterointiskripteihimn, varm. vuoksi
##========================tilapäisesti tässä, common_lib myöh==

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

#svm=$(${odio} which mv) #missä nitä tarvittiin vai tarvittiinko?
#svm="${odio} ${svm}"

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

#TODO:tähän asti juttujen korvaaminen toisen projektin common_lib
#============================================

#se uusi gpo() tilalle?
function parse_opts() {

	dqb "parse_opts(${1}, ${2})"

	local common_pars
	common_pars=0

	#TODO:--bl mukaan yelisiin optioihin?
	if [ x"$1" != "x" ] ; then 
		if [ x"$2" != "x" ] ; then
			case ${1} in
				-v|-V|--v|--V)
					common_pars=1
				;;
				*)
					parse_opts_real ${1} ${2}
				;;
			esac
		else
			case ${1} in
				-h|--h)
					common_pars=1
					usage
				;;
				*)
					single_param ${1}
				;;		
			esac
		fi

		if [ x"${cmd}" != "x" ] ; then
			echo "1"
		else
			if [ ${common_pars} -eq 0 ] ; then
				echo 0
				cmd=${1}
			fi
		fi
	fi
}

###missä tätä käytetään?
##function mk_bkup() { 
##	dqb "mk_bkup(${1})"
##	
##	if [ -s ${1} ] ; then
##		${svm} ${1} ${1}.OLD
##	fi
##}##