#HUOM.091025:OK
function xxx() {
	dqb "xxx( ${1}, ${2})"

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

	if [ x"${msq}" != "x" ] && [ -x ${msq} ] ; then 
		${odio} ${msq} . ${1} -comp xz -b 1048576
	else
		echo "${odio} apt-get install squashfs-utils"
	fi
	
	csleep 1
	dqb "cfd() DONE"
}

#myös 201225 testattu ja taisi toimia ok
#sudoers-jekku olisi hyväksi tässäkin
function bbb() {
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
	
	#TODO:findillä etsitään . alta .deb && hukataan , voi olla muuallakin kuin vain /var
	${smr} -rf ./var/cache/apt/archives/*.deb
	${smr} -rf ./var/cache/apt/*.bin
	${smr} -rf ./tmp/*
	
	[ -v TARGET_pad2 ] || exit 64
	${smr} -rf ./${TARGET_pad2}/*.bz3*
	${smr} -rf ./${TARGET_pad2}/*.OLD
	csleep 1
	
	${sco} -R 0:0 ./${TARGET_pad2}
	fix_sudo $(pwd)
	${scm} -R 0755 ./var/cache/man
	${sco} -R man:man ./var/cache/man

	${smr} ./root/.bash_history
	${smr} ./home/devuan/.bash_history

	for f in $(find ./var/log -type f) ; do ${smr} ${f} ; done
	dqb "BARBEQUE PARTY DONE.done()"
}

#211225:toiminee edelleen
function jlk_main() {
	dqb "jkl_niam ( ${1} , ${2}  )"

	[ x"${1}" == "x" ] && exit 66
	[ x"${2}" == "x" ] && exit 67
	[ -d ${1} ] || exit 68
	[ -d ${2} ] || exit 69

	dqb "pars_ok"
	csleep 1
	
	#for-loopissakin voisi...
	${spc} ${1}/*.sh ${2}
	${spc} ${1}/*.bz2 ${2} 
	${spc} ${1}/*.bz3 ${2}

	dqb "jkl1 d0n3"
}

#... ideana aiemmin että root.conf olisi sq-chr-ymp varten , devuan.conf taas ei
#kts. myös stage0_backend.bsh , copy_conf()
#
#mankeloi sen conf-tiedoston (281125:oliko vielä jotain spesifistä juttua tähän liittyen?)
#Const T_P2 mäkeen fktiosta?
#
#lienee ok 281125
#TODO:keys.conf:in sisällön greppailu mukaan?
#sqroot sisällä ei tarvita: CONF_dir, CONF_pkgsrv? , BASEDIR
#
#TODO:kommentoitujen siivoys
#TODO:root.conf dgsts.tdstoon mukana jos ei ole jo ?
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

#1.mitäköhän parametreja tälle fktiolle piti antaa? lhde j khde tietenkin
#
#sopivilla parametreilla kopsaa dgsts-hkmiston kohteeseen, ensisij tsummat , jos julk av löytyvät lähteestä niin nekin 
#liittyyköhän copy_conf() @stage0_backend ? tai mksums.sh ? 
function jlk_sums() {
	dqb "jlk_sums( ${1} , ${2}, ${3}) "
	csleep 2

	[ x"${1}" != "x" ] || exit 66
	[ -d ${1} ] || exit 67
	[ -z ${2} ] && exit 68
	dqb "pars ok"
	csleep 2

	[ -d ${2}} ] || ${smd} -p ${2}
	dqb "${spc} -a ${1}/ \$stuff ${2}"
	csleep 2

	#261225:voi kyllä mennä wanhentunut dgsts jihteeseen tälleen
	${spc} ${1}/${TARGET_DIGESTS_file0}.* ${2}
	${spc} ${1}/*.gpg ${2}
	${spc} ${1}/*.sig ${2} #uutena
	
	[ ${debug} -gt 0 ] && ls -las ${2}
	csleep 2
	cd ${2}/../..

	[ ${debug} -gt 0 ] && pwd
	dqb "${sah6} -c ./${TARGET_DIGESTS_dir}/${TARGET_DIGESTS_file}.5 --ignore-missing"
	csleep 1
	
	#miksi urputusta tässä kohtaa? lähteessä wanha dgsgs?
	${sah6} -c ./${TARGET_DIGESTS_dir}/${TARGET_DIGESTS_file}.5 --ignore-missing

	dqb "JLK_SUYMD_DONE"
	sleep 2
}

#HUOM.091025:OK
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

	env | grep LAN > ./etc/default/locale
	env | grep LC >> ./etc/default/locale
	csleep 1
		
	reqwreqw ./etc/default/locale
	csleep 1

	[ -f ./etc/hosts ] && ${svm} ./etc/hosts ./etc/hosts.bak	
	${spc} /etc/hosts ./etc
	${odio} touch ./.chroot

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
	[ -z "${1}" ] && exit 13
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
