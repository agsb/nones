#
# define parameters
#
BEGIN {

    RS = "\n";

    FS = "";

    SUBSEP = " ";

    cnt = 0;

    pares = 0

    uuid = "";

    cmd = "uuid -F STR -1 -v4"

    dat = "date --iso-8601=s"

    hsh = "hashalot -x sha512 < "

}

#
# loop 
#
{
   for (i = 1; i <= NF; i++) {

    cc = $i
    
    if (cc == "{") {
        pares++;
        }
    
    if (cc == "}") {
        pares--;
        }
    
    if (pares == 1) {

        if (new == 1) printf "}" > filejsn

        hash = hsh file

        print hash

        err = hash | getline hash

        filehsh = file hash

        print hash > filehsh

        new = 0

        }

    if (pares == 2 && new == 0) {
        
        err = (cmd | getline file)

        close (cmd)

        err = (dat | getline date)

        close (dat)

        if (err != 1) {

            print "shell error", err

            exit
            
            }

        new = 1
    
        filejsn = file ".jsn"

        print "\"UUID\" : \"" file "\"," > filejsn
        print "\"DATE\" : \"" date "\"," > filejsn

        }

    if (new == 1) printf "%c", cc > filejsn

    }

} 


END {


  }

  

