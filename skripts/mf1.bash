#pohjana skeripts/export/mf.bsh / this is ba5ed on skripts/export/mf.bsh
#TODO:joq päivä takaisin käyttöqntoon
debug=0 #1
source=""
d=$(dirname $0)
. ${d}/common.conf

protect_system

ltgtdir=""
cleanup=0
tgtfile=SAM.2.0
#:yhteistyö >"-v" - vivun kanssa, kai toimii

function parse_opts_real() {
	dqb "fm.parse_opts_real ( ${1}. ${2} ) "
	
	case ${1} in
		--target)
			ltgtdir=${2} 
		;;
		--cleanup)
			cleanup=${2} 
		;;	
	esac

function single_param() {
		dqb "fm.single_p ( ${1}  ) "
}
	
function usage() {
	echo "${0} --in <dir> "
}

. ${d}/common_funcs.sh

if [ $# -lt 2 ] ; then
	exit
fi

function process_dir() {

	if [ -s ${1}.tar.${2} ] ; then 
		sudo mv ${1}.tar.${2} ${CONF_trash_dir}/${1}.tar.${2}.OLD
	fi

	local topts=""


	
	if [ x"${1}" != "x" ] ; then 
		if [ -d ./${1} ] ; then
			
			
			sudo chmod -R a-w ${1}/*
			sudo chown -R root:root ${1}/*.sh
			sudo chown ${1}/*.conf
			sudo chown -R root:root ${1}/tmp/*

			cd ./${1}

			sudo tar --exclude='*.export' --exclude='*.OLD' ${topts} -jcf ../${1}.tar.${2} .

			cd ../..
			has_patch=$(echo $1 | grep ${TARGET_patch_name} | wc -l)

			if [ ${has_patch} -eq 0 ] ; then 
				slaughter0 ${TARGET_pad_dir}/${1}.tar.${2} ${TARGET_DIGESTS_dir}/${tgtfile}

				slaughter0 ${TARGET_pad_dir}/${1}.sh ${TARGET_DIGESTS_dir}/${tgtfile}
			else
			fi

			cd ${TARGET_pad_dir}

		fi
	fi

}

parse_opts ${1} ${2} 
parse_opts ${3} ${4} 
parse_opts ${5} ${6} 

if [ -s ${ltgtdir}/mf.conf ] ; then
	echo ". ${ltgtdir}/mf.conf"
	. ${ltgtdir}/mf.conf
else
 	echo "https://www.youtube.com/watch?v=PjotFePip2M" 
	exit 666
fi

[ x"${TARGET_DIGESTS_dir}" != "x" ] || exit 1
[ x"${tgtfile}" != "x" ] || exit 1

enforce_deps

cd ${ltgtdir}/..


if [ x"${TARGET_DIGESTS_dir}"  != "x" ] ; then 
	[ -d ${TARGET_DIGESTS_dir}  ] || sudo mkdir -p ${TARGET_DIGESTS_dir} 

	if [ x"${tgtfile}"  != "x" ] ; then 
		[ -s ${TARGET_DIGESTS_dir}/${tgtfile} ] && mk_bkup ${TARGET_DIGESTS_dir}/${tgtfile}  
	fi

	sudo touch ${TARGET_DIGESTS_dir}/${tgtfile}
	sleep 2
	sudo chmod a+w ${TARGET_DIGESTS_dir}/${tgtfile} 
fi

cd ${ltgtdir}

if [ ${cleanup} -eq 1 ] ; then
	mk_bkup ${TARGET_DIGESTS_dir}/SAM.*
	exit 1
fi

cd ${ltgtdir}

for d in ${MF_bz3files} ; do 
	process_dir ${d} bz3 
done

cd ${ltgtdir}

for d in ${MF_bz2files} ; do 
	process_dir ${d} bz2 
done

cd ${ltgtdir}/..

for d in ${MF_conffiles} ; do 
	slaughter0 ${TARGET_pad_dir}/${d} ${TARGET_DIGESTS_dir}/${tgtfile}
done

sudo chmod a-w ${TARGET_DIGESTS_dir}/${tgtfile}
echo "stage0?"

