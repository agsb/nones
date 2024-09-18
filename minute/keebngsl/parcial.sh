
cp z0 a0
cp z1 a1
cat a0 a1 | sort -n -k 2 | head -12 > z

