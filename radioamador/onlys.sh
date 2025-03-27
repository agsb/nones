
# allow only two touchs
grep -E '1[AIMN][AIMN][AIMN]' $1 > $1.2s
# allow only three touchs
grep -E '1[DGKORSUW][DGKORSUW][DGKORSUW]' $1 > $1.3s
# allow only four touchs
grep -E '1[BCFHJLPQVYXZ][BCFHJLPQVYXZ][BCFHJLPQVYXZ]' $1 > $1.4s
# allow only four huffman touchs
grep -E '1[QCBJFYP][QCBJFYP][QCBJFYP]' $1 > $1.5s
