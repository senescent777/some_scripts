#!/bin/bash
if [ -s $0.conf ] ; then
	. $0.conf 
else
	exit 66
fi

##kuinkahan tarpeellinen blokki?
#fq=$(find / -type f -name common.conf)
#if [ -s ${fq} ] ; then
#	echo ": . ${fq} ?"
#fi
##

#251225:saattaisivat seur. komennot olla oleellisia skripts-hmiston alaisille
#... eli nämä pikemminkin sinne sudoersiin ?(TODO)
smd="sudo mkdir"
sco="sudo chown"
scm="sudo chmod"
#näitä määrittelyjä vosi käyttää wenemmänkin tuossa alla (TODO)

[ -v CONF_basedir ] || exit 11
[ -d ${CONF_basedir} ] || ${smd} ${CONF_basedir}
#cd ${CONF_basedir } #ni noista ao. jutuista voisi sen alkuosan poistaa?

sudo tar -cvf ${1} $0*
sudo tar -rvf ${1} ./init2* #jtnkn fiksummin tämä
#TODO:joutaisi miettiä, tilapäisille tdstoille tarkoitettua osiota ei kannattane käyttää pitkäaikaiseen säilytykseen niinqu

function jord() {
	[ -v CONF_pkgsrc} ] || exit 22
	#local yarr

	for d in ${CONF_yarr} ; do 
		if [ ! -z "${d}" ] ; then #tarpeellinen?
			if [ ! -d ${d} ] ; then
				${smd} -p ${d}
				${sco} 0:0 ${d}
				${scm} 0755 ${d}
			fi
		
			#sudo tar -rvf ${1} ${d}	#tarpeen jatkossa? jos kerran menee CONF_basedir alle kaikki hmistot
		fi
	done
}

jord ${1}

#1912255:jnkn verran jo testailtu
function aqua() {
	echo "aqua ( ${1})"
	[ -z "{1}" ] && exit 11
	[ -d ${1} ] || exit 12
	echo "ok"
	sleep 1
	
	if [ ! -s ${CONF_basedir}/sources.list ] ; then
		sudo nano /etc/apt/sources.list #tai cp
		echo "copy /etc/apt/sources-loist ${CONF_basedir}/etc/apt ?"
		sleep 1
	else
		if [ ! -s /etc/apt/sources.list.old ] ; then
			sudo mv /etc/apt/sources.list /etc/apt/sources.list.old
			sudo cp ${CONF_basedir}/sources.list /etc/apt/
		fi
	fi

	sudo apt-get update
	sudo apt --fix-broken install

	#gpg ja iptables mukaan?

	sudo apt-get reinstall --no-install-recommends libc6 coreutils
	sudo apt-get reinstall --no-install-recommends libcurl3-gnutls libexpat1 liberror-perl libpcre2-8-0 zlib1g 
	sudo apt-get reinstall --no-install-recommends git-man git

	#https://pkginfo.devuan.org/cgi-bin/policy-query.html?c=package&q=squashfs-tools&x=submit
	sudo apt-get reinstall --no-install-recommends liblz4-1 liblzma5 liblzo2-2 libzstd1
	sudo apt-get reinstall --no-install-recommends squashfs-tools

	#gpg-jutut taitavat jo löytyä 151225
	#https://pkginfo.devuan.org/cgi-bin/package-query.html?c=package&q=genisoimage=9:1.1.11-3.4
	sudo apt-get reinstall libbz2-1.0 libmagic1

	#https://pkginfo.devuan.org/cgi-bin/package-query.html?c=package&q=wodim=9:1.1.11-3.4
	sudo apt-get --no-install-recommends libcap2
	sudo apt-get reinstall --no-install-recommends genisoimage wodim 

	#dpkg: dependency problems prevent configuration of libdevmapper1.02.1:amd64:
	# libdevmapper1.02.1:amd64 depends on dmsetup (>= 2:1.02.185-2~); however:
	#  Package dmsetup is not installed.
	sudo apt-get reinstall --no-install-recommends dmsetup libdevmapper1

	#dpkg: dependency problems prevent configuration of libisoburn1:amd64:
	# libisoburn1:amd64 depends on libjte2; however:
	#  Package libjte2 is not installed.
	sudo apt-get reinstall --no-install-recommends libjte2

	#https://pkginfo.devuan.org/cgi-bin/package-query.html?c=package&q=grub-common=2.06-13+deb12u1
	sudo apt-get reinstall libdevmapper1.02.1 libefiboot1 libefivar1 libfreetype6 libfuse3-3 gettext-base

	#https://pkginfo.devuan.org/cgi-bin/package-query.html?c=package&q=xorriso=1.5.4-4
	sudo apt-get reinstall --no-install-recommends libisoburn1 libburn4 libisofs6 

	# grub-common depends on libfuse2 (>= 2.8.4-1.4); however:
	#  Package libfuse2 is not installed.
	sudo apt-get reinstall --no-install-recommends libfuse2

	#https://pkginfo.devuan.org/cgi-bin/policy-query.html?c=package&q=mtools&x=submit
	#libc saattaa riittää
	sudo apt-get reinstall --no-install-recommends mtools

	sudo apt-get reinstall --no-install-recommends grub-common xorriso #jälkimminen toistaiseksi mukana
	sudo apt-get reinstall --no-install-recommends geany
	
	sudo cp /var/cache/apt/archives/*.deb ${1} #tai mv
}

[ -v CONF_pkgsrc} ] || exit 33
sudo apt-get update
[ $? -eq 0 ] && aqua ${CONF_pkgsrc}

#riittäisikö /etc kuitenkin?
for f in $(find / -type f -name 'sources.list*') ; do sudo tar -rvf ${1} ${f} ; done 
sudo tar -rvf ${1} ${CONF_pkgsrc}/*.deb #jatkossa tämä rivi pois jos siirretään paketit basedir alle?

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
			sudo touch ${1}/.gitignore
			sudo chown $(whoami):$(whoami) ${1}/.gitignore
			sudo chmod 0644 ${1}/.gitignore
	
			#211225;kuinka olennaista tuo conf on laittaa ignoreen?
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
	#TODO:fstab.tmp kanssa se sed-kikkailu vähitellen?
	echo "TODO: SHOUDL POPULTAE ${CONF_basedir}/etc AROUND HERE, SPECIALLY fstab.tmp"
	sleep 1
}

f5th
sudo tar -rvf ${1} ${CONF_basedir}
