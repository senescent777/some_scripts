
#HUOM.091025:OK
function xxx() {
	#debug=1
	dqb "xxx( ${1}, ${2})"
	#tulisi stopata tässä jos ei kalaa

	[ -s ${1} ] || exit 99
	[ -z "${2}" ] && exit 98

	dqb "pars_ok"
	csleep 1

	#ao.blokki toistruu melkein samanlaisena toisessa kohtaa, cfd()
	[ -d ${2} ] || ${smd} ${2}
	cd ${2}

	local unsq
	unsq=$(${odio} which unsquashfs)

	if [ x"${unsq}" != "x" ] ; then 
		${odio} ${unsq} ${1}
	else
		echo "${odio} apt-get install squashfs-utils"
	fi

	dqb "xxx d0mw"
}

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

#myös 281125 testattu ja taisi toimia ok
#sudoers-jekku olisi hyväksi tässäkin
function bbb() {
	#debug=1
	dqb "bbb( ${1} ) OGDRU JAHAD"

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

	for f in $(find ./var/log -type f) ; do ${smr} ${f} ; done
	dqb "BARBEQUE PARTY DONE.done()"
}

#lienee kai ok 281125
function jlk_main() {
	dqb "jkl1 $1 , ${2} "

	[ x"${1}" == "x" ] && exit 66
	[ x"${2}" == "x" ] && exit 67
	[ -d ${1} ] || exit 68
	[ -d ${2} ] || exit 69 #291125:jos ei ole ni pitäisikö luoda?

	dqb "pars_ok"
	csleep 1

	#HUOM.olisi hyvä olemassa sellainen bz3 tai bz2 missä julk av
	#vieläpä s.e. hakemistorakenteessa mukana pad/ jnka alla ne av

	${spc} ${1}/*.sh ${2}
	${spc} ${1}/*.bz2 ${2} #myös bz2.sha mukaan?
	${spc} ${1}/*.bz3* ${2}

	dqb "jkl1 d0n3"
}

#... ideana aiemmin että root.conf olisi sq-chr-ymp varten , devuan.conf taas ei
#kts. myös stage0_backend.bsh , copy_conf()
#
#mankeloi sen conf-tiedoston (281125:oliko vielä jotain spesifistä juttua tähän liittyen?)
#Const T_P2 mäkeen fktiosta?
#
#lienee ok 281125
#
#
function jlk_conf() {
	dqb "jlk_conf( ${1} , ${2} , ${3}) "
	csleep 2

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
		
	${smr} ${t}/root.conf
	${smr} ${t}/${2}.conf	
	csleep 5

	fasdfasd  ${t}/root.conf
	csleep 5

	ls -las ${1}/${2}.conf	
	csleep 5

	grep -v TARGET_to_ram ${1}/${2}.conf > ${t}/root.conf #tarpeellinen nykyään?
	echo "TARGET_to_ram=1" >> ${t}/root.conf #whether u can write to / or not
	csleep 5

	grep dnsm ${t}/root.conf
	csleep 5

	ls -las ${t}/*.conf
	csleep 5

	dqb "jlk_conf( ) DONE4"
	csleep 5
}

#1.mitäköhän paranetreja tälle fktiolle piti antaa?
#2.T_yyy kutsuvaanm koodiin vai ei?
#
#sopivilla parametreilla kopsaa dgsts-hkiston kohteeseen, ensisij tsummat , jos julk av löytyvät lähteestä niin nekin 
#
function jlk_sums() {
	#debug=1
	dqb "jlk_sums( ${1} , ${2}, ${3}) "
	csleep 4

	[ x"${1}" != "x" ] || exit 66
	[ -d ${1} ] || exit 67
	[ -z ${2} ] && exit 68

	#,,, mksums syytä huomioida (TARGET_DIGESTS_DIR)	
	[ ${debug} -eq 1 ] && pwd
	csleep 6

	[ -d ${2}} ] || ${smd} -p ${2}
	dqb "${spc} -a ${1}/* ${2}"
	csleep 3

	#VAIH:pitäisikö vähän rajata? jos dgsts.x riittäisi?
	${spc} -a ${1}/${TARGET_DIGESTS_file0}.* ${2}

	ls -las ./${TARGET_DGST0};csleep 5 #pitäisikö olla $2?
	cd ..

	#HUOM.281125:ei löydy .2_sta, pitäisikö?
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

function rst_pre2() {
	dqb "rst_pre2()"
	csleep 1
	pwd
	csleep 1

	[ -d ./etc ] || exit 66 #koita keksiä jokin toinen virhekoodi, tuthan yleinen
	csleep 1

	fasdfasd ./etc/default/locale
	csleep 1

	#HUOM.091025:lokaaleihjin liittyen:
	#LANGUAGE ja LC_ALL jos asettaisi jhnkn arvoon
	#HUOM.111225:miten suhtautuu check_bin2() nykyään tähän ao. riviin?

	#161225:josko nyt alkaisi /e/d/locale
	#locale > ./etc/default/locale

	env | grep LAN > ./etc/default/locale
	env | grep LC >> ./etc/default/locale
	csleep 1
		
	reqwreqw ./etc/default/locale
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
