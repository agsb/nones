#!/usr/bin/bash

if [[ $1 =~ .*/\.git.* ]]; then

        echo "== $1 no .git includes " | tee -a outs

        exit
fi

echo "== $1" | tee -a outs

cat $1 | awk -f filterz.awk | tee -a outs

