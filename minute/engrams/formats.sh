
cat $1.vn | sed -e 's/ / | /g; s/^/| /; s/$/ |/;' > $1.vt

cat $1.vn | sed -e 's/ .*//;' > $1.vz

cat $1.vz | grep -v '[[:alpha:]]' | tr '\n' ' ' > $1.vc

cat $1.vz | grep    '[[:alpha:]]' | tr '\n' ' ' > $1.vs


