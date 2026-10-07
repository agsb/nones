BEGIN {

    print "{ [ "

    for (n=1; n < 20000; n++) {

        print "{ \"count\" : " n ", \"void\" : null },"

        }

    print " ] } "

}

{
}

END {

print "---ends---"
}
