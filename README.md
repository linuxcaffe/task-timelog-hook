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

- [t](https://github.com/linuxcaffe/t/)
  "t" is a handy bash script that works great with timelog files. It simplifies starting/ stopping/ switching/ reporting timelog functions with just a few keystrokes.
  
- [timedot](https://github.com/linuxcaffe/timedot-vim) (for hledger users)
  timedot is another timelogging file format for those things you want to record approximately how much time per-day you spent doing various things. It's concise and human-readable, and ideal for those activities that dont require CLOCK-IN/ CLOCK-OUT precision. If you use hledger, timedot and timeclock records can easily be combined by including them both from a journal file.
  
## USAGE
With this hook installed, timelog (eg. task.timeclock file) entries are automatically created with taskwarrior start/stop commands. Because the timecklock file is simple and human-readable text, it's easily modified in your $EDITOR of choice. A great variety of report and options can be run using ledger (`man ledger`) or hledger (`hledger<CR>`). Working with timeclock (timelog) files is even easier using "[t](https://github.com/linuxcaffe/t)".

## CREDITS

This hook is based entirely on https://gist.github.com/wbsch/d977b0ac29aa1dfa4437 by Wilhelm Schürmann in 2015, and it works just great! I'm expanding the gist to a github repo to provide documentation and tweaks where needed.

## CONTRIBUTIONS
Bug reports, suggestions, pull requests welcome https://github.com/linuxcaffe/task-timelog-hook/issues

