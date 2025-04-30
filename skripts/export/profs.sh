##!/bin/bash
debug=1
#. ~/Desktop/minimize/middleware.sh
#VAIH:jatkossa vähän toisin nämä asiat

cprof_1_1() {
	

		tmp=$(grep $1 /etc/passwd | wc -l)

		if [ $tmp -gt 0 ] ; then 
			if [ -d /home/$1/.mozilla ] ; then
				sudo shred /home/$1/.mozilla/*
				sudo rm -rf /home/$1/.mozilla 
	
			#else
			fi
	
	
			sudo mkdir -p /home/$1/.mozilla/firefox
			sudo chown -R $1:$1 /home/$1/.mozilla/firefox
		fi

	if [ ${debug} -eq 1 ] ; then
		echo "AFTER MKDIR";sleep 5
		ls -las /home/$1/.mozilla/firefox;sleep 6
		echo "eEXIT CPROF_1_1($1)"
	fi
}

cprof_1_2() {
	fox=$(sudo which firefox)

		tmp=$(grep $1 /etc/passwd | wc -l)

		if [ $tmp -gt 0 ] ; then 
			if [ -x $fox ] ; then
				cd /home/$1
				sudo -u $1 $fox&
	
				if [ $? -eq 0 ] ; then
					sleep 5
					whack firefox-esr 
					whack firefox 
				fi
			else
				echo "https://www.youtube.com/watch?v=PjotFePip2M" 
			fi
		#else
		fi

}

cprof_1_3() {
	[ -d /home/$2/.mozilla/firefox ] || exit 68
	cd /home/${2}/.mozilla/firefox
	
	if [ ${debug} -eq 1 ] ; then
		pwd;sleep 6 
		echo "CPROF_1_3_1";sleep 5
		ls -las /home/${2}/.mozilla/firefox;sleep 6
	fi

		tget=$(ls | grep $1 | tail -n 1) 

		sudo chown ${2}:${2} ./${tget}
		sudo chmod 0700 ./${tget}
		
		if [ x"${tget}" != "x" ] ; then 
			cd ${tget}
		#else
		fi

	if [ x"${tmpdir}" != "x" ] ; then
		if [ -d ${tmpdir} ] ; then
			if [ ${debug} -eq 1 ] ; then
				echo -n "pwd=";pwd
				echo "IN 6 SECONDS: sudo mv $tmpdir/* ."
				sleep 6
			fi

			sudo mv ${tmpdir}/* . #TÄMÄN KANSSA TARKKUUTTA PERKELE
			sudo chown -R ${2}:${2} ./* 		
	
			if [ ${debug} -eq 1 ] ; then
				echo "AFT3R MV";sleep 6
				ls -las;sleep 5
			fi	

			sudo shred -fu ${tmpdir}/*
			sudo rm -rf ${tmpdir}
		fi
	fi
}

cprof_2_1() {


	if [ x$1 != x ] ; then 
		sudo chown -R $1:$1 /home/$1

		if [ -d /home/$1/.mozilla ] ; then 
			sudo chown -R $1:$1 /home/$1/.mozilla
			sudo chmod -R go-rwx /home/$1/.mozilla 	
		fi

		[ -d /home/$1/Downloads ] || sudo mkdir /home/$1/Downloads

		sudo chown -R $1:$1 /home/$1/Downloads
		sudo chmod u+wx /home/$1/Downloads
		sudo chmod o+w /tmp 
	fi

}

copyprof() {
	cd /home/$2 

	if [ x$2 != x ] ; then 
		if [ -d /home/$2 ] ; then 
			sudo chmod 0700 /home/$2


			cprof_1_1 $2
			cprof_1_2 $2
			cprof_1_3 $1 $2
			cprof_2_1 $2
		fi
	fi

}

#vähän toisella tyylillä jatkossa
#prepare $3
#copyprof $1 $2