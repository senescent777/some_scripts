#!/bin/bash
d=$(dirname $0)
. ${d}/common.conf
. ${d}/common_funcs.sh
#protect_system

debug=1 #nollaus myöh
dir2=""
cmd=""
md=0
mp=0
ms=0

function parse_opts_real() {
	echo "squash.parse_opts_real()"

	case ${1} in
		--dir2)
			dir2=${2}
			[ -d ${2} ] || exit 666
		;;
		-x|-y|-i|-j)
			if [ -s ${2} ] || [ -d ${2} ] ; then
				par=${2}
			fi
		;;
		-c)
			par=${2}
		;;
		-mp|--mp)
			mp=${2}
		;;
		-md|--md)
			md=${2}
		;;
		-ms|--ms)
			ms=${2}
		;;
	esac
}

function single_param() {
	cmd=${1}
	echo "sp"
}

parse_opts ${1} ${2}
parse_opts ${3} ${4}
parse_opts ${5} ${6}
parse_opts ${7} ${8}
parse_opts ${9} ${10}

function xxx() {
	if [ x"${CONF_squash0}" != "x" ]; then
		[ -d ${CONF_squash0} ] || ${smd}${CONF_squash0}
		cd ${CONF_squash0}
		unsq=$(${odio} which unsquashfs)

		if [ x"${unsq}" != "x" ] ; then 
			${odio} ${unsq} ${1}
		else
			echo "${odio} apt-get install squashfs-utils"
		fi

	fi
}

function fix_sudo() {
	if [ x"${CONF_squash_dir}" != "x" ]; then
		cd ${CONF_squash_dir}

		${sco} -R 0:0 ./etc/sudo*
		${scm} -R a-w ./etc/sudo*
		${sco} -R 0:0 ./usr/lib/sudo/*

		#${sco} -R 0:0 ./usr/bin/sudo*
		#RUNNING SOME OF THESE COMMANDS OUTSIDE CHROOT ENV STARTED TO SEEM LIKE A BAD IDEA
		#AND CHATTR MAY OT WORK WITH SOME FILESYSTEMS	

		${scm} 0750 ./etc/sudoers.d
		${scm} 0440 /etc/sudoers.d/*

		${scm} -R a-w ./usr/lib/sudo/*
		#${scm} -R a-w ./usr/bin/sudo*
		#${scm} 4555 ./usr/bin/sudo
		${scm} 0444 ./usr/lib/sudo/sudoers.so

		#${sca} +ui ./usr/bin/sudo
		#${sca} +ui ./usr/lib/sudo/sudoers.so	
	fi
}

function bbb() {

	if [ x"${CONF_squash_dir}" != "x" ]; then

		if [ -d ${CONF_squash_dir} ] ; then 
			cd ${CONF_squash_dir}

			${smr} -rf ./run/live
			${smr} -rf ./boot/grub/*
			${smr} -rf ./boot/*
			${smr} -rf ./usr/share/doc/*	
			${smr} -rf ./var/cache/apt/archives/*.deb
			${smr} -rf ./var/cache/apt/*.bin
			${smr} -rf ./tmp/*

			fix_sudo

			${scm} -R 0755 ./var/cache/man
			${sco} -R man:man ./var/cache/man

			${smr} ./root/.bash_history
			${smr} ./home/devuan/.bash_history
			
		fi
	fi

}

function jlk_main() {

	if [ x"${CONF_squash_dir}" != "x" ]; then
		echo "${0} -x ?"
		[ -d ${CONF_squash_dir}/${TARGET_pad2} ] || ${smd}-p ${CONF_squash_dir}/${TARGET_pad2}

		cd ${CONF_squash_dir}/${TARGET_pad2}
		[ x"${1}" != "x" ] || exit 666


		local d
		for d in sh bz2 bz3 ; do ${spc} ${1}/${TARGET_pad_dir}/*.${d} . ; done



	
	fi
}

function jlk_conf() {

	if [ x"${CONF_squash_dir}" != "x" ] && [ y"${1}" != "y" ] ; then
		if [ -d ${1}/${TARGET_pad_dir} ] ; then 

			if [ ! -s ${1}/${TARGET_pad_dir}/${2}.conf ] ; then
				echo "ERROR:NO CONFIG FILE TO COPY!!!" 
				exit 666
			fi

			cd ${CONF_squash_dir}/${TARGET_pad2}

			${smr} ./mf*;${smr} ./root.conf
			${smr} ./${2}.conf



			grep -v TARGET_to_ram ${1}/${TARGET_pad_dir}/${2}.conf > ./root.conf 

	        	echo "TARGET_to_ram=1" >> ./root.conf


		#else
		fi
	fi

}

function jlk_sums() {

	[ x"${1}" != "x" ] || exit 666
	[ -d ${1} ] || echo "no such thing as ${1}"

	cd ${CONF_squash_dir}/${TARGET_pad2}

	[ -d ./0 ] || ${smd}-p ./0 ;sleep 6


	${spc} -a ${1}/${TARGET_DIGESTS_dir}/* ./0

		ls -las ./0;sleep 5
		cd ..
		${sh5} -c ${TARGET_DIGESTS_file}.2 --ignore-missing

}

function rst() {

	if [ x"${CONF_squash_dir}" != "x" ]; then
		cd ${CONF_squash_dir}

		if [ ${md} -gt 0 ] ; then
			${som} -o bind /dev ./dev 
		fi

		if [ ${ms} -gt 0 ] ; then
			${som} -o bind /sys ./sys
		fi

		if [ ${mp} -gt 0 ] ; then
			${som} -o bind /proc ./proc 
			${odio} ln -s ./proc/mounts ./etc/mtab
		fi		 

		${svm} ${CONF_squash_dir}/etc/hosts ${CONF_squash_dir}/etc/hosts.bak	
		${spc} /etc/hosts ${CONF_squash_dir}/etc
		
		${odio} chroot ./ ./bin/bash 
				
		${svm} ./etc/hosts.bak ./etc/hosts
		${smr} ./etc/mtab
		[ $? -eq 0 ] || echo "MOUNT -O REMOUNT,EXEC ${CONF_tmpdir0}"
		sleep 3
	
		${uom} ./dev 
		${uom} ./sys
		${uom} ./proc

		sleep 3
	fi

}

function cfd() {
	if [ x"${CONF_squash_dir}" != "x" ]; then
		echo "${0} -b ?"

		cd ${CONF_squash_dir}

		[ -s ${1} ] && rm ${1}
		msq=$(${odio} which mksquashfs)

		if [ x"${msq}" != "x" ] && [ -x ${msq} ] ; then 
			${odio} ${msq} . ${1} -comp xz -b 1048576
		else
			echo "${odio} apt-get install squashfs-utils"
		fi
	fi
}

function usage() {
	echo "-x <source_file>:eXtracts <source_file> to ${CONF_squash0}"
	echo "-y <iso_file> extracts <iso_file>/live/filesystem.squashfs to ${CONF_squash0}"
	echo "-b is supposed to be run just Before -c but after -r"
	echo "-d Destroys contents of ${CONF_squash0}/ and ${CONF_tmpdir} "
	echo "\t if possible, use -b instead\n"

	echo "-c <target_file> [optional_params_4_mksquashfs?] : Compresses ${CONF_squash_dir} to <target_file> (with optional_params?)\n"
	echo "-r :runs chRoot in ${CONF_squash_dir}"
	
	echo "-i <src> : Installs scripts 2 chroot_dir "
	echo "-j <src> [ --dir2 <stuff> ] : extracts dir 2 chroot_dir"
	echo "\t to state the obvious:"
	echo "\t <stuff> in --dir2 has to contain sub-directory ${TARGET_DIGESTS_dir} , for example ${CONF_target} "
	echo "\t ... and <src> has to contain subdirectory ${TARGET_pad_dir} \n"

	echo "-f attempts to Fix some problems w/ sudo"
	echo "--v 1 adds Verbosity\n"

	echo "--mp,--md, --ms:self-explanatory opts 4 -r" 
	echo "\t potentially dangerous, so disabled by default , 1 enables"
}

function ijk() {
	if [ x"${CONF_squash_dir}" != "x" ]; then
		echo "${0} -x ?"
		
		previous=$(pwd)
		${smd}-p ${CONF_squash_dir}/${TARGET_pad2}
		cd ${CONF_squash_dir}/${TARGET_pad2}
	
		[ x"${1}" != "x" ] || exit 666
		[ -d ${1} ] || exit 666

		local d
		for d in ${TARGET_patch_list_2} ; do ${spc} ${1}/${TARGET_pad_dir}/${d} . ; done

		grep -v TARGET_to_ram devuan.conf > root.conf 
	
		${smr} devuan.conf
		echo "TARGET_to_ram=1" >> root.conf
		${scm} 0444 root.conf
		cd ${previous}
	fi
}

case ${cmd} in
	-x)
		xxx ${par}
	;;
	-y)
		[ -d ${CONF_source} ] || ${smd} -p ${CONF_source}
		${som} -o loop,ro ${par} ${CONF_source}
		xxx ${CONF_source}/live/filesystem.squashfs
		${uom} ${CONF_source}
	;;
	-b) 
		bbb		
	;;
	-d)

		if [ x"${CONF_squash0}" != "x" ] ; then
			echo "${smr} -rf ${CONF_squash0}/* IN 6 SECS";sleep 6
			${smr} -rf ${CONF_squash0}/*
		fi

		if [ x"${CONF_tmpdir}" != "x" ] ; then 
			echo "${smr} -rf ${CONF_tmpdir}/* IN 6 SECS";sleep 6	
			${smr} -rf ${CONF_tmpdir}/*
		fi
	;;
	-c)
		cfd ${par}
	;;
	-r)
		rst
	;;
	-j)
		jlk_main ${par}

		[ z"${dir2}" != "z" ] || echo "--dir2 "
		[ -d ${dir2} ] || echo "--dir2 "
		jlk_conf ${dir2} devuan

		jlk_sums ${dir2}
		fix_sudo
	;;
	-f)
		fix_sudo
	;;
	*)
		usage
	;;
esac

