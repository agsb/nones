
BEGIN {

    it = ""
    ct = 0
    qt = 0

    }

{
    if (it != $3) {
        if (it != "") print it " " ct " " qt
        it = $3
        ct = 0
        qt = 0
        }
    ct += 1
    qt += $1
}

END {
        print it " " ct " " qt
    }
