
 cat $1 | \
#1
 grep -v 'AO' | \
 grep -v 'WM' | \
 grep -v 'JT' | \
# tee is1 | \
#2
 grep -v 'IO' | \
 grep -v 'UM' | \
# tee is2 | \
#3
 grep -v 'IW' | \
 grep -v 'SM' | \
 grep -v 'VT' | \
# tee is3 | \
#4
 grep -v 'EV' | \
 grep -v 'IU' | \
 grep -v 'OA' | \
 grep -v 'HT' | \
# tee is4 | \
#5
 grep -v 'EH' | \
 grep -v 'IS' | \
 grep -v 'SI' | \
 grep -v 'HE' | \
# tee is5 | \
#6
 grep -v 'TH' | \
 grep -v 'NO' | \
 grep -v 'DI' | \
 grep -v 'BE' | \
# tee is6 | \
#7
 grep -v 'TB' | \
 grep -v 'MS' | \
 grep -v 'GI' | \
# tee is7 | \
#8
 grep -v 'MD' | \
 grep -v 'OI' | \
# tee is8 | \
#9
 grep -v 'MG' | \
 grep -v 'ON' | \
# tee is9 | \
#0
 grep -v 'MO' | \
 grep -v 'OM' | \
# tee is0 | \
#?
 grep -v 'IZ' | \
 grep -v 'UD' | \
#!
 grep -v 'NY' | \
 grep -v 'KW' | \
#.
 grep -v 'RK' | \
#,
 grep -v 'GW' | \
#;
 grep -v 'KR' | \
 grep -v 'CN' | \
#+
 grep -v 'AR' | \
 grep -v 'RN' | \
#-
 grep -v 'DU' | \
 grep -v 'BA' | \
#/
 grep -v 'NR' | \
 grep -v 'DN' | \
 grep -v 'XE' | \
#=
 grep -v 'NU' | \
 grep -v 'DA' | \
 grep -v 'BT' | \
#
cat > $1.1s


