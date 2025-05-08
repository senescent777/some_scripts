#netscape/mozilla/firefox profiles can be a Pain In the Ass

function cprof_1_1() {
	#debug=1	
	dqb "cprof1 ${1} ${2}"
	csleep 5

	local tmp
	tmp=$(grep -c ${1} /etc/passwd)

	if [ ${tmp} -gt 0 ] ; then 
		if [ -d /home/${1}/.mozilla ] ; then
			${NKVD} /home/${1}/.mozilla/*
			${smr} -rf /home/${1}/.mozilla 
		fi
	
	
		${odio} mkdir -p /home/${1}/.mozilla/firefox
		${sco} -R ${1}:${1} /home/${1}/.mozilla/firefox
	fi

	if [ ${debug} -eq 1 ] ; then
		echo "AFTER MKDIR";sleep 5
		ls -las /home/${1}/.mozilla/firefox;sleep 6
		echo "eEXIT CPROF_1_1($1)"
	fi
}

function cprof_1_2() {
	#debug=1
	dqb "cpfor_12 ${1},${2}"

	fox=$(sudo which firefox)
	local tmp
	tmp=$(grep ${1} /etc/passwd | wc -l) #grep -c 

	if [ ${tmp} -gt 0 ] ; then 
		if [ -x ${fox} ] ; then
			cd /home/${1}
			${odio} -u ${1} ${fox}&
	
			if [ $? -eq 0 ] ; then
				sleep 5
				${whack} firefox-esr 
				${whack} firefox 
			fi
		else
			echo "https://www.youtube.com/watch?v=PjotFePip2M" 
		fi
	fi

	csleep 5
}

function cprof_1_3() {
	#debug=1
	dqb "cprof13 ${1} ${2} ${3}"
	csleep 4
	
	[ -d /home/${2}/.mozilla/firefox ] || exit 68
	[ x"${3}" == "x" ] && exit 69
	[ -d ${3} ] || exit 70

	cd /home/${2}/.mozilla/firefox
	
	if [ ${debug} -eq 1 ] ; then
		pwd;sleep 6 
		echo "CPROF_1_3_1";sleep 5
		ls -las /home/${2}/.mozilla/firefox;sleep 6
	fi

	local tget
	tget=$(ls | grep ${1} | tail -n 1) 

	${sco} ${2}:${2} ./${tget}
	${scm} 0700 ./${tget}
		
	if [ x"${tget}" != "x" ] ; then 
		cd ${tget}
	fi

	if [ ${debug} -eq 1 ] ; then
		echo -n "pwd=";pwd
		echo "IN 6 SECONDS: sudo mv ${3}/* ."
		sleep 6
	fi

	local f
	for f in $(find ${3} -type f -name '*.js*') ; do mv ${f} . ; done
	${sco} -R ${2}:${2} ./* 		
	
	if [ ${debug} -eq 1 ] ; then
		echo "AFT3R MV";sleep 6
		ls -las;sleep 5
	fi	

	csleep 5
	dqb "CPROF13 D0N3"
}

function cprof_2_1() {
	#debug=1
	dqb "CPFOR21 ${1} , ${2}"
	csleep 3

	if [ x"${1}" != "x" ] ; then 
		#${sco} -R ${1}:${1} /home/${1} #kommentteihin koska x
		#voisi mennä ilmankin sudoa tuossa alla...
		dqb "shdgfsdhgfsdhgf"
		csleep 3

		if [ -d /home/${1}/.mozilla ] ; then 
			${sco} -R ${1}:${1} /home/${1}/.mozilla
			${scm} -R go-rwx /home/${1}/.mozilla 	
		fi

		[ -d /home/${1}/Downloads ] || sudo mkdir /home/${1}/Downloads

		${sco} -R ${1}:${1} /home/${1}/Downloads
		${scm} u+wx /home/${1}/Downloads
		${scm} o+w /tmp 
	fi

	dqb "d0n3"
	csleep 3
}

function copyprof() { #TODO:import_prof jatkossa
	#debug=1
	dqb "cprof ${1} ${2} ${3}"
	csleep 3
	cd /home/${2} 

	if [ x"${2}" != "x" ] ; then 
		if [ -d /home/${2} ] ; then 
			${scm} 0700 /home/${2}

			cprof_1_1 ${2}
			cprof_1_2 ${2}
			
			cprof_1_3 ${1} ${2} ${3}
			cprof_2_1 ${2}
		fi
	fi

	dqb "cpforf dnoe"
	csleep 3
}

function exp_prof() {
	dqb "exp_pros ${1} ${2}"
	local tget
	local p
	local f
	
	csleep 3
	
	tget=$(ls ~/.mozilla/firefox/ | grep ${2} | tail -n 1)
	p=$(pwd)

	cd ~/.mozilla/firefox/${tget}
	dqb "TG3T=${tget}"
	csleep 2

	${odio} touch ./rnd
	${sco} ${n}:${n} ./rnd
	${scm} 0644 ./rnd
	dd if=/dev/random bs=6 count=1 > ./rnd

	${srat} -cvf ${1} ./rnd
	for f in $(find . -name '*.js') ; do ${srat} -rf ${1} ${f} ; done
	#*.js ja *.json kai oleellisimmat kalat
	cd ${p}

	csleep 5
	dqb "eprof.D03N"
}