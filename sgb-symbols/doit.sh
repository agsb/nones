 #/bin/bash

 # list the first two lines of all svg files found.
 # to discover which apps created the file, by header signature
 # agsb@2025

 find . -name '*.svg' -exec echo \{\} \; -exec head -2 \{\} \; | \
 sed -e 's/\.\//\n\.\//' | \
 paste -d ',' - - - - | \
 cat -b | sed -e 's/\t,/,/; s/\r//;'


