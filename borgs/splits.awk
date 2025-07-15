#/usr/bin/awk

# agsb@2025
#
# decompose json arrays into files named by random UUID.jsn, 
# makes the sha256sum of content in files UUID.cmd_hash and
# a reference file for URIs as UUID.urs
#
# UUID and DATE are appended at start of each jsn file
#
#   use:  awk -f splits.awk < json_file_with_arrays_of_objects
#
# the file structure have objects 
# { ... [ { ...object ...}, { ...object ...}, ...] ...}
#
# vide disclaimer at end of this file.

# version 0.1.0 05/07/2025
#
# define parameters
#
BEGIN {

    RS = "\n";

    FS = "";

    cnt = 0;

    pares = 0

    array = 0

    new = 0

    cmd_uuid = "uuid -F STR -1 -v4"

    cmd_date = "date --iso-8601=s"

    cmd_hash = "sha256sum -b "

    cmd_fmod = "chmod 00644 "

    # for additional protection do this as root
    # when files at final rest directory.
    # und = "chattr +i "
}

#
# loop 
#
{
   for (i = 1; i <= NF; i++) {

    cc = $i

    if (cc == "[") {
        array++;
        }

    if (cc == "]") {
        array--;
        }

    if (array == 0) continue

    if (cc == "{") {
        pares++;
        }
    
    if (cc == "}") {
        pares--;
        }
    
    if (pares == 0 && new == 1) {

        # end of file

        printf "} " > file

        close(file)

        # make the hash file

        doit = cmd_hash file

        err = (doit | getline hash)
        
        close(doit)

        if (err != 1) {

            print "shell error", err

            exit
            
            }

        file = uuid ".hsh"

        print hash > file

        close(file)

        # make the uri file

        file = uuid ".urs"

        print "\"UUID\" : \"" uuid "\"," > file
        print "\"DATE\" : \"" date "\"," > file

        close(file)

        # make the mode

        doit = cmd_fmod " -v " uuid "*"

        err = (doit | getline the)

        close(doit)

        if (err != 1) {

            print "shell error", err

            exit
            
            }

        # log it

        cnt = cnt + 1

        print cnt, uuid, date

        # prepare next file

        new = 0

        }

    if (pares == 1 && new == 0) {
        
        err = (cmd_uuid | getline uuid)

        close(cmd_uuid)

        if (err != 1) {

            print "shell error", err

            exit
            
            }

        err = (cmd_date | getline date)

        close(cmd_date)

        if (err != 1) {

            print "shell error", err

            exit
            
            }

        # make a file

        file = uuid ".jsn"

        print "\"UUID\" : \"" uuid "\"," > file
        print "\"DATE\" : \"" date "\"," > file

        new = 1
    
        }

    # must append a space or it is taked as binary
    if (new == 1) printf "%c", cc " " > file

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


