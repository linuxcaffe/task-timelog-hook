#!/bin/bash
######################################################## v.0.6
#   _             _   _                _               #
#  | |_          | |_(_)_ __ ___   ___| | ___   __ _   #
#  | __|   IS    | __| | '_ ` _ \ / _ \ |/ _ \ / _` |  #
#  | |_    FOR   | |_| | | | | | |  __/ | (_) | (_| |  #
#   \__|          \__|_|_| |_| |_|\___|_|\___/ \__, |  #
#                                              |___/   #
#                                                      #
########################################################
# t is a utility to work with (h)ledger *.timeclock files
# see github.com/linuxcaffe/task-timelog-hook/

########## User Configs #######################
timelog=.task/hooks/task-timelog-hook/tw.timeclock
# if [ $TIMELOG ] then $timelog = $TIMELOG
# fi
#
### Timezone
tz="Canada/Eastern"
#
### Editor
EDITOR_BIN="vi +"
# if [ $EDITOR ] then EDITOR_BIN = $EDITOR
# fi
#
### Ledger binary
# This script could be configurable to use ledger or hledger 
# TODO: s/ledger/$LEDGER_BIN/g .. carefully!)
# LEDGER_BIN=ledger
#   if [ $LEDGER ] then LEDGER_BIN = $LEDGER
#   fi
#
### Timedot file
# timedot file can only be read by hledger, so only include it if hledger is set
timedot="~/.task/hooks/task-timelog-hook/tw.timedot"
# TIMEDOT_FILE=path/to/my.timedot
#   if $LEDGER_BIN = "hledger" then $TIMELOG_FILE = "$TIMELOG_FILE $TIMEDOT_FILE"
#   fi
###################################################


# Ansi color code variables
red="\e[0;91m"
blue="\e[0;94m"
# expand_bg="\e[K"
# blue_bg="\e[0;104m${expand_bg}"
# red_bg="\e[0;101m${expand_bg}"
# green_bg="\e[0;102m${expand_bg}"
green="\e[0;92m"
# white="\e[0;97m"
# bold="\e[1m"
# uline="\e[4m"
reset="\e[0m"
#
# # horizontally expanded backgrounds
# echo -e "${blue_bg}${reset}"
# echo -e "${red_bg}${reset}"
# echo -e "${green_bg}${reset}"

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
	in="i $(TZ=$tz date "+%Y-%m-%d %H:%M:%S")"
	status=$(grep '^i \|^o ' "$timelog" |tail -n1 |head -c1)
	if [ -n "$1" ]; then
    account="$1"
  	in+=" $account"
  else
    account=$(grep '^i ' "$timelog" |tail -n1 |cut -f 4 -d' ' |grep .)
		in+=" $account"
	fi
	if [ -n "$2" ]; then
    desc="${@:2}"
    in+="  $desc"
  fi
	if [ "$status" == "o" ] || [ "$status" == "" ]; then
    echo "" >> "$timelog"
		echo "$in" >> "$timelog"
    echo "$account - $desc"
    echo -e "${green}CLOCKED IN${reset} at $(date "+%r")" >&2

  elif [ "$status" == "i" ]; then
	  account=$(grep '^i ' "$timelog" |tail -n1 |cut -f 4 -d' ' |grep .)
	  desc=$(grep '^i ' "$timelog" |tail -n1 |cut -f 5- -d' ' |grep .)
	if [ -n "$1" ]; then
    new_account="$1"
    new=" $new_account"
	fi
	if [ -n "$2" ]; then
    new_desc="${@:2}"
    new+="  $new_desc"
  fi
		echo "already clocked in to - $account - $desc" >&2
    read -n 1 -p "clock OUT and then IN to - $new ? [Y/n] >" reply; 
      if [ "$reply" != "" ]; then echo; fi
      if [ "$reply" = "${reply#[Nn]}" ]; then
      	out="o $(TZ=$tz date "+%Y-%m-%d %H:%M:%S")"
        echo "$out" >> "$timelog"
        echo "" >> "$timelog"
			  echo "$account - $desc " >&2
        echo -e "${red}CLOCKED OUT${reset} at $(date "+%r")" >&2
        echo "---"
      	in="i $(TZ=$tz date "+%Y-%m-%d %H:%M:%S")"
        in+="$new"
        echo "$in" >> "$timelog"
        echo "$new_account - $new_desc"
        echo -e "${green}CLOCKED IN${reset} at $(date "+%r")" >&2
      else
        echo "Okay"
      fi


 #   echo "CLOCK OUT and then IN to - $new ? (Y/n) >" >&2
	fi
}

# Clock out
_t_out() {
	status=$(grep '^i \|^o ' "$timelog" |tail -n 1 |head -c 1)
	out="o $(TZ=$tz date "+%Y-%m-%d %H:%M:%S")"
	account=$(grep '^i ' "$timelog" |tail -n 1 |cut -f 4 -d' ' |grep .)
	desc=$(grep '^i ' "$timelog" |tail -n1 |cut -f 5- -d' ' |grep .)
	if [ -n "$1" ]; then
    comment="$@"
		out+="  ; $comment"
  else
    comment=""
	fi
	if [ "$status" == "i" ]; then
		echo "$out" >> "$timelog"
		if [ "$account" != "" ]; then
			echo "$account - $desc - $comment" >&2
		else
      account_none="account:none"
      out+=" $account_none"
		  echo "$out" >> "$timelog"
			echo "$account - $desc - $comment" >&2
		fi
    echo -e "${red}CLOCKED OUT${reset} at $(date "+%r")" >&2
	else
    echo -e "can't clock ${red}OUT${reset}" >&2
		echo -e "not clocked ${green}IN${reset}" >&2
	fi
}

_t_status() {
# TODO: check that timelog file exists, else, create one?
# TODO: check that timelog entries exist, else; help; Usage
# TODO: check that ledger_bin exists, else; help
	status=$(grep '^i \|^o ' "$timelog" |tail -n 1 |head -c 1)
	account=$(grep '^i ' "$timelog" |tail -n 1 |cut -f 4 -d' ' |grep .)
	desc=$(grep '^i ' "$timelog" |tail -n1 |cut -f 5- -d' ' |grep .)
	if [ "$status" == "i" ]; then
	  in_time=$(grep '^i ' "$timelog" |tail -n 1 |cut -f 3 -d' ' |grep .)
    echo -e "${blue}status: clocked${reset} ${green}IN${reset} ${blue}to${reset} $account $desc ${blue}at${reset} $in_time"
    echo -e "${blue}clock OUT ?${reset} (Y/n) >"
  else
	  comment=$(grep '^o ' "$timelog" |tail -n1 |cut -f 4- -d' ' |grep .)
	  out_time=$(grep '^o ' "$timelog" |tail -n 1 |cut -f 3 -d' ' |grep .)
    echo -e "${blue}status: clocked${reset} ${red}OUT${reset} ${blue}of${reset} $account$desc$comment ${blue}at${reset} $out_time" >&2
# TODO: implement a verbosity level, following would be lev:2
    echo -e "${blue}clock IN to${reset} $account ${blue}again ?${reset} (Y/n)" >&2
  fi
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
Usage: t<space><action> or t<CR> for status        "t" is for "timelog"
  actions:
     i|in <account:sub> [desc] [; comment]      td|today - balance today
     o|out [comment]                            yd|yesterday - bal yesterday
     a|accounts - list accounts used            yd^ - balance for 2 days ago
     b|bal - balance report [args]              tw|thisweek - bal for this week
  *  c|comm - add comment                       lw|lastweek - bal for last week
  *  d|dot - open timedot file (hledger)        tm|thismonth - bal for this mo
     e|edit - edit timelog file                 lm|lastmonth - bal for last mo
     f|file - show timelog file         _             
     g|grep - grep [args]              | |_     For report args and options see
     h|help - (you're looking at it)   | __|    ledger-cli.org or man ledger 
  *  l|log - record previous event     | |_      or  
     p|print - print [args]             \__|    hledger.org, run hledger<CR>
     r|reg - register [args]                   
     s|stats                                    For user configs edit this file
     t|tail - show end of timelog               For corrections edit timeclock 
  *  u|ui - open in hledger-ui                  For more details see README.md
  *  v|version                                  
  *  w|write - print timedot > ledger
  *  z|zip - backup files                       Please report issues/fixes to 
      ( * = planned )          https://github.com/linuxcaffe/task-timelog-hook/
EOF
}

#hms_to_hours() {
#      echo "$1" | awk -F: '{ print (($1 * 3600) + ($2 * 60) + $3) / 3600 }'
#    }

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
  "") _t_status;;
  in)   _t_in "$@";;
  i)   _t_in "$@";;
  out) _t_out "$@";;
  o) _t_out "$@";;
  edit) _t_do $EDITOR_BIN "$@";;
  e) _t_do $EDITOR_BIN "$@";;
  file) _t_timelog "$@";;
  f) _t_timelog "$@";;
  grep) _t_do grep "$@";;
  g) _t_do grep "$@";;
  accounts) grep '^i ' "$timelog" |awk '{print $4}'|sort|uniq;;
  a) grep '^i ' "$timelog" |awk '{print $4}'|sort|uniq;;
  bal) _t_ledger bal "$@";;
  b) _t_ledger bal "$@";;
  reg) _t_ledger reg "$@";;
  r) _t_ledger reg "$@";;
  print) _t_ledger print "$@";;
  p) _t_ledger print "$@";;
  hours) _t_ledger bal -p "since today" "$@";;
  td) _t_ledger bal -p "since today" "$@";;
  yesterday) _t_ledger bal -p "yesterday" "$@";;
  yd) _t_ledger bal -p "yesterday" "$@";;
  yd^) _t_ledger bal -p "2 days ago" "$@";;
  thisweek) _t_ledger $_args "this week" "$@";;
  tw) _t_ledger $_args "this week" "$@";;
  lastweek) _t_ledger $_args "last week" "$@";;
  lw) _t_ledger $_args "last week" "$@";;
  last^^^^^) _t_last 6 "$@";;
  last^^^^) _t_last 5 "$@";;
  last^^^) _t_last 4 "$@";;
  last^^) _t_last 3 "$@";;
  last^) _t_last 2 "$@";;
  last) _t_last 1 "$@";;
  head)  _t_do head "$@";;
  tail)  _t_do tail "$@";;
  less)  _t_do less;;
  upd) _t_do hledger -f $timedot print > ~/.task/hooks/task-timelog-hook/timedot.ledger;;

  h)    _t_usage;;
  *)    _t_usage;;
esac

exit 0
