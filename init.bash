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

smd="sudo mkdir"
[ -v CONF_basedir ] || exit 11
[ -d ${CONF_basedir} ] || ${smd} ${CONF_basedir}
#cd basedir ni noista ao. jutuista voisi sen alkuosan poistaa?

sudo tar -cvf ${1} $0*
sudo tar -rvf ${1} ./init2* #jtnkn fiksummin tämä
#TODO:joutaisi miettiä, tilapäisille tdstoille tarkoitettua osiota ei kannattane käyttää pitkäaikaiseen säilytykseen niinqu
function jord() {
	[ -v CONF_pkgsrc} ] || exit 22

	local yarr
	yarr="${CONF_pkgsrc} ${CONF_keys_dir} ${CONF_distros_dir} ${CONF_basedir}/boot/grub ${CONF_basedir}/isolinux ${CONF_pkgsdir2} ${CONF_basedir}/v ${CONF_basept2tgt}"
	yarr="${yarr} ${CONF_basedir}/etc/iptables ${CONF_basedir}/etc/network/interfaces  ${CONF_basedir}/etc/apt"

	#221225:jos jokin array tätä varten
	for d in ${yarr} ; do 
		if [ ! -z "${d}" ] ; then #tarpeellinen?
			if [ ! -d ${d} ] ; then
				${smd} -p ${d}

				echo "sco ?:? ${d} (TODO)"
				echo "scm \$mode ${d} (TODO)"	
			fi
		
			#sudo tar -rvf ${1} ${d}	#tarpeen jatkossa? jos kerran menee CONF_basedir alle kaikki hmistot
		fi
	done
}

jord ${1}

#1912255:jnkn verran jo testailtu
function aqua() {
	if [ ! -s ${CONF_basedir}/sources.list ] ; then
		sudo nano /etc/apt/sources.list #tai cp
	else
		if [ ! -s /etc/apt/sources.list.old ] ; then
			sudo mv /etc/apt/sources.list /etc/apt/sources.list.old
			sudo cp ${CONF_basedir}/sources.list /etc/apt/
		fi
	fi

	sudo apt-get update
	sudo apt --fix-broken install

	#TODO:gpg ja iptables mukaan?

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
	
	sudo cp /var/cache/apt/archives/*.deb ${1}
}

[ -v CONF_pkgsrc} ] || exit 33
sudo apt-get update
[ $? -eq 0 ] && aqua ${CONF_pkgsrc}
#VAIH:ajetaan aqua vain jos verkkoyhteys saatavilla

for f in $(find / -type f -name 'sources.list*') ; do sudo tar -rvf ${1} ${f} ; done 
sudo tar -rvf ${1} ${CONF_pkgsrc}/*.deb #jatkossa tämä rivi pois jos siirretään paketit basedir alle?

#VAIH:e/sudoers.d alle uuis tiedosto? stage0 -d varten siis , kts init2.bash loppuosa

function ignis() {
	[ -s ${CONF_basedir}/.gitignore ] || sudo touch ${CONF_basedir}/.gitignore
	sudo chown $(whoami):$(whoami) ${CONF_basedir}/.gitignore
	sudo chmod 0644 ${CONF_basedir}/.gitignore

	#TODO:jos .gitignore.example tähänkin

	c=$(grep $0.conf ${CONF_basedir}/.gitignore | wc -l)
	[ ${c} -lt 1 ] && echo $0.conf >> ${CONF_basedir}/.gitignore
	sleep 1
}

ignis

function f5th() {
	echo "TODO: SHOUDL POPULTAE ${CONF_basedir}/etc AROUND HERE"
	sleep 1
}

f5th

sudo tar -rvf ${1} ${CONF_basedir}
