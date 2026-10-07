cat $1 | sed -e 's/{/{ \n/g; s/}/\n} \n/;' | grep -v ':null' > $1.z #&& mv $1.z $1

