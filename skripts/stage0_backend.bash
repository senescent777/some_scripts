function mangle_conf() {
	dqb "mangle_conf ${1}, ${2}, ${3} "
	#TODO:jotain muutakin tähän, ehkä (lähteen greppailu kohteeseen)
	#tdstoista common.conf ja keys.conf pitäisi saada TARGET_D ja CONF_k - alkuiset
}

#HUOM.211225;tietenkin nuo $t-jutut toisella tavalla jatqssa, sisältö...
#dgsts.5 liittyen kts copy_sums() , kommentit
function copy_main() {
	dqb "copy_main(${1}, ${2}, ${3} )"

	[ -z "${1}" ] && exit 2
	[ -d ${2} ] || exit 22

	[ -z "${3}" ] && exit 33
	[ -d ${3} ] || exit 34

	dqb "CHECKS PASSED"
	local f
	csleep 1

	dqb "ONE BATCH"	
	csleep 1

	#eri lähde find-komennoilla ni jospa ei jaksaisi hýhgdistää ekaa findia
	for f in $(find ${3} -type f -name '*.sh') ; do	
		dqb "${spc} ${f} ${2}/../.. "
		${spc} ${f} ${2}/../.. 
	done

	dqb "TWO BATCH"
	csleep 1
	
	#191225:tuleeko ongelma siitä että linkkejä ei seurata?

	for f in $(find ${1} -name '*.sh' -or -name '*.bz2') ; do # -type f 
		dqb "${spc} ${f} ${2} "
		${spc} ${f} ${2}
	done
	
	dqb "PENNY AND A DIME"
	csleep 1
	dqb "copy_main() donw\n"
}

function copy_conf() {

	dqb "copy_conf(${1}, ${2} , ${3})"
	[ -z "${1}" ] && exit 2
	[ -z "${2}" ] && exit 4
	[ -d ${2} ] || exit 8
	[ -z "${3}" ] && exit 16
	
	csleep 1

	dqb "PARAMS OK"
	csleep 1

	if [ x"${CONF_scripts_dir}" != "x" ] ; then
		#pystyisi varmaan tekemään pelkällä findillä
		for f in $(find ${CONF_scripts_dir} -type f -name '*.conf' | grep -v bash) ; do
			dqb "${spc} ${f} ${2}/../.."
			${spc} ${f} ${2}/../.. 	
		done

		csleep 1
	fi

	#nykyään vähän erilainen upload kuin ao. blokkia kirJoittaessa
	if [ -s ${2}/upload.sh ] || [ -s ${2}/extras.tar.bz2 ] ; then 
		for f in ${CONF_g2} ; do mangle_conf ${f} ${2}/${3}.conf ; done
	fi

	utfile=${2}/${3}.conf
	#HUOM.041025:manlge_conf():iin pitäisi vähitellen keksiä sopiva sisältö?
	#... ja CONF_G1 kanssa ?

	for f in ${CONF_g1} ; do mangle_conf ${f} ${utfile} ; done

	echo -n "src=/" >> ${utfile}
	echo -n "$" >> ${utfile}
	echo "{TARGET_pad2}" >> ${utfile}	

	echo -n "tmpdir=" >> ${utfile}
	echo -n "$" >> ${utfile}
	echo "{TARGET_tmpdir}" >> ${utfile}	

	echo -n "pkgdir=" >> ${utfile}
	echo -n "$" >> ${utfile}
	echo "{TARGET_pkgdir}" >> ${utfile}	

	#jatkosssssa niin että grepattaisiin oletus-konftdstosta hakusanan muaksia kohde-tdstoon (näinnkö se meni 2+ vuotta sitten? ehkä)
	mangle_conf TARGET_to_ram ${utfile}
	mangle_conf TARGET_nosu_do ${utfile}
	
	#utfile:n käyttöokeudet s.e. sudoa ei tarvita?

	dqb " grep -v '#' ${1}/${3}.conf >> ${utfile}"
	grep -v '#' ${1}/${3}.conf >> ${utfile}
	csleep 2

	#tämä oikea paikka varmistaa että kys asetus mukana?
	grep dnsm ${utfile}
	csleep 2

	dqb "copy_conf() donw\n"
	sleep 1
}

function copy_sums() {
	dqb "copy_syms(${1}, ${2})" 

	[ -z "${1}" ] && exit 2
	[ -z "${2}" ] && exit 4

	dqb "pars ok"
	[ ${debug} -gt 0 ] && pwd
	csleep 1
	
	if [ -d ${2} ] ; then
		dqb "${2}  ALREADY EXZUISWTS"
	else
		${smd} -p ${2}
	fi
	
	#TODO:jos vielä vähän karsisi tuota findin listausta? , kts kutl.bash (pointti oli?)
	#... ja siihen liittyen myös cp-komennon suhteen muutos?
	local x=0
	local t
	
	if [ -d ${1} ] ; then
		x=$(find ${1} -type f -name '*.gpg' | wc -l)
		
		#toisinkin voisi tehdä
		t=${1}/${TARGET_DIGESTS_file}.5 
		[ -s ${t} ] && ${spc} ${t} ${2}
	fi
	
	if [ ${x} -gt 0 ] ; then
		dqb "${spc} ${1}/*.gpg ${2}"
		${spc} ${1}/*.gpg ${2}	#.sig kanssa?
	else
		dqb "NO FILES UNDER ${1} / \${TARGET_DGST0} , YSINBF DEFAYLT KEYDIR "

		#212125:jospa toimisi tämä avainjuttu nyt
		local k
		
		for k in ${CONF_karray} ; do
			dqb " {gg} --export ${k} > ${2}/${k}.gpg "
			${gg} --export ${k} > ${2}/${k}.gpg
		done
	fi

	[ ${debug} -gt 0 ] && ls -las ${2}
	csleep 3
	dqb "copy_syms(${1}, ${2}) dn0w\n"
}

#TODO:sudon pudon pudotus josqs myöh?
function bootloader() {
	dqb "bootloader(${1}, ${2}, ${3}, ${4} )"

	[ -z "${1}" ] && exit 2
	[ -z "${2}" ] && exit 4
	[ -d ${2} ] || exit 33

	[ -z "${3}" ] && exit 44
	[ -d ${3} ] || exit 55

	[ -z "${4}" ] && exit 71
	[ -d ${4} ] || exit 73

	dqb "pars_ok"
	csleep 3

	local ks2
	ks2=""
	local f
	f=""
	local t
	t=""

	local k3
	k3=""

	#HUOM.jos touch-komentoja tarttee käyttää niin mieluummin joka caseen erikseen koska x, stage0f tapa aih sekaannusta sha512-hommien kanssa (?)
	case ${1} in
		isolinux)
			dqb "${spc} -a ${3}/isolinux/ ${4} || exit 8"
			csleep 1

			${spc} -a ${3}/isolinux/ ${4} || exit 8
			ks2=${2}/isolinux
			k3=${4}/isolinux
			csleep 1

			[ ${debug} -eq 1 ] && find ${3}/isolinux -type f -name '*.cfg'
			csleep 5

			dqb "TRYI1NG T0 R3PLACE IS0LINUX.CGF"
		;;
		grub)
			ks2=${2}/boot #jos siirtäisi ennen case;a nää
			
			if [ -d ${ks2} ] ; then
				dqb "${spc} -a ${3}/boot/ ${4} || exit 8"
				csleep 3

				${spc} -a ${3}/boot/ ${4} || exit 8
				csleep 1

				k3=${4}/boot/grub
				[ ${debug} -gt 0 ] && ls -las ${k3}/*.cfg
				csleep 5
			fi
		;;
		*)
			echo "https://www.youtube.com/watch?v=PjotFePip2M"
			exit 11
		;;
	esac
	
	[ -v k3 ] || exit 12
	[ -z "${k3}" ] && exit 13
	
	if [ -d ${k3} ] ; then
		${smr} ${k3}/*.cfg
		${smr} ${k3}/*.png
	fi
	
	csleep 1
				
	for f in $(find ${ks2} -name '*.cfg') ; do
		dqb "spc ${f} ${k3}"
		${spc} ${f} ${k3}
	done
				
	ls -las ${k3}/*.cfg || exit 99

	for f in $(find ${ks2} -name '*.png') ; do
		dqb "spc ${f} ${k3}/"
		${spc} ${f} ${k3}/
	done

	dqb "bootloader(${1}, ${2}) EN0D\n"
}

#161225:sudoilut myöhemmin
#161225.2:voisi kai iteroida forılla arrayn läpi jatkossa
#TODO:nuo alihakemistot, omistajaksi $n:$n jos mahd ni sudon voi skipata, enimmäkseen ?
#TODO:esim. tässä se /.chroot luonti?
function make_tgt_dirs() {
	dqb "s0b.MAKE_t_DIRS( ${1} , ${2}, ${3})"
	csleep 1

	[ -z "${1}" ] && exit 99
	[ x"${1}" != "x/" ] || exit 100
	[ -z "${2}" ] && exit 101
	[ -z "${3}" ] && exit 102
	
	dqb "PARAMZx OK"
	csleep 1

	dqb "CRS"
	[ -d ${2} ] || ${smd} -p ${2}
	${sco} 0:0 ${2}
	${scm} 0755 ${2}
	csleep 1	
	
	dqb "UQS(${CONF_squash_dir})"
	[ -d ${CONF_squash_dir} ] || ${smd} -p ${CONF_squash_dir}
	[ ${debug} -gt 0 ] && ls -las ${CONF_squash_dir}
	csleep 2
	
	dqb "FR0ST"
	
	if [ ! -d ${1} ] ; then
		#dqb "mkdir ${1}";sleep 6
		${smd} -p ${1}
	else
		dqb "rm ${1}"
		sleep 6
		${smr} -rf ${1}/*
	fi

	csleep 1
	dqb "BLADDER"

	if [ "${3}" != "grub" ] ; then
		#tapauksessa grub menee mettään näin
		[ -d ${1}/${3} ] || ${smd} -p ${1}/${3}
	else
		[ -d ${1}/boot/grub ] || ${smd} -p ${1}/boot/grub
	fi

	csleep 1

	dqb "LIVE-EVIL"
	[ -d ${1}/live ] || ${smd} -p ${1}/live
	csleep 1 

	dqb "DGSTS"
	[ -d ${1}/${TARGET_DIGESTS_dir} ] || ${smd} -p ${1}/${TARGET_DIGESTS_dir}
	csleep 1

	dqb "DAP"
	[ -d ${1}/${TARGET_pad_dir} ] || ${smd} -p ${1}/${TARGET_pad_dir}
	csleep 1

	dqb "TUQ"
	[ -d ${1}/../out ] || ${smd} -p ${1}/../out
	csleep 1

	dqb "FN1AL"
	${sco} -R $(whoami):$(whoami) ${1}
	local f
	for f in $(find ${1} -type d ); do ${scm} 0755 ${f} ; done

	csleep 1
	[ ${debug} -gt 0 ] && ls -laR ${1}
	csleep 7
	dqb "...done\n"
}

#pad-hmiston omistajuuden pakotus jossain toisaalla, tässä omistajaksi menisi root
#tämän saman joutaisitehdä useammalle tgt-hmiston alaiselle
#151225:missä tätä käytetään nykyään? part0() @stage0f.sh

#function default_process() {
#	dqb "nt default_process(${1})"
#	[ -z "{1}" ] && exit 65
#	[ -d ${1} ] || exit 66
#	dqb "params_checked"
#	csleep 2
#
#	${sco} -R 0:0 ${1}
#	${scm} 0755 ${1}
#	${scm} 0444 ${1}/*
#
#	dqb "xt default_process ${1}\n"
#	csleep 3
#}
#
