
# conteudo parcial em linhas deve ser concatenado 

cat $1 | \
    tr '\t\r\n' ' #' | \
    sed -e ' s/ \{2,\}/ /g; s/> \{1,\}/>/g; s/ \{1,\}</</g; s/>#</>\n</g; s/#\{1,\}/ /g' | \
    grep -E '>[^<>]*</' | sed -e 's/[ \t]\{2,\}/ /g' > $1.z

paste $1.z $1.z | sed -e 's/^/sed -e ~/; s/>[^<]*</>[^<]*</; s/\t/~/; s/$/~/; ' > $1.x

rm $1.z


