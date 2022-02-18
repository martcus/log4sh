# log4.sh [![Shellcheck](https://github.com/martcus/log4sh/actions/workflows/shellcheck.yml/badge.svg)](https://github.com/martcus/log4sh/actions/workflows/shellcheck.yml)
Log for shell (aka log4.sh): Makes logging in shell scripting easy

### How to Include log4.sh
Add this code in your bash script:
```
source log4.sh [OPTIONS]
```

### What do you find?
* log4.sh: core script for logging. 
* template4.sh: basic template on which to build your own bash scripts
* test-log4.sh: testing script

## log4sh
You can use this functions:
* FATAL [log text]
* ERROR [log text]
* WARN  [log text]
* INFO  [log text]
* DEBUG [log text]
* TRACE [log text]

```
-	INFO “Hello World”
-	echo “Hello” | INFO “World” #stampa prima la pipe poi l’argomento
```

They both "print"

```
20180808_15:07:33+0200 INFO    Hello World
```

The function:
* SET_LEVEL [FATAL, ERROR, WARN, INFO, DEBUG, TRACE, OFF]

allows you to change the logging level at runtime. The input parameter, which is mandatory, is the new logging level.

### Notes
You can include the script in your path via the following snippet:

```
PATH=$PATH:[your bin dir]. 
```

A classic example in case you want to put the script in the bin directory of your user's home:

```
PATH=$PATH:~/bin
```
