#!/bin/bash
# t is a utility to work with (h)ledger *.timeclock files
# see github.com/linuxcaffe/task-timelog-hook

timelog=.task/hooks/task-timelog-hook/tw.timeclock
# if [ $TIMELOG ] then $timelog = $TIMELOG
# fi

EDITOR_BIN='vi +'
# if [ $EDITOR ] then EDITOR_BIN = $EDITOR
# fi

# This script could be configurable to use ledger or hledger 
# TODO: s/ledger/$LEDGER_BIN/g .. carefully!)
# LEDGER_BIN = ledger
#   if [ $LEDGER ] then LEDGER_BIN = $LEDGER
#   fi

# timedot file can only be read by hledger, so only include it if hledger is set
# timedot=' -f /home/djp/.task/hooks/task-timelog-hook/test.ledger'
# TIMEDOT_FILE = path/to/my.timedot
#   if $LEDGER_BIN = "hledger" then $TIMELOG_FILE = "$TIMELOG_FILE $TIMEDOT_FILE"
#   fi

# Show current timelog
_t_timelog() {
  echo "$timelog"
}

# Run a ledger command on the timelog
_t_ledger() {
  ledger -f "$timelog" "$@"
}

# do something in unix with the timelog
_t_do() {
    action=$1; shift
    ${action} "$@" "${timelog}"
}

# Clock in to the given project
# Clock in to the last project if no project is given
_t_in() {
	in="i $(TZ=America/Chicago date "+%Y-%m-%d %H:%M:%S")"
	status=$(grep '^i \|^o ' "$timelog" |tail -n1 |head -c1)
	if [ -n "$1" ]; then
		in+=" "
		in+="$1"
	fi
	if [ -n "$2" ]; then
    desc="${@:2}"
    in+="  $desc"
  fi
	if [ "$status" == "o" ] || [ "$status" == "" ]; then
		echo "$in" >> "$timelog"
    echo "clocked in to $1 - $desc - at $(date "+%H:%M")" >&2
#		echo "$in"
	elif [ "$status" == "i" ]; then
		echo "already clocked in" >&2
		echo "clock out and then in" >&2
#		_t_out
#		_t_in "$1"
	fi
}

# Clock out
_t_out() {
	status=$(grep '^i \|^o ' "$timelog" |tail -n 1 |head -c 1)
	out="o $(TZ=America/Chicago date "+%Y-%m-%d %H:%M:%S")"
	account=$(grep '^i \|^o ' "$timelog" |tail -n 1 |cut -f4- -d' '|grep .)
	if [ -n "$1" ]; then
		out+=" "
		out+="$1"
	fi
	if [ "$status" == "i" ]; then
		echo "$out" >> "$timelog"
  export PS2=">"
		if [ "$account" != "" ]; then
			echo "account:" "$account" >&2
		else
			echo "account: none" >&2
		fi
    echo "clocked out at $(date "+%H:%M")" >&2
	else
		echo "not clocked in" >&2
	fi
}

function status() {
	entry=$(tail -n1 "$timelog")
	status=$(echo "$entry"|head -c1)
	if [ "$status" == "i" ]; then
		echo "clocked in" >&2
	elif [ "$status" == "o" ]; then
		echo "clocked out" >&2
	fi
	echo "$entry"
}

# Show the currently clocke:bnd-in project
_t_cur() {
  sed -e '/^i/!d;$!d' "${timelog}" | __t_extract_project
}

# Show the last checked out project
_t_last() {
  sed -ne '/^o/{g;p;};h;' "${timelog}" | tail -n $1 | head -n 1 | __t_extract_project
}

# Show usage
_t_usage() {
  # TODO
  cat << EOF
Usage: t action
actions:
     in - clock into project or last project
     out - clock out of project
     sw,switch - switch projects
     bal - balance [args]
     reg - register [args]
     hours,td - balance for today
     yd,yesterday - balance for yesterday
     yd^ - balance for 2 days ago
     tw,thisweek - balance for this week
     lw,lastweek - balance for last week
     edit - edit timelog file
     cur - show currently open project
     last - show last closed project
     last^ to last^^^^^ - show nth last closed project
     grep - grep timelog for argument
     cat - cat timelog
     head - show start of timelog
     tail - show end of timelog
     less - show timelog in pager
     timelog - show timelog file
EOF
}

#
# INTERNAL FUNCTIONS
#

__t_extract_project() {
  sed -e 's/\([^ \t]* \)\{3\}//'
}

if [ -z "$TIMELOG_STARTOFWEEK" ]; then
  _args="bal -p"
else
  _args="bal --start-of-week $TIMELOG_STARTOFWEEK -p"
fi

action=$1; shift
[ "$TIMELOG" ] && timelog="$TIMELOG" || timelog="${HOME}/$timelog"

case "${action}" in
  in)   _t_in "$@";;
  i)   _t_in "$@";;
  out) _t_out "$@";;
  o) _t_out "$@";;
  sw)   _t_sw "$@";;
  bal) _t_ledger bal "$@";;
  reg) _t_ledger reg "$@";;
  hours) _t_ledger bal -p "since today" "$@";;
  td) _t_ledger bal -p "since today" "$@";;
  yesterday) _t_ledger bal -p "yesterday" "$@";;
  yd) _t_ledger bal -p "yesterday" "$@";;
  yd^) _t_ledger bal -p "2 days ago" "$@";;
  thisweek) _t_ledger $_args "this week" "$@";;
  tw) _t_ledger $_args "this week" "$@";;
  lastweek) _t_ledger $_args "last week" "$@";;
  lw) _t_ledger $_args "last week" "$@";;
  switch)   _t_sw "$@";;
  edit) _t_do $EDITOR_BIN "$@";;
  upd) hledger -f $timelog print > ~/.task/hooks/task-timelog-hook/test.ledger;;
  cur)  _t_cur "$@";;
  last^^^^^) _t_last 6 "$@";;
  last^^^^) _t_last 5 "$@";;
  last^^^) _t_last 4 "$@";;
  last^^) _t_last 3 "$@";;
  last^) _t_last 2 "$@";;
  last) _t_last 1 "$@";;
  grep) _t_do grep "$@";;
  cat)  _t_do cat "$@";;
  head)  _t_do head "$@";;
  tail)  _t_do tail "$@";;
  less)  _t_do less;;
  timelog) _t_timelog "$@";;

  h)    _t_usage;;
  *)    _t_usage;;
esac

exit 0
