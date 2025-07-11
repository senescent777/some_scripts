#!/bin/bash
if [ -s $0.conf ] ; then
	. $0.conf
else
	exit 666
fi

#common_lib.part3() ... joutuu ehkä jo järjestyksen kanssa säätämään
sudo dpkg -i ${pkgsrc}/*.deb

#git olemassaolo pitäisi testata ennernq etenee pidemmälle
[ -v ue ] && git config --global user.email ${ue}
[ -v un ] && git config --global user.name ${un}

#VAIH:grepin kanssa jatkossa testaus
#if [ -s $0.conf ] ; then
#	if [ ! -s ${basedir}/.gitignore ] ; then
#		echo $0.conf >> ${basedir}/.gitignore
#	fi
#fi
[ -s ${basedir}/.gitignore ] || touch ${basedir}/.gitignore
c=$(grep $0.conf ${basedir}/.gitignore | wc -l)
[ ${c} -lt 1 ] && echo $0.conf >> ${basedir}/.gitignore