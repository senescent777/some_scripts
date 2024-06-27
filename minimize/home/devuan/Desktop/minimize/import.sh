#!/bin/bash

. ~/Desktop/minimize/conf

function parse_opts_1() {
	case "${1}" in
		-v|--v)
			debug=1
		;;
		*)
			archive=${1}
		;;
	esac
}

. ./lib

if [ $# -gt 0 ] ; then
	for opt in $@ ; do parse_opts_1 $opt ; done
fi

#TODO:oleelllisista hmistoista backup ennen purkua?

cd /
${som} $part $dir -o ro
sudo tar -xvpf $dir/$archive
${uom} $part
cd ~/Desktop/minimize

#HUOM. tämän olisi kuvakkeen kanssa tarkoitus mennä jatkossa filesystem.squashfs sisälle
#TODO:make_tar:ista gpgtar-jutut
#TODO:https://github.com/senescent777/some_scripts/tree/senescent777-alt-version/skripts/export ja https://github.com/senescent777/some_scripts/tree/senescent777-alt-version/lib/export soveötaen
