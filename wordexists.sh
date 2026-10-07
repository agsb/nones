#!/bin/bash
rm lst

while IFS= read -r word
    do
        rm index.html

        word=$(echo $word | tr -d ' ')

        url="https://www.dictionary.com/browse/$word"

        wget $url

        grep " No results found " $word || echo "$word EXISTS" >> lst

    done

