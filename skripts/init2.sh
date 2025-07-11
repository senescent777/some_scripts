#!/bin/bash
#d=$(dirname $0) #tarvitseeko?

if [ -s $0.conf ] ; then
	. $0.conf 
fi

#common_lib.part3()
echo "sudo dpkg -i ${pkgsrc}/*.deb"

#git olemassaolo pitäisi testata ennernq etenee pidemmälle
[ -v ue ] && echo "git config --global user.email ${ue}"
[ -v un ] && echo "git config --global user.name ${un}"

if [ -s $0.conf ] ; then
	if [ ! -s ${basedir}/.gitignore ] ; then
		echo "echo $0.conf >> ${basedir}/.gitignore "
	fi
fi
