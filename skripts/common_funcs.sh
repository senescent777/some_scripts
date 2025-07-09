odio=$(which sudo) #========================tilapäisesti tässä, common_lib myöh==

sh5=$(${odio} which sha512sum)
sh5=$(${odio} which sha512sum)
[ -x ${sh5} ] || echo "install sha512sum !!!" #TODO:selvitä missä paketissa olikaan tuo komento

gg=$(${odio} which gpg)
gv=$(${odio} which gpgv)
gi=$(${odio} which genisoimage)
gmk=$(${odio} which grub-mkrescue)
xi=$(${odio} which xorriso)
#========================tilapäisesti tässä, common_lib myöh==
#tarttisko tälle tehdä jotain?
sca=$(${odio} which chattr)
sca="${odio} ${sca}"

svm=$(${odio} which mv)
svm="${odio} ${svm}"

smd=$(${odio} which mkdir)
smd="${odio} ${smd}"

sco=$(${odio} which chown)
scm=$(${odio} which chmod)
sco="${odio} ${sco} "
scm="${odio} ${scm} "

spc=$(${odio} which cp)
spc="${odio} ${spc} "
n=$(whoami)

function dqb() {
	[ ${debug} -eq 1 ] && echo ${1}
}

function csleep() {
	[ ${debug} -eq 1 ] && sleep ${1}
}
#============================================
#function griffindor() {
#	pwd
#	local of2
#
#	if [ x"${1}" != "x" ] ; then 
#		of2=${1}
#	else
#		of2=${TARGET_DIGESTS_file}.1
#	fi
#
#	${sh5} ./isolinux/* | grep -v boot.cat | grep -v isolinux.bin > ${of2}
#}
#
#function slithering() {
#	${sh5} ./boot/* > ${TARGET_DIGESTS_file}.1
#}
#
#function malfoy() {
#	${sh5} ./boot/* > ${1}
#}
#se uusi gpo() tilalle?
function parse_opts() {
	dqb "parse_opts(${1}, ${2})"
	local common_pars
	common_pars=0

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

			#[ ${common_pars} -eq 0 ] && 
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

			#[ ${common_pars} -eq 0 ] && 
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

function mk_bkup() { 
	dqb "mk_bkup(${1})"
	
	if [ -s ${1} ] ; then
		${svm} ${1} ${1}.OLD
	fi
}

#function slaughter0() {
#	local fn2
#	local ts2
#
#	fn2=$(echo $1 | awk '{print $1}') 
#	ts2=$(sha512sum ${fn2})
#
#	echo ${ts2} | awk '{print $1,$2}' >> ${2}
#}

function enforce_deps() {
	dqb "enf_deps"
	csleep 1
	pwd

	local doIt=0
	local doIt2=0
	local pkgsdir=${CONF_pkgsdir2}


	if [ -d ./${pkgsdir} ] ; then 
		doIt2=1
	else
		pkgsdir=${CONF_BASEDIR}/${CONF_pkgsdir2}

		if [ -d ${pkgsdir} ] ; then 
			doIt2=1
		else
			doIt2=2
		fi
	fi

	if [ x"${gg}" != "x" ] && [ -x ${gg} ] && [ -s ${gg} ] ; then
		dqb "gg ko"
	else
		echo "sudo apt-get install gpg*"
		doIt=${doIt2}
	fi

	if [ y"${gv}" != "y" ] && [ -x ${gv} ] && [ -s ${gv} ] ; then
		dqb "gvv qo"
	else
		echo "sudo apt-get install gpgv*"
		doIt=${doIt2}
	fi

	if [ z"{sh5}" != "z" ] && [ -x ${sh5} ] && [ -s ${sh5} ] ; then
		dqb "s5 k0"
	else
		doIt=${doIt2}
	fi
	
	if [ w"${gi}" != "w" ] && [ -x ${gi} ] && [ -s ${gi} ] ; then 
		dqb "gi k0"
	else
		echo "no genisoimage"
		doIt=${doIt2}
	fi	

	if [ v"${gmk}" != "v" ] && [ -x ${gmk} ] && [ -s ${gmk} ] ; then
		dqb "gmk+0"
	else
		echo "no grub-mkrescue"
	fi
	
	if [ u"${xi}" != "u" ] &&  [ -x ${xi} ] && [ -s ${xi} ] ; then
		dqb "KINGPIN"
	else
		echo "no xorriso"
	fi

	case ${doIt} in 
		0)
			echo
		;;
		1)
			echo "doIt(1)"

			echo "cd ${CONF_keys_dir}"

			echo -n "for f in "
			echo -n ${TARGET_Dkeylist}
			echo -n " ; do ${gg} --import "
			echo -n "$"	
			echo "{f}; done "
		
			echo "cd ${pkgsdir}"
			echo "ls *.deb || ls *.bz2"

			echo -n "for f in "
			echo -n "$"
			echo -n "(ls ./{*.deb,*.bz2}) ; do "
			echo -n "${gv} --keyring ${CONF_keys_dir}/${TARGET_Dkname2} "
			echo -n "$"
			echo -n "f.sig "
			echo -n "$"
			echo "f; done"

			echo -n "[ "
			echo -n "$"
			echo "?==0 ] || exit"
			echo "sudo dpkg -i ./*.deb"

			echo "sudo tar -jxvf ./*.bz2"
			echo "sudo dpkg -i .${TARGET_pkgdir}/lib*.deb"
			echo "rm .${TARGET_pkgdir}/lib*.deb"
			echo "sudo dpkg -i .${TARGET_pkgdir}/*.deb"
			echo "sudo rm .${TARGET_pkgdir}/*.deb"	
		;;
		2)
			echo "sudo apt-get update;sudo apt-get install gpg* wodim genisoimage squashfs-utils xorriso grub*"
		;;
		*)
			echo "https://www.youtube.com/watch?v=KnH2dxemO5o" 
		;;
	esac

	[ ${doIt} -gt 0 ] && exit 666
}

function inst_dep() {
	dqb "inst.dep ${1}"
	
	case ${1} in
		0)
			echo "sudo apt-get install genisoimage wodim gpg*"
		;;
		1)
			for f in $(ls ${CONF_pkgsdir2}/*.deb) ; do
				${gv} --keyring ${CONF_target}/${TARGET_Dpubkg} ${f}.sig ${f}
			done

			if [ $? -eq 0 ] ; then 
				sudo dpkg -i ${CONF_pkgsdir2}/*.deb
			fi
		;;
		*)
			echo "https://www.youtube.com/watch?v=PjotFePip2M" 
		;;
	esac

	exit 666
}

function protect_system() {
	dqb "protect_system()"
	csleep 1

	for d in /sys /run /etc /usr /bin /sbin /dev /proc /root /home /usr /var ; do
		dqb "${sca} ${d}"
	done

	csleep 1
	dqb "pro.sys.d0n3"
}
