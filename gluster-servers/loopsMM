#/usr/bin/bash

# creates files with N * 4096 random bytes
# uses 4 GB of disk
# agsb@ 2025

SECTOR=512

BLOCK=$1

BLOCK=${BLOCK:=1}

SLICE=$2

SLICE=${SLICE:=1}

BLOCK=$(( BLOCK * 4096 ))

SLICE=$(( SLICE * 4096 * 1024 * 1024 ))

FILES=$(( SLICE / BLOCK ))

COUNT=$(( BLOCK / SECTOR ))

echo $SLICE in $FILES files of $BLOCK bytes with $COUNT sectors of 512 bytes

echo "Continue y/N ?"

read yes

if [ $yes != "Y" ] && [ $yes != "y" ] ; then 
        echo Aborting...
        exit 0
fi

echo Continue...

NDIR=$BLOCK-`uuid`

mkdir $NDIR

# mark init
touch in0

cd $NDIR

# generate files 

for n in $( seq 1 ${FILES} ) ; do
    echo $n
    # each dd is N * 512 bytes
    dd if=/dev/random of=`uuid` count=${COUNT}
done

cd ..

# mark ends
touch in1


