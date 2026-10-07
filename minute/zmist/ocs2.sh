
 cat $1 | tr '[:upper:]' '[:lower:]' | \
          tr 'ñáéíóúàèìòùãõç' 'naeiouaeiouaoc' | \
          tr -d '-' > $1.y1

 gawk -f ocsdig.awk < $1.y1  > $1.y2

 grep '=' $1.y2 | sort -n -k 3 > $1.y3
 grep '#' $1.y2 | sort -n -k 3 > $1.y4
 grep '~' $1.y2 | sort -n -r -k 3 > $1.y5
 grep ':' $1.y2 | sort -n -r -k 3 > $1.y6

 cat $1.y3 | cut -f 2 -d ' ' | tr '\n' ' ' > $1.y7


