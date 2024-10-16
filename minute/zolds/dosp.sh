

cat $1 | tr '[:upper:]' '[:lower:]' | tr 'ñáéíóúàèìòùãõç' 'naeiouaeiouaoc' | tr -d '-' > $1.z0

awk -f ngslsts.awk $1.z0  > $1.z1

awk -f ngslchs.awk < $1.z1 | tee $1.z2 | sort -n -r -k 2 > $1.z3


