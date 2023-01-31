#!/bin/sh
. ./backend.sh

[ $to_ram -eq 1 ] && eject
cd $src
pwd

case $1 in
	upload)
		cd $tmpdir
		[ -d $tmpdir/pad/0 ] || sudo mkdir -p $tmpdir/pad/0

		up1
		up2
		up3 
		up4
		up56
	;;
     	d)

		sudo shred -fu /tmp/var/*
	        sudo rm -rf /tmp/var

		sudo shred -fu $tmpdir/pad/*
		sudo rm -rf $tmpdir/pad
		
		sudo shred -fu $pkgdir/*
		sudo rm -rf $pkgdir	
		sudo rm -rf /var/cache/apt/archives/*.deb

		for f in TARGET_patch_list_1 ; do sudo mv $src/$f $src/$f.bak ; done
		sudo shred -fu $src/*.bz2 
		sudo shred -fu $src/*.bz3
		for f in TARGET_patch_list_1 ; do sudo mv $src/$f.bak $src/$f ; done
	
                if [ ! -s ./pellinpasqa.sh ] ; then
                        cd /
			$srat $src/extras.tar.bz2
			sudo chmod a+x *.sh
               fi

                cd $src
                ./pellinpasqa.sh

		sudo rm -rf /home/Downloads
		sudo rm -rf /home/$n/package_list
        ;;
	c|C) 
		cleanup1
		cleanup1_2 $n
	;;
	c1)
		cleanup1
	;;
	goatpenis|goatsemen)
		if [ ! -x $src/profs.sh ] ; then
			cd /;efk $src/profs.tar.bz2
		fi

		sudo chmod 0555 $src/profs.sh
		sudo chown 0:0  $src/profs.sh
		cd $src
		. ./profs.sh
		cd /;efk $src/$1.tar.bz2

		if [ $nosu_do -eq 1 ] ; then
			copyprof esr devuan
		else
			copyprof esr $n
		fi
	;;
	*)
		kala=""
		cd $src

		if [ -s ./$1.tar.bz3 ] ; then 
			kala=$1.tar.bz3
		else
			kala=$1.tar.bz2
		fi

		[ -s $kala ] || exit 666
		grep $1 $src/0/sha512sums.2

		if [ -x ./$1.sh ] ; then
			. ./$1.sh 
			stage0 $2
		fi

		cd /;efk $src/$kala
		cd $src

		if [ -x ./$1.sh ] ; then 
			stage2 $2
			stage3 $2
		fi
	;;
esac

ilemak $n
