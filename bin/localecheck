#!/usr/bin/env bash

warn() { printf "\e[31mwarning:\e[m %s\n" "$*"; ((++n_warnings)); } >&2

note() { printf "\e[33mnotice:\e[m %s\n" "$*"; ((++n_notices)); }

problem() { (( ++sy_total )); printf "\n\e[33mproblem:\e[m %s\n" "$*"; }

is_locale_supported() {
	locale -a 2>/dev/null | grep -qsxF "$(get_locale "$1")"
}

get_locale() {
	local locale=$1
	if [[ $locale == *.* ]]; then
		locale=${locale%%.*}.$(get_charset "$locale")
	fi
	echo "$locale"
}

get_charset() {
	local locale=$1 charset=''
	if [[ $locale == *.* ]]; then
		charset=${locale#*.}
		charset=${charset//-/}
		charset=${charset,,}
	else
		charset='default'
	fi
	echo "$charset"
}

check_setting() {
	local name=$1 value=$2

	[[ -z $value ]] && return

	if ! is_locale_supported "$value"; then
		warn "$name: unsupported locale \"$value\""
		(( ++sy_missing ))
		local xlocale=$(get_locale "$value")
		sy_missing_locs["$xlocale"]=y
	fi

	local charset=$(get_charset "$value")
	if [[ $charset != "utf8" ]]; then
		warn "$name: non-UTF8 locale \"$value\""
		sy_nonutf8_vars["$name"]=y
		(( ++sy_nonutf8 ))
	fi

	if [[ "$charset" != "$main_charset" ]]; then
		if [[ "${name##* }" == "LANG" ]]; then
			return
		fi
		warn "$name: charset does not match LANG ($charset | $main_charset)"
		(( ++sy_charmismatch ))
	fi
}

shopt -s extglob

checking_term=0
checking_parent=0
guessing_parent=""

declare -i pid_shell=$PPID
declare -i pid_term=$(ps -o 'ppid=' $pid_shell)
declare -i pid_parent=$(ps -o 'ppid=' $pid_term)

if (( pid_term > 1 )) && [[ -r "/proc/$pid_term/environ" ]]; then
	checking_term=1
	if (( pid_parent > 1 )); then
		if [[ -r "/proc/$pid_parent/environ" ]]; then
			checking_parent=1
		fi
	elif [[ $SESSION_MANAGER == */tmp/.ICE-unix/+([0-9]) ]]; then
		guessing_parent="from \$SESSION_MANAGER"
		pid_parent=${SESSION_MANAGER##*/tmp/.ICE-unix/}
		if [[ -r "/proc/$pid_parent/environ" ]]; then
			checking_parent=1
		fi
	fi
fi

ps_shell=$(ps -o 'pid=,command=' $pid_shell)
ps_terminal=$(ps -o 'pid=,command=' $pid_term)
ps_parent=$(ps -o 'pid=,command=' $pid_parent)

echo " * Parent:   $ps_parent"
echo " * Terminal: $ps_terminal"
echo " * Shell:    $ps_shell"
echo ""

unset ${!sy_*}
declare -A sy_missing_locs
declare -A sy_nonutf8_vars

# Read terminal's environment

vars=("LC_CTYPE" "LC_NUMERIC" "LC_TIME" "LC_COLLATE" "LC_MONETARY" "LC_MESSAGES"
	"LC_PAPER" "LC_NAME" "LC_ADDRESS" "LC_TELEPHONE" "LC_MEASUREMENT"
	"LC_IDENTIFICATION" "LC_ALL")

if (( checking_term )); then
	unset ${!TERM_*}
	while IFS='=' read -d '' name value; do
		if [[ $name == LANG || $name == LC_* ]]; then
			declare "TERM_$name"="$value"
		fi
	done < "/proc/$pid_term/environ"
elif [[ $ps_terminal == *' sshd:'* ]]; then
	warn "I cannot check your terminal's settings over SSH, skipping."
else
	warn "Terminal's environment is inaccessible, skipping shell=term checks."
fi

if (( checking_parent )); then
	if [[ $guessing_parent ]]; then
		note "Tried to guess parent process $guessing_parent."
	fi
	unset ${!PARN_*}
	while IFS='=' read -d '' name value; do
		if [[ $name == LANG || $name == LC_* ]]; then
			declare "PARN_$name"="$value"
		fi
	done < "/proc/$pid_parent/environ"
elif (( checking_term )); then
	warn "Parent's environment is inaccessible, skipping term=parent checks."
else
	note "Also skipping term=parent checks."
fi

# Basic checks

if [[ -z $LANG ]]; then
	warn "(shell) LANG: not set"
	main_charset='default'
	(( ++sy_nolang ))
else
	main_charset=$(get_charset "$LANG")
fi

if (( checking_term )); then
	if [[ -z $TERM_LANG ]]; then
		warn "(term) LANG: not set"
		t_main_charset='default'
		(( ++sy_nolang ))
	else
		t_main_charset=$(get_charset "$TERM_LANG")
	fi
fi

if (( checking_parent )); then
	if [[ -z $PARN_LANG ]]; then
		warn "(parent) LANG: not set"
		p_main_charset='default'
		(( ++sy_nolang ))
	else
		p_main_charset=$(get_charset "$PARN_LANG")
	fi
fi

for name in LANG "${vars[@]}"; do
	if [[ "$name" == "LC_COLLATE" ]]; then
		# skip LC_COLLATE on purpose, having it as 'C' is fine
		continue
	fi

	value=${!name}
	locale=$(get_locale "$value")
	charset=$(get_charset "$value")
	(( checking_term )) && {
		t_name="TERM_$name"
		t_value=${!t_name}
		t_locale=$(get_locale "$t_value")
		t_charset=$(get_charset "$t_value")
	}
	(( checking_parent )) && {
		p_name="PARN_$name"
		p_value=${!p_name}
		p_locale=$(get_locale "$p_value")
		p_charset=$(get_charset "$p_value")
	}

	check_setting "(shell) $name" "$value"
	(( checking_term )) &&
		check_setting "(term) $name" "$t_value"
	(( checking_parent )) &&
		check_setting "(parent) $name" "$p_value"

	if [[ "$name" == "LC_ALL" && -n "$value" ]]; then
		warn "$name: should not be set ($value)"
		(( ++sy_lcall ))
	fi

	(( checking_term )) && {
		if [[ -n "$value" && -z "$t_value" ]]; then
			warn "$name: set by shell but not terminal ($value | none)"
			(( ++sy_mismatch ))
		elif [[ -z "$value" && -n "$t_value" ]]; then
			warn "$name: set by terminal but not shell (none | $t_value)"
			(( ++sy_mismatch ))
		elif [[ "$charset" != "$t_charset" ]]; then
			warn "$name: charset mismatch between shell and terminal ($locale | $t_locale)"
			(( ++sy_mismatch ))
		elif [[ "$locale" != "$t_locale" ]]; then
			warn "$name: lang mismatch between shell and terminal ($locale | $t_locale)"
			(( ++sy_mismatch ))
		fi
	}

	(( checking_parent )) && {
		if [[ -n "$t_value" && -z "$p_value" ]]; then
			warn "$name: set by terminal but not parent ($t_value | none)"
			(( ++sy_p_mismatch ))
		elif [[ -z "$t_value" && -n "$p_value" ]]; then
			warn "$name: set by parent but not terminal (none | $p_value)"
			(( ++sy_p_mismatch ))
		elif [[ "$t_charset" != "$p_charset" ]]; then
			warn "$name: charset mismatch between terminal and parent ($t_locale | $p_locale)"
			(( ++sy_p_mismatch ))
		elif [[ "$t_locale" != "$p_locale" ]]; then
			warn "$name: lang mismatch between terminal and parent ($t_locale | $p_locale)"
			(( ++sy_p_mismatch ))
		fi
	}
done

if [[ ${LANG,,} == *'.utf8' ]]; then
	(( ++sy_utf8_dash ))
fi

# Display final results

if (( sy_nolang )) && [[ $LANG && -z $TERM_LANG ]]; then
	problem "Your terminal is missing \$LANG in its environment."
	echo " * Locale variables must be set for the terminal emulator itself"
	echo "   (and for the entire session), not only for the shell."
elif (( sy_nolang )) && [[ -z $LANG && $TERM_LANG ]]; then
	problem "Your shell is missing \$LANG in its environment."
	echo " * Even though your terminal has the correct \$LANG ($TERM_LANG),"
	echo "   it was removed by your shell's .profile, .bashrc or similar files."
elif (( sy_nolang )); then
	problem "You do not have \$LANG set."
	echo " * It must be set to a <lang>.utf-8 locale."
fi

if (( sy_mismatch )); then
	problem "Shell and terminal have different locale settings."
	echo " * Your .bashrc or similar startup scripts may be overriding them."
fi

if (( sy_p_mismatch )); then
	: ${parn_locale:=$PARN_LC_ALL};	: ${parn_locale:=$PARN_LC_CTYPE}
	: ${parn_locale:=$PARN_LANG};	: ${parn_locale:=empty}
	: ${term_locale:=$TERM_LC_ALL};	: ${term_locale:=$TERM_LC_CTYPE}
	: ${term_locale:=$TERM_LANG};	: ${term_locale:=empty}
	problem "Terminal and its parent have different locale settings."
	echo " * Your session doesn't have the right locale set, and your window manager"
	echo "   is launching all programs using the $parn_locale locale. But your terminal"
	echo "   hides the problem by setting its own locale to $term_locale."
	echo " * Fix your system to set the locale at login or session startup time."
fi

if (( sy_lcall )); then
	problem "You have \$LC_ALL set; it overrides all other settings."
	echo " * Do not set \$LC_ALL unless absolutely required."
	echo "   For normal usage, setting \$LANG should be enough."
fi

if (( sy_nonutf8 )); then
	problem "Your current locale is using a legacy charset."
	echo " * The incorrect variables are:"
	for var in "${!sy_nonutf8_vars[@]}"; do
		varname=${var#* }
		printf '   - %-20s (currently "%s")\n' "$var" "${!varname}"
	done
	echo " * Change your locales to their UTF-8 variants."
fi

if (( sy_charmismatch )) && [[ $LANG ]]; then
	problem "Your locale settings use different charsets."
	echo " * If any \$LC_* variables are set, they should use the same charset as \$LANG."
fi

if (( sy_missing )); then
	problem "Your current locale is missing from the system."
	echo " * The missing locales are:"
	printf '   - \e[1m%s\e[m\n' "${!sy_missing_locs[@]}"
	echo " * Make sure /etc/locale.gen has the apropriate lines uncommented."
	echo "   After editing the file, run 'locale-gen' as root."
fi

if (( sy_utf8_dash )); then
	problem "\$LANG is missing a dash in the charset."
	echo " * Even though 'utf-8' and 'utf8' are equivalent, some poorly-written programs"
	echo "   (such as 'tree') consider them different and will not work with the latter."
	echo " * To fix this, change \$LANG from \"$LANG\" to \"${LANG%.*}.utf-8\""
fi

if (( n_warnings + n_notices )); then
	echo ""
fi

if (( sy_total > 0 )); then
	echo -e "\e[1m$sy_total problems found.\e[m Here's a quick UTF-8 test for you:  --> \xe2\x98\x85 <--"
elif (( !checking_term )); then
	echo -e "Looks good, but you still need to check your terminal:  --> \xe2\x98\x85 <--"
else
	printf "Looks good. \xe2\x99\xa5\n"
	echo " * You are using the $LANG locale."
	echo " * Shell's locale matches terminal's locale."
	if (( checking_parent )); then
		echo " * Terminal's locale matches parent process locale."
	else
		echo " * Could not check if terminal and parent's locale settings match."
	fi
fi

if (( sy_total > 0 || !checking_term )); then
	echo " * a star             -- font and terminal are okay."
	echo " * 3 question marks   -- your terminal does not correctly interpret UTF-8".
	echo " * a box or rectangle -- UTF-8 works fine, but you need a better font."
	echo " * empty area         -- you ${B}really${R} need a better font or something."
fi
