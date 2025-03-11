#TODO:toiselle nimelle minimizen kanssa yhteensOPiva versio tästä tdstosta ... tai sitten middleware.sh väliin
cprof_1_1() {
	

		tmp=$(grep $1 /etc/passwd | wc -l)

		if [ $tmp -gt 0 ] ; then 
			if [ -d /home/$1/.mozilla ] ; then
				sudo shred /home/$1/.mozilla/*
				sudo rm -rf /home/$1/.mozilla 
	
			else
			fi
	
	
			sudo mkdir -p /home/$1/.mozilla/firefox
			sudo chown -R $1:$1 /home/$1/.mozilla/firefox
		fi

		echo "AFTER MKDIR";sleep 5
		ls -las /home/$1/.mozilla/firefox;sleep 6
		echo "eEXIT CPROF_1_1($1)"
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
		else
		fi

}

cprof_1_3() {
	cd /
	sudo touch $tmpdir/.mozilla/*
	sudo chmod 0600  $tmpdir/.mozilla/*

	[ -d /home/$2/.mozilla/firefox ] || exit 68
	cd /home/$2/.mozilla/firefox
	
		pwd;sleep 6 
		echo "CPROF_1_3_1";sleep 5
		ls -las /home/$2/.mozilla/firefox;sleep 6

		tget=$(ls | grep $1 | tail -n 1) 

		sudo chown $2:$2 ./$tget
		sudo chmod 0700 ./$tget
		
		if [ x$tget != x ] ; then 
			cd $tget
		else
		fi

			echo -n "pwd=";pwd
			echo "IN 6 SECONDS: sudo mv $tmpdir/.mozilla/* ."
			sleep 6

		sudo mv $tmpdir/.mozilla/* .
		sudo chown -R $2:$2 ./* 		
	
			echo "AFT3R MV";sleep 6
			ls -las;sleep 5
		


	sudo shred -fu $tmpdir/.mozilla/*
	sudo rm -rf $tmpdir/.mozilla

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
