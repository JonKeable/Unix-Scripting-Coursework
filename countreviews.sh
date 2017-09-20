#!/bin/sh
#The folder to work in is specified by the first argument
cd "$1"| grep -c -r --include \*.dat '\<Author\>'| xargs -n 1 basename | sort -t: -rn -k2 | sed -e 's/\.dat//' -e 's/\:/  /'
