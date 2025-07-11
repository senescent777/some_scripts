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

sudo apt-get update

sudo apt-get reinstall git squashfs-tools gpg gpgv #vaiko gpg*
sudo apt-get reinstall genisoimage wodim 

#https://pkginfo.devuan.org/cgi-bin/package-query.html?c=package&q=grub-common=2.06-13+deb12u1
sudo apt-get reinstall grub-common xorriso #jälkimminen toistaiseksi mukana

if [ ! -d ${1} ] ; then
	sudo tar -cvf ${1} /var/cache/apt/archives/*.deb
else
	sudo cp  /var/cache/apt/archives/*.deb ${1}
fi

chmod a+x ./*.sh

[ -s ${basedir}/.gitignore ] || touch ${basedir}/.gitignore
c=$(grep $0.conf ${basedir}/.gitignore | wc -l)
[ ${c} -lt 1 ] && echo $0.conf >> ${basedir}/.gitignore

#TODO:konftsdton mukaisia hmistoja tulisi luoda jos ei jo olemassa?

