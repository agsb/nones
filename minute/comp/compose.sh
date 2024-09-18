
rm x??? x???.* 2> /dev/null

echo ' clean orphan lines '

cat $1 | sed -e '/^$/d' > $1.ys

# count lines

cat $1.ys | wc > $1.wc

read lines words chars < $1.wc

echo "lines $lines words $words letters $chars"

# split into files

cat $1.ys | split -l 1 -x -a 3

# formating

for file in ` ls x* `; do
    echo " process $file"
    cat ${file} | \
        sed -e "s/ /\n/g;" | \
        sed -e "s/^/$file /;" > ${file}.z0
        cat -n ${file}.z0 | \
        sed -e "s/\\t/ /; s/ */ /;" > ${file}.z1
    done

# split

> $1.n
> $1.p

lim=$2

lim=$((lim+1))

for file in ` ls x*.z1 ` ; do
    echo " head $2 " $file
    echo " tail -n +${lim} " $file
    cat $file | head -$2 >> $1.p
    cat $file | tail -n +${lim} >> $1.n
    done

rm x??? x???.* 2> /dev/null

echo " sorting "

cat $1.p | sort -k 3 > $1.p$2

cat $1.n | sort -k 3 > $1.n$2

echo " qualify $2 "

# more is better, in interval
cat $1.p$2 | awk -f strike.awk | sort -n -r -k 2 | tee p  > $1.p$2.t

# less is better, not in interval, (found in all lines)
cat $1.n$2 | awk -f strike.awk | sort -n -k 3 | tee n | \
    grep " $lines " > $1.n$2.t

# compose

sh mdtable.sh $1.p$2.t

sh mdtable.sh $1.n$2.t
