#!/bin/bash 

mkdir modules 2> /dev/null
cd modules
wget -r -np -nH –cut-dirs=2 -P ../ -e robots=off -R "index.html*" http://www.espruino.com/modules/
