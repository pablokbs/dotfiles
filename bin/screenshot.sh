#!/bin/sh
#

screenshot() {
	case $1 in
	full)
		scrot -m -e 'mv $f ~/screens/'
		;;
	window)
		sleep 1
		scrot -s -e 'mv $f ~/screens/'
		;;
	*)
		;;
	esac;
}

screenshot $1
