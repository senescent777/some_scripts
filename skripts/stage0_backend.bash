function mangle_conf() {
	dqb "mangle_conf ${1}, ${2}, ${3} "
	#TODO?:jotain muutakin tähän, ehkä (lähteen greppailu kohteeseen)
	#tdstoista common.conf ja keys.conf pitäisi saada TARGET_D ja CONF_k - alkuiset
}

#dgsts.5 liittyen kts copy_sums() , kommentit

function copy_main() {
	dqb "copy_main(${1}, ${2}, ${3} )"

	[ -z "${1}" ] && exit 2
	#[ -d ${2} ] || exit 22 #mitä jos ei kohde-hmistoa ole olemassa ennen kopiointia?

	[ -z "${3}" ] && exit 33
	[ -d ${3} ] || exit 34

	dqb "CHECKS PASSED"
	local f
	csleep 1

	dqb "PIZZAA"	
	csleep 1

	#eri lähde find-komennoilla ni jospa ei jaksaisi hýhgdistää ekaa findia
	for f in $(find ${3} -type f -name "*.sh") ; do	
		dqb "${spc} ${f} ${2}/../.. "
		${spc} ${f} ${2}/../.. 
	done

	dqb "PASHAA"
	csleep 1
	#191225:tuleeko ongelma siitä että linkkejä ei seurata?

	for f in $(find ${1} -type f  -name "*.sh" -or -name "*.bz2") ; do
		dqb "${spc} ${f} ${2} "
		${spc} ${f} ${2}
	done
	
	dqb "KERMAA"
	csleep 1

	#030526:lototaan aluksi tähän, ehkä vaihtuu toiseen fktioon kys pätkä
	for f in $(find ${1} -type f  -name "*.sig") ; do
		dqb "${spc} ${f} ${2} "
		${spc} ${f} ${2}
	done

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

	#-v vielä ?

	if [ ! -z "${CONF_scripts_dir}" ] ; then
		for f in $(find ${CONF_scripts_dir} -type f -name "*.conf" | grep -v bash) ; do
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

	#pystyisi kai toisinkin tekemään?
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
	
	#TODO?:jos vielä vähän karsisi tuota findin listausta? , kts kutl.bash (pointti oli?)
	#... ja siihen liittyen myös cp-komennon suhteen muutos?
	local x=0
	local t
	
	if [ -d ${1} ] ; then
		x=$(find ${1} -type f -name "*.gpg" | wc -l)
		
		#toisinkin voisi tehdä?
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

#ne oletus-bootloader-jutut esim. tähän flktioon jatkosssa
function pre_bl() {
	dqb "WORK N PROGRESS"
	}

#TODO:voisi olla jotain default-bootloader-konftdstoja jos ei v/$something alla ole (pre:b olisi tarkoitus liittyä asiaan)

#sen hybrid.bin-tdston kanssa jotain? antaa oll atoisdtaiseksi?
function bootloader() {
	dqb "bootloader(${1}, ${2}, ${3}, ${4} ((("

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
	case "${1}" in
		isolinux)
			dqb "pre-cp"
			csleep 1

			#250426:josko tällä lähtisi toimimaan?
			#${smd} -p ${4}/boot/grub
			#${spc} ${3}/boot/grub/efiboot.img ${4}/boot/grub 
			
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
			ks2=${2}/boot #jos siirtäisi ennen case;a nää?
			
			if [ -d ${ks2} ] ; then
				dqb "${spc} -a ${3}/boot/ ${4} || exit 8"
				csleep 3

				#TODO:koita keksiä jotain ettei tähän tökkää
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
				
	for f in $(find ${ks2} -name "*.cfg" -or -name "*.bin") ; do
		dqb "spc ${f} ${k3}"
		${spc} ${f} ${k3}
	done
				
	ls -las ${k3}/*.cfg || exit 99

	for f in $(find ${ks2} -name "*.png") ; do
		dqb "spc ${f} ${k3}/"
		${spc} ${f} ${k3}/
	done

	dqb "bootloader(${1}, ${2}) EN0D\n"
}

#161225.2:voisi kai iteroida forılla arrayn läpi jatkossa (MINKÄ ARRAYN?)

