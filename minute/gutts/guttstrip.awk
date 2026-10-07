
BEGIN {

    list = ""

    }

{

    if (/*** START OF THE PROJECT GUTENBERG EBOOK /) {
        list = "on";
        next
        }
    
    
    if (/*** END OF THE PROJECT GUTENBERG EBOOK /) {
        list = "off";
        exit
        }

    if (list == "on" ) print $0

    # print ">" list "< " $0
}

END {

    } 
