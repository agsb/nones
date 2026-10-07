

cat $1 | ssh-keygen -Y sign -f ~/.ssh/id_ed25519 -n file > $1.sig


cat $1 | ssh-keygen -Y check-novalidate -f ~/.ssh/id_ed25519.pub -n file -s $1.sig 

