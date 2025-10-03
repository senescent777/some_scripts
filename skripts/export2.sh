#!/bin/bash
#jotain oletuksia kunnes oikea konftdsto saatu lotottua
debug=0 #1
distro=$(cat /etc/devuan_version | cut -d '/' -f 1) #HUOM.28525:cut pois jatkossa?
d0=$(pwd)
echo "d0= ${d0}"
mode=-2
tgtfile=""

#jospa kirjoittaisi uusiksi nuo exp2/imp2/e22-paskat fråm scratch (vakka erillinen branch näitä varten)

function dqb() {
	[ ${debug} -eq 1 ] && echo ${1}
}

function csleep() {
	[ ${debug} -eq 1 ] && sleep ${1}
}

function usage() {
	echo "$0 0 <tgtfile> [distro] [-v]: makes the main package (new way)"
	echo "$0 4 <tgtfile> [distro] [-v]: makes lighter main package (just scripts and config)"
	echo "$0 1 <tgtfile> [distro] [-v]: makes upgrade_pkg"
	echo "$0 e <tgtfile> [distro] [-v]: archives the Essential .deb packages"
	echo "$0 f <tgtfile> [distro] [-v]: archives .deb Files under \$ {d0} /\${distro}" 
	echo "$0 p <> [] [] pulls Profs.sh from somewhere"
	echo "$0 q <> [] [] archives firefox settings"
	echo "$0 c is sq-Chroot-env-related option"
	echo "$0 g adds Gpg for signature checks, maybe?"
	echo "$0 t ... option for ipTables"			
	echo "$0 -h: shows this message about usage"	
}

if [ $# -gt 1 ] ; then
	mode=${1}
	tgtfile=${2}
else
	usage
	exit 1	
fi

#"$0 <mode> <file>  [distro] [-v]" olisi se peruslähtökohta (tai sitten saatanallisuus)
function parse_opts_1() {
	dqb "patse_otps8( ${1}, ${2})"

	case "${1}" in
		-v|--v)
			debug=1
		;;
		*)
			#menisiköhän näin?
			if [ -d ${d}/${1} ] ; then
				distro=${1}
				d=${d0}/${distro}
			fi
		;;
	esac
}

function parse_opts_2() {
	dqb "parseopts_2 ${1} ${2}"
}

#parsetuksen knssa menee jännäksi jos conf pitää ladata ennen common_lib (no parse_opts:iin tiettty muutoksia?)
d=${d0}/${distro}

if [ -s ${d}/conf ] ; then
	. ${d}/conf
else #joutuukohan else-haaran muuttamaan jatkossa?
	echo "CONF MISSING"
	exit 55
fi

if [ -x ${d0}/common_lib.sh ] ; then 
	. ${d0}/common_lib.sh
else
	dqb "FALLBACK"
	dqb "chmod +x ${d0}/common_lib.sh may be a good idea now"
	exit 56 #HUOM.28725:toistaiseksi näin
fi

[ -z ${distro} ] && exit 6
d=${d0}/${distro}

dqb "mode= ${mode}"
dqb "distro=${distro}"
dqb "file=${tgtfile}"
csleep 2

if [ -d ${d} ] && [ -x ${d}/lib.sh ] ; then
	. ${d}/lib.sh
else 
	exit 57
fi

dqb "tar = ${srat} " #HUOM.031025:tämän komennon kanssa saattaa tulla säätöä seuraavaksi

#suorituksen keskeytys aLEmpaa näille main jos ei löydy tai -x ?
for x in /opt/bin/changedns.sh ${d0}/changedns.sh ; do
	${scm} 0555 ${x}
	${sco} root:root ${x}
	${odio} ${x} ${dnsm} ${distro}
	#[ -x $x ] && exit for 
done

dqb "AFTER GANGRENE SETS IN"
csleep 1

#HUOM.28925:"tar löytyy ja ajokelpoinen"-tarkistus tdstossa common_lib.sh, ocs()
tig=$(${odio} which git)
mkt=$(${odio} which mktemp)

if [ x"${tig}" == "x" ] ; then
	#HUOM. kts alempaa mitä git tarvitsee
	echo "sudo apt-get update;sudo apt-get install git"
	exit 7
fi

if [ x"${mkt}" == "x" ] ; then
	#coreutils vaikuttaisi olevan se paketti mikä sisältää mktemp
	echo "sudo apt-get update;sudo apt-get install coreutils"
	exit 8
fi

dqb "${sco} -Rv _apt:root ${pkgdir}/partial"
csleep 1
${sco} -Rv _apt:root ${pkgdir}/partial/
${scm} -Rv 700 ${pkgdir}/partial/
csleep 1

#HUOM. ei kovin oleellista ajella tätä skriptiä squashfs-cgrootin siSÄllä
#mutta olisi hyvä voida testailla sq-chrootin ulkopuolella

dqb "e22_pre0"
csleep 1

if [ -x ${d0}/e22.sh ] ; then
	dqb "222"
	.  ${d0}/e22.sh
	csleep 2
else
	exit 58
fi

##HUOM.25525:tapaus excalibur/ceres teettäisi lisähommia, tuskin menee qten alla
#tcdd=$(cat /etc/devuan_version)
#t2=$(echo ${d} | cut -d '/' -f 6 | tr -d -c a-zA-Z/) #tai suoraan $distro?
#	
#if [ ${tcdd} != ${t2} ] ; then
#	dqb "XXX"
#	csleep 1
#	shary="${sag} install --download-only "
#fi
#TODO:t2-kikkailut jatkossa ennen e22?

##https://askubuntu.com/questions/1206167/download-packages-without-installing liittynee

dqb "mode= ${mode}"
dqb "tar= ${srat}"
csleep 1
e22_pre1 ${d} ${distro}

#tgtfile:n kanssa muitakin tarkistuksia kuin -z ?
[ -x /opt/bin/changedns.sh ] || exit 59
e22_hdr ${tgtfile} #tämö saattaa sitkea tapauksessa c

case ${mode} in
	0|4) #HUOM.021025:toimi ainakin kerran case 0
	#041025 myös teki paketin, toimivuus varmistettava
		[ z"${tgtfile}" == "z" ] && exit 99 
		e22_pre2 ${d} ${distro} ${iface} ${dnsm}

		[ ${debug} -eq 1 ] && ${srat} -tf ${tgtfile} 
		csleep 3

		e22_ext ${tgtfile} ${distro} ${dnsm}
		dqb "e22_ext DON3, next:rm some rchives"
		csleep 3

		[ -f ${d}/e.tar ] && ${NKVD} ${d}/e.tar
		[ -f ${d}/f.tar ] && ${NKVD} ${d}/f.tar

		dqb "srat= ${srat}"
		csleep 5

		#VAIH:se hdr-fktio?
		#dd if=/dev/random bs=12 count=1 > ./rnd
		#${srat} -cvf ${d}/f.tar ./rnd

		e22_hdr ${d}/f.tar
		e22_cleanpkgs ${d}

		#HUOM.31725:jatkossa jos vetelisi paketteja vain jos $d alta ei löydy?
		if [ ${mode} -eq 0 ] ; then
			e22_tblz ${d} ${iface} ${distro} ${dnsm} #VAIH:parametrien kanssa pientä laittoa
			e22_get_pkgs ${d}/f.tar ${d} ${dnsm}
	
			if [ -d ${d} ] ; then
				e22_dblock ${d}/f.tar ${d}
			fi

			e22_cleanpkgs ${d} #kuinka oleellinen?
			[ ${debug} -eq 1 ] && ls -las ${d}
			csleep 5
		fi

		#HUOM.25725:vissiin oli tarkoituksellla f.tar eikä e.tar, tuossa yllä
		${sifd} ${iface}
		#HUOM.22525: pitäisi kai reagoida siihen että e.tar enimmäkseen tyhjä?

		[ ${debug} -eq 1 ] && ls -las ${d}
		csleep 5
 	
		e22_home ${tgtfile} ${d} ${enforce} 
		[ ${debug} -eq 1 ] && ls -las ${tgtfile}
		csleep 4
		${NKVD} ${d}/*.tar #tartteeko piostaa? oli se fktiokin

		e22_pre1 ${d} ${distro}
		dqb "B3F0R3 RP2	"
		csleep 5	
		e22_elocal ${tgtfile} ${iface} ${dnsm} ${enforce}
	;;
	1|u|upgrade) #TODO:testaa toiminta josqs
		#HUOM.29925:miten ne allekirjoitushommat sitten? 
		#aluksi jos case e/t/u hyödyntämään gpg:tä (casen jälkeen onjo juttuja)
		#... ja sitten käsipelillä allekirjoitus-jutskat arkistoon
		#jonka jälkeen imp2 tai pikemminkin p_p_3_clib() tai psqa() tarkistamaan
		[ z"${tgtfile}" == "z" ] && exit 99 

		e22_pre2 ${d} ${distro} ${iface} ${dnsm}
		e22_cleanpkgs ${d}
		e22_upgp ${tgtfile} ${d} ${iface} ${dnsm}
	;;
	p) #HUOM.031025:tekee paketin missä profs.sh
		[ z"${tgtfile}" == "z" ] && exit 99 

		#HUOM.240325:tämä+seur case toimivat, niissä on vain semmoinen juttu(kts. S.Lopakka:Marras)
		e22_pre2 ${d} ${distro} ${iface} ${dnsm}
		e22_settings2 ${tgtfile} ${d0} 
	;;
	e)  #HUOM.041025:ainakin josqs teki paketin missä gpg-aiheiset .deb mukana
		e22_pre2 ${d} ${distro} ${iface} ${dnsm}
		e22_cleanpkgs ${d}
		e22_tblz ${d} ${iface} ${distro} ${dnsm} #VAIH:parametrien kanssa pientä laittoa
			
		e22_get_pkgs ${tgtfile} ${d} ${dnsm}

		if [ -d ${d} ] ; then
			e22_dblock ${d}/f.tar ${d}
		fi
	;;
	f)  #HUOM.041025:toimii
		e22_arch ${tgtfile} ${d}
		#HUOM. ei kai oleellista päästä ajelemaan tätä skriptiä chroootin sisällä, generic ja import2 olennaisempia
	;;
	#HUOM.joitain exp2 optioita ajellessa $d alle ilmestyy ylimääräisiä hakemistoja, miksi?
	q) #HUOM.031025:tekee paketin, siitä eteenpäin vähän auki
		#jos vähän roiskisi casen sisältöä -> e22 ?
		[ z"${tgtfile}" == "z" ] && exit 99
		${sifd} ${iface}
	
		e22_settings ~ ${d0}
		cd ${d0}

		dqb "	OIJHPIOJGHOYRI&RE"
		pwd
		csleep 1

		#HUOM.287tar 25:roiskiko väärään hakemistoon juttuja e22_settings()? toiv ei enää
		e22_settings ~ ${d0}

		dqb "	OIJHPIOJGHOYRI&RE"
		[ ${debug} -eq 1 ] && pwd
		csleep 1

		cd ~

		#HUOM.voisi toisellakin tavalla tehdä, kts update.sh
		for f in $(find . -type f -name config.tar.bz2 -or -name fediverse.tar -or -name pulse.tar) ; do
			${srat} -rvf ${tgtfile} ${f}
		done

		dqb "CASE Q D0N3"
		csleep 3
	;;
	t) #HUOM.031025:testattu että tekee tar:in 
		e22_pre2 ${d} ${distro} ${iface} ${dnsm}
	
		e22_cleanpkgs ${d}
		e22_cleanpkgs ${pkgdir}
			
		message
		csleep 6

		e22_tblz ${d} ${iface} ${distro} ${dnsm}
		
		e22_ts ${d}
		e22_arch ${tgtfile} ${d}
	;;
	c) #uusi optio chroot-juttuja varten,melkein valmis käyttöön
		[ z"${tgtfile}" == "z" ] && exit 99

		#tähän se avainten lisäys vaiko erillinen case?
		cd ${d0}

		#...miten ne avainjutut? vaihtoehtoinen conf?
		#alussa julk av vain tulevat Jostainja that's it, jatkossa squ.ash ja stage0 tekisivät jotain asian suhteen

		#TODO:chroot-ympäristössä tarvitsisi kikkailua conf kanssa?
		# tuossa ymp eri asetukset q live-kiekolla mutta toisaalta eri h mistotkin
		# ... jospa 	copy_conf()

		for f in $(find . -type f -name '*.sh') ; do ${srat} -rvf ${tgtfile} ${f} ; done
		#T_DKNAME voisi jatkossa osoittaa esim /r/l/m/p/dgsts alle?
		[ -v TARGET_Dkname1 ] && ${srat} -rvf ${tgtfile} ${TARGET_Dkname1}
		[ -v TARGET_Dkname2 ] && ${srat} -rvf ${tgtfile} ${TARGET_Dkname2}
		bzip2 ${tgtfile}

		mv ${tgtfile}.bz2 ${tgtfile}.bz3
		tgtfile="${tgtfile}".bz3 #tarkoituksella tämä pääte 

		#... eli imp2 1 hoitanee k3yz purq, jos se riittäisi allek. av. kanssa että gpg --sb pääsee asiaan
	;;
	#HUOM.30925:taitaa jo toimia 
	g)  #gpg-asioihin liittyen testaa että lisää arkistoon?
	
#		#TODO:jatkossa gpg-jutut tdstoon f.tar eli e2_pkgs muutettava?
#		e22_pre2 ${d} ${distro} ${iface} ${dnsm}
#
#		#${NKVD} ${d}/*.deb #olisi myös e22_cleanpkgs
#		e22_cleanpkgs ${d}
#		e22_cleanpkgs ${pkgdir}
#
		#https://pkginfo.devuan.org/cgi-bin/package-query.html?c=package&q=gpg=2.2.40-1.1+deb12u1
		dqb "sudo apt-get update;sudo apt-get reinstall"

		#TODO:kasaa rimpsu jhnkin muuttujaan ni ei tartte renkata
		echo "${shary} gpgconf libassuan0 libbz2-1.0 libc6 libgcrypt20 libgpg-error0 libreadline8 libsqlite3-0 zlib1g gpg"
		echo "${svm} ${pkgdir}/*.deb ${d}"
		echo "$0 f ${tgtfile} ${distro}"
	;;
	-h) #HUOM.24725:tämä ja seur case lienevät ok, ei tartte just nyt testata
		usage
	;;
	*)
		echo "-h"
		exit
	;;
esac

if [ -s ${tgtfile} ] ; then
	e22_ftr ${tgtfile}
fi