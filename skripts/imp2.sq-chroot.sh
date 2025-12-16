#!/bin/sh
#tarpeellinen kikkare? jos on ni pirtäisi päivittää (16.12.25)
##echo "PT 1:extract some archives "
##echo "PT 2:make a conf-file before PT 1 "
##pitää se common_lib myös jos haluaa -1:sen asentavan asmalla pakettei
#echo "-f ./nekros.tar.bz3 && tar -jf ./nekros.tar.bz3 -xv import2.sh "
#echo "-f ./fg.tar.bz2 && ./import2.sh 3 $(pwd)/fg.tar.bz2"
#echo "./import2 -1 ;... ja sit jotain ?"
echo "bunzip2 fg.tar-bz2"
echo "mv fg.tar \$distro/f-tar"
echo "-x ./import2.sh && ./import2 -1"