#!/bin/bash
. ./setup0.conf
#TODO:skriptin toiminnan testatsuuas uusicksi 666

#040426:edelleen osannee paketteja vetää kohde-tar:ia varten (qhan setup0.conf)
#seuraavaksi common_lib.sh hyödyntäminen?

if [ -s $0.conf ] ; then
	. $0.conf 
else
	exit 66
fi

#251225:saattaisivat seur. komennot olla oleellisia skripts-hmiston alaisille
#... eli nämä pikemminkin sinne sudoersiin ? (TODO?)

odio=$(which sudo)
sag=$(${odio} which apt-get)
shary="${odio} ${sag} --no-install-recommends reinstall --yes "

smd="${odio} mkdir"
sco="${odio} chown"
scm="${odio} chmod"
srat="${odio} tar"
svm="${odio} mv"

[ -v CONF_basedir ] || exit 11
[ -d ${CONF_basedir} ] || ${smd} ${CONF_basedir}
[ -z "${1}" ] && exit

${srat} -cvf ${1} $0*
${srat} -rvf ${1} ./setup* 

function jord() {
	echo "j0.rd"
	[ -v CONF_pkgsrc ] || exit 22
	
	for d in ${CONF_yarr} ; do 
		if [ ! -z "${d}" ] ; then #tarpeellinen?
			if [ ! -d ${d} ] ; then
				${smd} -p ${d}
				${sco} 0:0 ${d}
				${scm} 0755 ${d}
			fi
		fi
	done
}

jord #${1}

#1912255:jnkn verran jo testailtu, kuten myös 020426, toimii
function aqua() {
	echo "aqua ( ${1})"
	[ -z "{1}" ] && exit 11
	[ -d ${1} ] || exit 12
	echo "ok"
	sleep 1
	
	if [ ! -s ${CONF_basedir}/sources.list ] ; then
		${odio} nano /etc/apt/sources.list #tai cp
		echo "copy /etc/apt/sources.list ${CONF_basedir}/etc/apt ?"
		sleep 1
	else
		if [ ! -s /etc/apt/sources.list.old ] ; then
			${svm} /etc/apt/sources.list /etc/apt/sources.list.old
			${odio} cp ${CONF_basedir}/sources.list /etc/apt/
		fi
	fi

	${odio} apt-get update
	${odio} apt --fix-broken install

	#common_lib.sh
	E22_GT="isc-dhcp-client isc-dhcp-common libip4tc2 libip6tc2 libxtables12 netbase libmnl0 libnetfilter-conntrack3 libnfnetlink0 libnftnl11 libnftables1 libedit2"
	E22_GT="${E22_GT} iptables"
	E22_GT="${E22_GT} init-system-helpers"
	${shary} ${E22_GT}
	#

	#
	E22GI="libassuan0 libbz2-1.0 libc6 libgcrypt20 libgpg-error0 libreadline8 libsqlite3-0 gpgconf zlib1g gpg"
	${shary} ${E22GI}
	#

	${shary} libc6 coreutils
	${shary} libcurl3-gnutls libexpat1 liberror-perl libpcre2-8-0 zlib1g 
	${shary} git-man git

	#https://pkginfo.devuan.org/cgi-bin/policy-query.html?c=package&q=squashfs-tools&x=submit
	${shary} liblz4-1 liblzma5 liblzo2-2 libzstd1
	${shary} squashfs-tools

	#https://pkginfo.devuan.org/cgi-bin/package-query.html?c=package&q=genisoimage=9:1.1.11-3.4
	sudo apt-get reinstall libbz2-1.0 libmagic1

	#https://pkginfo.devuan.org/cgi-bin/package-query.html?c=package&q=wodim=9:1.1.11-3.4
	sudo apt-get --no-install-recommends libcap2
	${shary} genisoimage wodim 
	${shary} dmsetup libdevmapper1
	${shary} libjte2

	#https://pkginfo.devuan.org/cgi-bin/package-query.html?c=package&q=grub-common=2.06-13+deb12u1
	sudo apt-get reinstall libdevmapper1.02.1 libefiboot1 libefivar1 libfreetype6 libfuse3-3 gettext-base

	#https://pkginfo.devuan.org/cgi-bin/package-query.html?c=package&q=xorriso=1.5.4-4
	${shary} libisoburn1 libburn4 libisofs6 
	${shary} libfuse2
	${shary} mtools
	${shary} grub-common xorriso #jälkimminen toistaiseksi mukana
	${shary} geany
	
	sudo cp /var/cache/apt/archives/*.deb ${1} #kuinka tarpeellinen? kts conf EIKU
}

[ -v CONF_pkgsrc ] || exit 33
${odio} apt-get update
[ $? -eq 0 ] && aqua ${CONF_pkgsrc}

#riittäisikö /etc kuitenkin?

for f in $(find /etc -type f -name 'sources.list*') ; do ${srat} -rvf ${1} ${f} ; done 
${srat} -rvf ${1} ${CONF_pkgsrc}/*.deb
#jatkossa yo. rivi pois jos siirretään paketit basedir alle?

function ignis() {
	echo "igtnis ( ${1})"
	[ -z "{1}" ] && exit 11
	[ -d ${1} ] || exit 12
	echo "ok"
	sleep 1
	
	if [ -s ${1}/.gitignore ] ; then
		echo "not touching  ${1}/.gitignore this time"
	else
		if [ -s ${1}/gitignore.example ] ; then
			cp ${1}/gitignore.example ${1}/.gitignore 
		else
			#fasdfasd
			${odio} touch ${1}/.gitignore
			${sco} $(whoami):$(whoami) ${1}/.gitignore
			${scm} 0644 ${1}/.gitignore
	
			#211225:kuinka olennaista tuo conf on laittaa ignoreen?
			c=$(grep $0.conf ${1}/.gitignore | wc -l)
			[ ${c} -lt 1 ] && echo $0.conf >> ${1}/.gitignore
			c=$(grep .deb ${1}/.gitignore | wc -l)
		
			if [ ${c} -lt 1 ] ; then
				echo "*.deb" >> ${1}/.gitignore
				echo "*.OLD" >> ${1}/.gitignore
				echo "*.bz3" >> ${1}/.gitignore
				echo "*.bz2" >> ${1}/.gitignore
				echo "*.sha" >> ${1}/.gitignore
				echo "*.sig" >> ${1}/.gitignore
			fi
		fi
	fi
}

ignis ${CONF_basedir}

function f5th() {
	#TODO?:fstab.tmp kanssa se sed-kikkailu vähitellen? millainen kikkailu?
	echo "TODO?: SHOUDL POPULTAE ${CONF_basedir}/etc AROUND HERE, SPECIALLY fstab.tmp"
	sleep 1
}

f5th
${srat} -rvf ${1} ${CONF_basedir}
