# wise clean

cat $1 | \
tr '[:upper:]' '[:lower:]' | \
tr 'ñáéíóúàèìòùãõç' 'naeiouaeiouaoc' | \
tr -d '_' | tr '\n\r\t\v' '__  ' | \
tr -d [:cntrl:] | tr -s '_ ' | tr '_' '\n' > $1.v

