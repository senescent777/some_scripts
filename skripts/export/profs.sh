#dqb "#i've known since year 2003 that netscape/mozilla/firefox profiles can be a Pain In the Ass"
#csleep 6
#lukkotiedostojen hävitys oli kanssa 1 juttu mikä piti uistaa tehdä...
function oldprof() {
	dqb "cprof1 ${1} ${2}"
	csleep 3
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
}

function createnew() {
	dqb "cpfor_12 ${1},${2}"
	fox=$(sudo which firefox)
	local tmp
	tmp=$(grep -c ${1} /etc/passwd)

	if [ ${tmp} -gt 0 ] ; then 
		if [ -x ${fox} ] ; then
			cd /home/${1}
#			#${odio} -u ${1} toimisikohan ilmankn sudoa? kyl kait
			${fox}&
	
			if [ $? -eq 0 ] ; then
				sleep 3
				${whack} firefox-esr 
				${whack} firefox 
			fi
		else
			echo "https://www.youtube.com/watch?v=PjotFePip2M" 
		fi
	fi

	csleep 3
}
function copy_to() {
	debug=1
	dqb "cprof13 ${1} ${2} ${3}"
	csleep 3

	[ -d /home/${2}/.mozilla/firefox ] || exit 68
	[ x"${3}" == "x" ] && exit 69
	[ -d ${3} ] || exit 70

	local tget
	tget=$(find /home/${2}/.mozilla/firefox -type d | grep -v '+' | grep ${1} | head -n 1)
	dqb "TGET= ${tget}"

	${sco} ${2}:${2} ${tget}
	${scm} 0700 ${tget}

	dqb "IN 3 SECONDS: sudo mv ${3}/* ${tget}"
	csleep 3

	local f
	for f in $(find ${3} -type f -name '*.js*') ; do mv ${f} ${tget} ; done
	${sco} -R ${2}:${2} ./* 		
	
	if [ ${debug} -eq 1 ] ; then
		echo "AFT3R MV";sleep 3
		ls -las ${tget}
		sleep 3
	fi	

	csleep 3
	dqb "CPROF13 D0N3"
}

function access() {
	dqb "CPFOR21 ${1} , ${2}"
	csleep 2

	if [ x"${1}" != "x" ] ; then 
		dqb "shdgfsdhgfsdhgf"
		csleep 2

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
	csleep 2
}

function imp_prof() { 
	dqb "cprof ${1} ${2} ${3}"
	csleep 2

	if [ x"${2}" != "x" ] ; then 
		if [ -d /home/${2} ] ; then 
			${scm} 0700 /home/${2}

			oldprof ${2}
			createnew ${2}
			copy_to ${1} ${2} ${3}
			access ${2}
		fi
	fi

	dqb "cpforf dnoe"
	csleep 2
}

function exp_prof() {
	dqb "exp_pros ${1} ${2}"
	local tget
	local p
	local f
	
	csleep 2
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
	cd ${p}

	csleep 2
	dqb "eprof.D03N"
}