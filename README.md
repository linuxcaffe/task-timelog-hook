# task-timelog-hook
A taskwarrior hook that logs task start/stop times to a timeclock file, that (h)ledger can read. 

TLDR; If you enjoy the command-line and you want to track your time, including taskwarrior start/stop times, projects and tags, and you want to be able to easily read/ report/ query/ export your time-accounting data, then you should give this project a try. Warning: experimenting with ledger and/or hledger can lead to vastly improved personal accounting! 

## INTRODUCTION

https://taskwarrior.org is a command-line task-management program that is amazingly customizable, but lacks the functionality to track time spent on those tasks. A companion app, timewarrior, was created to fill this gap, but in my experience, timewarrior commands are counter-intuitive, tricky to connect with taskwarrior data, and with limited reporting capability. Instead, this project proposes another way.

https://hledger.org is a command-line accounting program capable of tracking all sorts of finances, currencies, commodities, _including time!_ hledger (and several other plaintextaccounting.org programs) can read/ query/ report from timelog.el formatted files. (see https://hledger.org/hledger.html#timeclock-format)

task-timelog-hook connects taskwarrior start/stop times with hledger's time-accounting, opening up a great range of queries and reports based on taskwarrior descriptions, projects and tags. This information is essential for invoicing, etc. This hook is based entirely on https://gist.github.com/wbsch/d977b0ac29aa1dfa4437 by Wilhelm Schürmann in 2015, and it works just great! I'm expanding the gist to a github repo to provide documentation and tweaks where needed.

## INSTALL 

### Requirements

#### Taskwarrior

#### ledger or hledger 

## CONFIGURE
* files location
* editor

## RECOMMENDED
### Timedot

## USAGE

### Timeckock

### Timedot

## CREDITS
## COMMENTS
## CONTRIBUTIONS

