#!/bin/bash
d=$(dirname $0)
. ${d}/common.conf
. ${d}/common_funcs.sh

debug=1 #nollaus myöh
dir2=""
cmd=""
md=0
mp=0
ms=0
par=""
echo "TODO:isolinux.cfg"

function parse_opts_real() {
	echo "squash.parse_opts_real()" #dqb

	case ${1} in
		--dir2)
			dir2=${2}
			[ -d ${2} ] || exit 666
		;;
		-x|-y|-i|-j)
			if [ -s ${2} ] || [ -d ${2} ] ; then
				par=${2}
			fi
		;;
		-c)
			par=${2}
		;;
		-mp|--mp)
			mp=${2}
		;;
		-md|--md)
			md=${2}
		;;
		-ms|--ms)
			ms=${2}
		;;
	esac
}

function single_param() {
	cmd=${1}
	echo "sp"
}

parse_opts ${1} ${2}
parse_opts ${3} ${4}
parse_opts ${5} ${6}
parse_opts ${7} ${8}
parse_opts ${9} ${10}

#HUOM.091025:OK
function xxx() {
	#debug=1
	dqb "xxx( ${1}, ${2})"
	#tulisi stopata tässä jos ei kalaa

	[ -s ${1} ] || exit 99
	[ x"${2}" == "x" ] && exit 98
	#[ -d ${2} ]  || exit 97

	dqb "pars_ok"
	csleep 1

	#if [ x"${2}" != "x" ]; then
		#ao.blokki toistruu melkein samanlöaisena toisessa kohtaa, cfd()
		[ -d ${2} ] || ${smd} ${2}
		cd ${2}

		local unsq
		unsq=$(${odio} which unsquashfs)

		if [ x"${unsq}" != "x" ] ; then 
			${odio} ${unsq} ${1}
		else
			echo "${odio} apt-get install squashfs-utils"
		fi
	#fi

	dqb "xxx d0mw"
}

#jatkossa common_lib?
#HUOM.091025;
function fix_sudo() {
	dqb "fix_sudo( ${1}) "
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
		#AND CHATTR MAY OT WORK WITH SOME FILESYSTEMS	

		${scm} 0750 ./etc/sudoers.d
		${scm} 0440 /etc/sudoers.d/*

		${scm} -R a-w ./usr/lib/sudo/*
		#${scm} -R a-w ./usr/bin/sudo*
		#${scm} 4555 ./usr/bin/sudo
		${scm} 0444 ./usr/lib/sudo/sudoers.so

		#${sca} +ui ./usr/bin/sudo
		#${sca} +ui ./usr/lib/sudo/sudoers.so	
	
}

#HUOM.091025:OK
#sudoers-jekku hyväksi tässäkin
function bbb() {
	debug=1
	dqb "bbb( ${1} ) ohgUYHGIUTFD/()%E"

	[ x"${1}" == "x" ] && exit 97
	[ x"${1}" == "x/" ] && exit 98
	[ -d ${1} ] || exit 99

	dqb "pars_ok"
	csleep 1

			cd ${1}
			[ ${debug} -eq 1 ] && pwd
			csleep 4

			pwd
			echo "RM STARTS IN 6 SECS";sleep 6 #tämmöisestä rivistä fktio
			#sleep 6

			${smr} -rf ./run/live
			${smr} -rf ./boot/grub/*
			${smr} -rf ./boot/*
			${smr} -rf ./usr/share/doc/*	
			${smr} -rf ./var/cache/apt/archives/*.deb
			${smr} -rf ./var/cache/apt/*.bin
			${smr} -rf ./tmp/*

			fix_sudo $(pwd)
			${scm} -R 0755 ./var/cache/man
			${sco} -R man:man ./var/cache/man

			${smr} ./root/.bash_history
			${smr} ./home/devuan/.bash_history

			#uusi ominaisuus 230725
			for f in $(find ./var/log -type f) ; do ${smr} ${f} ; done

	dqb "BARBEQUE PARTY DONE.done()"
}

#VAIH:main-conf varten 3. param cd:tä varten? tai jtnkn muuten

#HUOM.27725:oikeasraan ch-ymp tarttisi gen_x-skriptut, common_lib ja necros.tz2 +ehkä import2
#poltettavalle kiekolle voisi mennä imp2+sen tarvitsemat (VAIH:se sq-chr-versio imp2sesta?)
#... tai siis jos ln -s chroot-imp2 v/$version/pad/imp2

#HUOM.091025:OK
function jlk_main() {
	dqb "jkl1 $1 , ${2} "

	[ x"${1}" == "x" ] && exit 66
	[ x"${2}" == "x" ] && exit 67
	[ -d ${1} ] || exit 68
	[ -d ${2} ] || exit 69

	dqb "pars_ok"
	csleep 1

	${spc} ${1}/*.sh ${2}
	${spc} ${1}/*.bz2 ${2}
	${spc} ${1}/*.bz3 ${2}

	dqb "jkl1 d0n3"
}

##TODO:parametreille järkev't arvot?

#... ideana aiemmin että root.conf olisi sq-chr-ymp varten , devuan.conf taas ei
#
#VAIH:koita arpoa voisiko tämän ottaa käyttöön bvai ei (stage0f kautta tulisi se devuan.cnf jos on tullakseen)
#VAIH:Const T_P2 mäkeen fktiosta

#HUOM.091026:OK
function jlk_conf() {
	dqb "jlk_conf( ${1} , ${2} , ${3}) "
	[ x"${1}" == "x" ] && exit 66
	[ x"${2}" == "x" ] && exit 67
	[ x"${3}" == "x" ] && exit 68

	[ -d ${1} ] || exit 69
	[ -s ${1}/${2}.conf ] || exit 70 #jatkossa pois tämä vai ei?
	[ -d ${3} ] || exit 71
	
	dqb "params_ok"
	[ ${debug} -eq 1 ] && pwd
	csleep 2
			
	local t
	t=${3}/${TARGET_pad2}
		
	${smr} ${t}/mf*
	${smr} ${t}/root.conf
	${smr} ${t}/${2}.conf
			
	sleep 5

	sudo touch ${t}/root.conf
	${sco} $(whoami):$(whoami) ${t}/root.conf
	${scm} 0644 ${t}/root.conf

	sleep 5 #jatkossa csleep

	grep -v TARGET_to_ram ${1}/${2}.conf > ${t}/root.conf 
	echo "TARGET_to_ram=1" >> ${t}/root.conf
	sleep 5

	ls -las ${t}/*.conf
	sleep 5

	dqb "jlk_conf( ) DONE4"
	csleep 5
}

#sah6=$(${odio} which sha512sum) c_funcs nykyään
#HUOM.031025:avainten kopsailu nyt stage0f.sh kautta
#... pitäsiköhän stage0f kopsata myös joitain skriptejä v/$version alle?
#
#mitäköhän paranetreja tälle fktiolle piti antaa?
#T_yyy kutsuvaanm kpoodiin vai ei?
#HUOM.091025:OK
function jlk_sums() {
	debug=1
	dqb "jlk_sums( ${1} , ${2}, ${3}) (VAIH)"

	[ x"${1}" != "x" ] || exit 66
	[ -d ${1} ] || exit 67
	#TODO:$2 tark

	#,,, mksums syytä huomioida (TARGET_DIGESTS_DIR)	
	pwd
	sleep 6

	[ -d ${2}} ] || ${smd} -p ${2}
	dqb "${spc} -a ${1}/* ${2}"
	csleep 3
	${spc} -a ${1}/* ${2}

	ls -las ./${TARGET_DGST0};sleep 5 #pitäisikö olla $2?
	cd ..
	${sah6} -c ${TARGET_DIGESTS_file}.2 --ignore-missing

	dqb "JLK_SUYMD_DONE"
	sleep 2
}

#HUOM.091§025:OK
function rst_pre1() {
	dqb "rst_pre1()"
	csleep 1

	if [ ${md} -gt 0 ] ; then
		dqb "MOUNTING PTOC"
		${som} -o bind /dev ./dev 
	fi

	if [ ${ms} -gt 0 ] ; then
		dqb "MOUNTING ssy"
		${som} -o bind /sys ./sys
	fi

	if [ ${mp} -gt 0 ] ; then
		dqb "MOUNTING PC9EOR"
		${som} -o bind /proc ./proc 
		${odio} ln -s ./proc/mounts ./etc/mtab
	fi

	dqb "DONME"
	csleep 1		
}

#HUOM.091025:OK
function rst_pre2() {
	dqb "rst_pre2()"
	csleep 1
	pwd
	csleep 1

	[ -d ./etc ] || exit 66
	csleep 1

		${sco} ${n}:${n} ./etc/default/locale #n parametriksi?
		${scm} 0644 ./etc/default/locale
		csleep 1

		#HUOM.091025:lokaaleihjin liittyen:
		#LANGUAGE ja LC_ALL jos asettaisi jhnkn arvoon
		locale > ./etc/default/locale
		csleep 1
		
		${scm} 0444 ./etc/default/locale
		${sco} 0:0 ./etc/default/locale
		csleep 1

		[ -f ./etc/hosts ] && ${svm} ./etc/hosts ./etc/hosts.bak	
		${spc} /etc/hosts ./etc
		${odio} touch ./.chroot
		#date > ./.chroot

	dqb "rst_pre2() done"
	csleep 1
}

#HUOM.091025:OK
function rst_post() {
	dqb "rst_post()"
	csleep 1

	pwd
	csleep 1

		${smr} ./.chroot			
		${svm} ./etc/hosts.bak ./etc/hosts
		${smr} ./etc/mtab

		sleep 3
	
		${uom} ./dev 
		${uom} ./sys
		${uom} ./proc

	dqb "DONE"
	csleep 1
}

#olikohan chroot-hommiin jotain valmista deb-pakettia? erityisesti soveltuvaa sellaista?
function rst() { #HUOM.091025:OK
	dqb "rst( ${1} , ${2} )"
	[ -z ${1} ] && exit 13
	[ -d ${1} ] || exit 14

	#TODO: $1 suhteen muitakin tarkistuksia?
	dqb "params ok (maybe)"
	csleep 1

		cd ${1}
		pwd
		csleep 1
 
		rst_pre2

		${odio} chroot ./ ./bin/bash #{scr} ?
		[ $? -eq 0 ] || echo "MOUNT -O REMOUNT,EXEC ${CONF_tmpdir0}"
		
		rst_post
		sleep 3

	dqb "rst() done"
	csleep 1
}

#TODO:tämän tdston pilkkominen in the name of MVC?

#HUOM.091025:OK
function cfd() {
	dqb "cfd( ${1}  ,  ${2} )"
	[ x"${1}" == "x" ] && exit 6
	[ -s ${1} ] && exit 66
	[ x"${2}" == "x" ] && exit 7
	[ -d ${2} ] || exit 77

	dqb "PARS IJ"
	csleep 1
	
		echo "${0} -b ?"
		cd ${2}

		local msq
		msq=$(${odio} which mksquashfs)
		#common_lib , ocs() ?

		if [ x"${msq}" != "x" ] && [ -x ${msq} ] ; then 
			${odio} ${msq} . ${1} -comp xz -b 1048576
		else
			echo "${odio} apt-get install squashfs-utils"
		fi
	
	csleep 1
	dqb "cfd() DONE"
}

function usage() {
	echo "-x <source_file>:eXtracts <source_file> to ${CONF_squash0} source_file NEEDS TO HAVE ABSOLUTE PATH"
	echo "\t (source could be under /r/l/m/live) "

	echo "-y <iso_file> extracts <iso_file>/live/filesystem.squashfs to ${CONF_squash0} NEEDS TO HAVE ABSOLUTE PATH"
	echo "-b is supposed to be run just Before -c but after -r (TODO)"
	echo "-d Destroys contents of ${CONF_squash0}/ and ${CONF_tmpdir} "
	echo "\t if possible, use -b instead\n"

	echo "-c <target_file> [optional_params_4_mksquashfs?] : Compresses ${CONF_squash_dir} to <target_file> (with optional_params?)\n NEEDS TO HAVE ABSOLUTE PATH"
	echo "-r :runs chRoot in ${CONF_squash_dir} "
	
	#echo "-i <src> : Installs scripts 2 chroot_dir  (TODO?)"
	echo "-j <src> [ --dir2 <stuff> ] : extracts dir 2 chroot_dir  NEEDS TO HAVE ABSOLUTE PATH"
	echo "\t to state the obvious:"
	echo "\t <stuff> in --dir2 has to contain sub-directory ${TARGET_DIGESTS_dir} , for example ${CONF_target} "
	echo "\t ... and <src> has to contain subdirectory ${TARGET_pad_dir} \n"

	echo "-f attempts to Fix some problems w/ sudo "
	echo "--v 1 adds Verbosity\n"

	echo "--mp,--md, --ms:self-explanatory opts 4 -r (TODO?)" 
	echo "\t potentially dangerous, so disabled by default , 1 enables"
}

#HUOM.031025:tätä jos voisi hyÖdyntää cHrootin kanssa? patch_list:in kautta yhetiset jutut esim conf ?
#function ijk() {
#	if [ x"${2}" != "x" ]; then
#		echo "${0} -x ?"
#		
#		previous=$(pwd)
#		${smd} -p ${2}/${TARGET_pad2}
#		cd ${2}/${TARGET_pad2}
#	
#		[ x"${1}" != "x" ] || exit 666
#		[ -d ${1} ] || exit 666
#
#		local d
#		for d in ${TARGET_patch_list_2} ; do ${spc} ${1}/${TARGET_pad_dir}/${d} . ; done
#
#		grep -v TARGET_to_ram devuan.conf > root.conf 
#	
#		${smr} devuan.conf
#		echo "TARGET_to_ram=1" >> root.conf
#		${scm} 0444 root.conf
#		cd ${previous}
#	fi
#}

case ${cmd} in
	-x) #HUOM.091025:havaittu toimivaksi
		xxx ${par} ${CONF_squash0}
	;;
	-y) #HUOM.091025:toimii... 
		#... vaan miten se -v tämän option kanssa?

		[ -s ${par} ] || exit 666
		[ -d ${CONF_source} ] || ${smd} -p ${CONF_source}
		dqb "${som} -o loop,ro ${par} ${CONF_source}"

		oldd=$(pwd)
		${som} -o loop,ro ${par} ${oldd}/${CONF_source}

		[ $? -eq 0 ] || exit
		[ ${debug} -eq 1 ] && ls -las ${oldd}/${CONF_source}/live/
		csleep 3

		#[ ${debug} -eq 1 ] && dirname $0
		[ ${debug} -eq 1 ] && pwd
		csleep 3

		xxx ${oldd}/${CONF_source}/live/filesystem.squashfs ${CONF_squash0}
		${uom} ${oldd}/${CONF_source}
	;;
	-b)
		#HUOM.091025:OK
		bbb ${CONF_squash_dir}
		#TODO;jhnkin se squash/pad-hmistn omistajuuden pakotus
	;;
	-d) #HUOM.091025:OK
		#pitäisikö olla -v - tark varm buoksi?
		#jos cd ensin?

		[ -v CONF_squash0 ] || exit 66
		[ -z CONF_squash0 ] && exit 67
		pwd;sleep 6

		if [ x"${CONF_squash0}" != "x" ] ; then
			echo "${smr} -rf ${CONF_squash0}/* IN 6 SECS";sleep 6
			${smr} -rf ${CONF_squash0}/*
		fi

		[ -v CONF_tmpdir ] || exit 68

		if [ x"${CONF_tmpdir}" != "x" ] ; then 
			echo "${smr} -rf ${CONF_tmpdir}/* IN 6 SECS";sleep 6	
			${smr} -rf ${CONF_tmpdir}/*
		fi
	;;
	-c) #HUOM.091025:OK
		#HUOM.tässäkin -v aiheutti urputuksen, tee jotain(TODO)
		cfd ${par} ${CONF_squash_dir}
	;;
	-r) #HUOM.091025:OK
		[ -v CONF_squash_dir ] || exit 666
		[ -z ${CONF_squash_dir} ] && exit 666

		#TODO:optionaalinen ajettava komento?
		rst_pre1
		rst ${CONF_squash_dir}
	;;
	-j) #HUOM.091025:OK?
		#jlk_jutut jollain atavlla yhdistäen stage0_backend:in juttujen kanssa?
		[ -d ${CONF_squash_dir}/${TARGET_pad2} ] || ${smd} -p ${CONF_squash_dir}/${TARGET_pad2}

		jlk_main ${par}/${TARGET_pad_dir} ${CONF_squash_dir}/${TARGET_pad2}/
		
		#jatkossa jo s ei erikseen dir2? , vaan -j jälkeen voisi tulla uaseampi hakemisto?
		#VAIH:joko jo alkaisi suorittaa dor2 suhteen?

		[ z"${dir2}" != "z" ] || echo "--dir2 "
		[ -d ${dir2} ] || echo "--dir2 "

		#j_cnf tuomaan mukanaan sen sq-chroot-spesifisaen konffin?
		jlk_conf ${dir2}/${TARGET_pad_dir} ${n} ${CONF_squash_dir}

		jlk_sums ${dir2}/${TARGET_DIGESTS_dir} ${CONF_squash_dir}/${TARGET_pad_dir}/${TARGET_DGST0}
		fix_sudo ${CONF_squash_dir}
	;;
	-f) #VAIH:testaa toimivuus
		fix_sudo ${CONF_squash_dir}
	;;
	*)
		usage
	;;
esac
