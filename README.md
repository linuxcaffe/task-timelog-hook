# task-timelog-hook
> A [taskwarrior](https://taskwarrior.org) hook that logs task start/stop times to a [timeclock file](https://hledger.org/hledger.html#timeclock-format), that [ledger](https://ledger-cli.org) and [hledger](https://hledger.org) can read. 

- _TLDR;_ If you enjoy the command-line and you want to track your time, including taskwarrior start/stop times, projects and tags, and you want to be able to easily read/ report/ query/ export your time-accounting data, then you should give this project a try. This approach is an alternative to [timewarrior](http://timewarrior.net). 
- _Warning_: experimenting with ledger and/or hledger can lead to vastly improved personal financial and time accounting! 

## INTRODUCTION

- [Taskwarrior](https://taskwarrior.org) is a command-line task-management program that is amazingly customizable, with projects and tags and reports and User Defined Attributes.. it's "the 800lb gorilla" in the CLI ToDo list jungle. Tasks can be started and stopped, and those times recorded as annotations, but taskwarrior doesn't have the built-in functionality to track or report on the those intervals. That's where ledger and hledger shine! 

- [ledger](https://ledger-cli.org) and [hledger](https://hledger.org) are both mature [command-line accounting programs](http://plaintextaccounting.org) with active development communities. They are work-alikes, and while [not identical](https://hledger.org/faq.html#how-is-hledger-different-from-ledger-) (ledger written in c++, hledger in haskell) they share most file-formats and many commands. One of the things they have in common is the ability to query and report from timeclock (a.k.a. timelog) formatted text files. The terms "timeclock" and "timelog" seem to be used interchangeably, and that's fine as long as the file extension is "*.timeclock". 

## INSTALL 
### Requirements
- Taskwarrior
- Taskwarrior hook
- ledger or hledger 
- 
## CONFIGURE
* files location
* editor

## RECOMMENDED
- timedot (for hledger users)
- timedot-vim
- t and t. scripts

## USAGE
### Timelog files
Timelog entries can be created taskwarrior start/stop commands, or directly by editing the *.timeclock file, or by using "t".
### t 
"t" is a handy script to work with (h)ledger and timelog files
```
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
     t|tail - show end of timelog               For corrections edit timelog 
  *  u|ui - open in hledger-ui                  For more details see README.md
  *  v|version                                  
  *  w|write - print timedot > ledger
  *  z|zip - backup files                       Please report issues/fixes to 
      ( * = planned )          https://github.com/linuxcaffe/task-timelog-hook/
- Timedot
```
## CREDITS

This hook is based entirely on https://gist.github.com/wbsch/d977b0ac29aa1dfa4437 by Wilhelm Schürmann in 2015, and it works just great! I'm expanding the gist to a github repo to provide documentation and tweaks where needed.

## COMMENTS
## CONTRIBUTIONS
Bug reports, suggestions, pull requests welcome https://github.com/linuxcaffe/task-timelog-hook/issues

