# wise clean

cat $1 | \
tr '[:upper:]' '[:lower:]' | \
tr 'ñáéíóúàèìòùãõç' 'naeiouaeiouaoc' | \
tr -cd '[:print:][:cntrl:]' | \
tr '\n\r' 'NN' | \
sed -e 's/    /\t/g' | \
sed -e 's/\t/T/g' | \
tr -d [:cntrl:] | \
tr -s 'N ' | tr 'N' '\n' > $1.v

