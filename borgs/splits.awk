#/usr/bin/awk

# agsb@2025
#
# decompose json arrays into files named by random UUID.jsn, 
# makes the sha256sum of content in files UUID.hsh and
# a reference file for URIs as UUID.urs
#
# UUID and DATE are appended at start of each jsn file
#
#   use:  awk -f splits.awk < json_file_with_arrays_of_objects
#
# vide disclaimer at end of this file.

#
# define parameters
#
BEGIN {

    RS = "\n";

    FS = "";

    SUBSEP = " ";

    cnt = 0;

    pares = 0

    new = 0

    cmd = "uuid -F STR -1 -v4"

    dat = "date --iso-8601=s"

    hsh = "sha256sum -b "

    # for additional protection do this as root
    # when files at rest directory.
    # und = "chattr +i "
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
    
    if (pares == 1 && new == 1) {

        if (new == 1) printf "} " > filejsn

        close (filejsn)

        # make the hash

        hash = hsh filejsn

        err = (hash | getline hast)

        if (err != 1) {

            print "shell error", err

            exit
            
            }

        filehsh = file ".hsh"

        print hast > filehsh

        close (filehsh)

        fileurs = file ".urs"

        print "\"UUID\" : \"" file "\"," > fileurs
        print "\"DATE\" : \"" date "\"," > fileurs

        close (fileurs)

        new = 0

        cnt = cnt + 1

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


    print " done " cnt " files."

  }


#-----------------------------------------------------------------------
# Copyright (c) 2025, Alvaro Gomes Sobral Barcellos
# All rights reserved.
# 
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
# 
# 1. Redistributions of source code must retain the above copyright 
#    notice, this list of conditions and the following disclaimer.
#
# 2. Redistributions in binary form must reproduce the above copyright
#    notice, this list of conditions and the following disclaimer in 
#    the documentation and/or other materials provided with the 
#    distribution.
# 
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
# "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT 
# LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS 
# FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE 
# COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
# INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
# BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES, LOSS
# OF USE, DATA, OR PROFITS, OR BUSINESS INTERRUPTION) HOWEVER CAUSED 
# AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT 
# LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN 
# ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
# POSSIBILITY OF SUCH DAMAGE.
#


