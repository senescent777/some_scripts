#!/bin/bash

if [ -s $0.conf ] ; then
	. $0.conf 
fi

if [ ! -s ${basedir}/sources.list ] ; then
	sudo nano /etc/apt/sources.list #tai cp
else
	if [ ! -s /etc/apt/sources.list.old ] ; then
		sudo mv /etc/apt/sources.list /etc/apt/sources.list.old
		sudo cp ${basedir}/sources.list /etc/apt/
	fi
fi

#TEHTY:conf.example tätä ja init2 varteb
#VAIH:min imize-juttuen johdosta pitäisi selvittää riippuvuudet ao. paketteihin ja vetää nekin (testaa vielä)
#130725 ei ihan ekalla yrityksellä vielä onnannut, pientä ulinaa

sudo apt-get update
sudo apt --fix-broken install

sudo apt-get reinstall --no-install-recommends libc6 coreutils
sudo apt-get reinstall --no-install-recommends libcurl3-gnutls libexpat1 liberror-perl libpcre2-8-0 zlib1g 
sudo apt-get reinstall --no-install-recommends git-man git

#https://pkginfo.devuan.org/cgi-bin/policy-query.html?c=package&q=squashfs-tools&x=submit
sudo apt-get reinstall --no-install-recommends liblz4-1 liblzma5 liblzo2-2 libzstd1
sudo apt-get reinstall --no-install-recommends squashfs-tools

##HUOM.13725:kuinkahan tarpeellisia gpg-jutut näin alkuvaiheessa? myös konflkitit
##https://pkginfo.devuan.org/cgi-bin/package-query.html?c=package&q=gpg=2.2.40-1.1
#https://pkginfo.devuan.org/cgi-bin/package-query.html?c=package&q=gpgv=2.2.40-1.1
#sudo apt-get reinstall --no-install-recommends gpgconf libassuan0 libbz2-1.0 libgcrypt20 libgpg-error0 libreadline8 libsqlite3-0 
#sudo apt-get reinstall --no-install-recommends gpg gpgv #vaiko gpg*

#https://pkginfo.devuan.org/cgi-bin/package-query.html?c=package&q=genisoimage=9:1.1.11-3.4
sudo apt-get reinstall libbz2-1.0 libmagic1
#https://pkginfo.devuan.org/cgi-bin/package-query.html?c=package&q=wodim=9:1.1.11-3.4
sudo apt-get --no-install-recommends libcap2

sudo apt-get reinstall --no-install-recommends genisoimage wodim 

#dpkg: dependency problems prevent configuration of libdevmapper1.02.1:amd64:
# libdevmapper1.02.1:amd64 depends on dmsetup (>= 2:1.02.185-2~); however:
#  Package dmsetup is not installed.
sudo apt-get reinstall --no-install-recommends dmsetup

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

if [ ! -d ${1} ] ; then
	sudo tar -cvf ${1} /var/cache/apt/archives/*.deb
else
	sudo cp /var/cache/apt/archives/*.deb ${1}
fi

chmod a+x ./*.sh

[ -s ${basedir}/.gitignore ] || touch ${basedir}/.gitignore
c=$(grep $0.conf ${basedir}/.gitignore | wc -l)
[ ${c} -lt 1 ] && echo $0.conf >> ${basedir}/.gitignore

#konftsdton mukaisia hmistoja tulisi luoda jos ei jo olemassa?
#... ota selvää mitä taas tarvittiin oikeasti?

