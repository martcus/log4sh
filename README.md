# log4.sh
Log for shell (aka log4.sh): Makes logging in shell scripting easy

### How to Include log4.sh
Add this code in your bash script:
```
source log4.sh [OPTIONS]
```

### What do you find?
* log4.sh: core script for logging. 
* template4.sh: basic template on which to build your own bash scripts
* test.sh: testing script

## log4sh
Puoi usare le funzioni:
* FATAL
* ERROR
* WARNING
* INFO
* DEBUG
* TRACE
Tutte accettano sia un singolo parametro di input (ciò che si desidera stampare) sia un parametro in input.
Es:
```
-	INFO “Hello World”
-	echo “Hello” | INFO “World” #stampa prima la pipe poi l’argomento
```
Stampano entrambe:
```
20180808_15:07:33+0200 INFO    Hello World
```

### Nota
Potete includere nel vostro path lo script tramite il seguente snipper:
```
PATH=$PATH:[your bin dir]. 
```
Un esempio classico nel caso tu desideri inserire lo script nella directory bin della home del tuo user:
```
PATH=$PATH:~/bin
```
