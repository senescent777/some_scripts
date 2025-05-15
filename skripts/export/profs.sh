#dqb "#i've known since year 2003 that netscape/mozilla/firefox profiles can be a Pain In the Ass"
#csleep 6
#lukkotiedostojen hävitys oli kanssa 1 juttu mikä piti uistaa tehdä...
#TODO:siirto git:in sisllä eri repositoryyn

function oldprof() {
	dqb "cprof1 ${1} ${2}"
	csleep 3

	local tmp
	tmp=$(grep -c ${1} /etc/passwd)

	if [ ${tmp} -gt 0 ] ; then 
		if [ -d ${1}/.mozilla ] ; then
			${NKVD} ${1}/.mozilla/*
			${smr} -rf ${1}/.mozilla 
		fi
	
		${odio} mkdir -p ${1}/.mozilla/firefox
	fi

	if [ ${debug} -eq 1 ] ; then
		echo "AFTER MKDIR";sleep 3
		ls -las ${1}/.mozilla/firefox;sleep 3
		echo "eEXIT oldprof($1)"
	fi
}

function createnew() {
	dqb "cpfor_12 ${1},${2}" #HUOM.ei pitäisi tulla 2. param

	local tmp
	local fox

	tmp=$(grep -c ${1} /etc/passwd)
	fox=$(${odio} which firefox)

	if [ ${tmp} -gt 0 ] ; then 
		if [ -x ${fox} ] ; then
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

#VAIH:profiilin hakemiseen $(${}) - tyyppinen juttu jatkossa, skripti tai fktio
#findprof=$(find ~/.mozilla/firefox -type d -name '*esr*' | grep -v '+' | tail -n 1)

function copy_to() {
	debug=1
	dqb "cprof13 ${1} ${2} ${3}"
	csleep 3
	
	[ -d ${2} ] || exit 68
	[ x"${3}" == "x" ] && exit 69
	[ -d ${3} ] || exit 70

	local tget

	#saattaisi onnistua ilman greppiäkin? man find...
	tget=$(find ${2} -type d | grep -v '+' | grep ${1} | head -n 1)
	dqb "TGET= ${tget}"

	dqb "IN 3 SECONDS: sudo mv ${3}/* ${tget}"
	csleep 3

	local f
	for f in $(find ${3} -type f -name '*.js*') ; do mv ${f} ${tget} ; done		
	
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
		#voisi mennä ilmankin sudoa tuossa alla...
		dqb "shdgfsdhgfsdhgf"
		csleep 2

		if [ -d ${2}/.mozilla ] ; then 
			${sco} -R ${1}:${1} ${2}/.mozilla
			${scm} -R 0700 ${2}/.mozilla 	
		fi

		[ -d ${2}/Downloads ] || ${odio} mkdir ${2}/Downloads

		${sco} -R ${1}:${1} ${2}/Downloads
		${scm} u+wx ${2}/Downloads
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

			oldprof /home/${2}
			${sco} -R ${2}:${2} /home/${2}/.mozilla/firefox
			createnew ${2}
			copy_to ${1} /home/${2}/.mozilla/firefox ${3}
			access ${2} /home/${2}
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
	#*.js ja *.json kai oleellisimmat kalat
	cd ${p}

	csleep 2
	dqb "eprof.D03N"
}