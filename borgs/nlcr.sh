cat $1 | sed -e ' s/\[{/ [ \n{ /g; s/}\]/ }\n ] \n/g; s/},/ }, \n/g; s/ },\n ]/ }\n ] \n/;' > $1.nn
