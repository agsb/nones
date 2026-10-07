
> gutfiles

for file in `find . -name '*.utf-8' `; do

    echo $file

    cat $file | iconv -f UTF-8 -t ASCII -c | awk -f guttstrip >> gutfiles

    done

