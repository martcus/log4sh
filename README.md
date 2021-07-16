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
Puoi usare le funzioni:
* FATAL [log text]
* ERROR [log text]
* WARN  [log text]
* INFO  [log text]
* DEBUG [log text]
* TRACE [log text]
Tutte accettano sia un singolo parametro DI input (ciò che si desidera stampare) sia un parametro IN input (tramite Pipe). Es:
```
-	INFO “Hello World”
-	echo “Hello” | INFO “World” #stampa prima la pipe poi l’argomento
```
Stampano entrambe:
```
20180808_15:07:33+0200 INFO    Hello World
```
La funzione:
* SET_LEVEL [FATAL, ERROR, WARN, INFO, DEBUG, TRACE, OFF]

permette di cambiare il livello di log durante l'esecuzione. Il parametro di input, obbligatorio, è il nuovo livello di logging.

### Nota
Potete includere nel vostro path lo script tramite il seguente snipper:
```
PATH=$PATH:[your bin dir]. 
```
Un esempio classico nel caso tu desideri inserire lo script nella directory bin della home del tuo user:
```
PATH=$PATH:~/bin
```
