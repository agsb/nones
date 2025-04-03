#/usr/bin/awk
#
#       awk -f maketablemd file.csv > file.md
#
#       agsb@2025

#
# define parameters
#
BEGIN {
        # process csv files
        FS = ",";

        # one record by line
        RS = "\r?\n";

        # hold parameters
        
        webs = "https://raw.githubusercontent.com/sgb-cprm/simbologia-mapeamento-geologico/refs/heads/master/fonts/glyphs"
        dire = ""
        file = ""

        # lines at table
        line = 0

        # lines per table
        maxlines = 20


#       common  
	print " "
        print " ### MINISTÉRIO DE MINAS E ENERGIA"
        print " ### SECRETARIA DE GEOLOGIA, MINERAÇÃO E TRANSFORMAÇÃO MINERAL"
	print " ### SERVIÇO GEOLÓGICO DO BRASIL – CPRM"
	print " ### DIRETORIA DE GEOLOGIA E RECURSOS MINERAIS"
	print " ### DEPARTAMENTO DE GEOLOGIA"
	print " ### DIVISÃO DE GEOLOGIA BÁSICA"
	print " "
	print " ## BIBLIOTECA DE SÍMBOLOS"
	print " ### CARTOGRAFIA GEOLÓGICA"
	print " "
	print " ### EDIÇÃO 2025"
	print " "

## samples
# 
# ### **CONVENÇÕES GEOLÓGICAS E GEOFÍSICAS PARA REPRESENTAÇÃO EM CARTAS/MAPAS GEOLÓGICOS**
# 
# 
# | SÍMBOLO  | TAMANHO (points)/(mm) | COR | NOMENCLATURA | OBSERVAÇÕES/DESCRIÇÃO | BIBLIOTECA (Style)
# | --------- |:---------:| :---------: | :---------: | :---------: | :---------: |
# | ![Acamadamento](https://raw.githubusercontent.com/sgb-cprm/simbologia-mapeamento-geologico/refs/heads/master/fonts/glyphs/geology/U%2B00CD-CPRMGeologyRegular.svg "Acamadamento") |17,01 / 6 |PRETO 100% | Acamadamento | | SGB_geologia |
# 
# 
# ### **SIMBOLOGIA DE FÓSSEIS**
# 
# 
# | SÍMBOLO  | TAMANHO (points)/(mm) | COR | NOMENCLATURA | OBSERVAÇÕES/DESCRIÇÃO | BIBLIOTECA (Style)
# | --------- |:---------:| :---------: | :---------: | :---------: | :---------: |
# | ![Acritarcos](https://raw.githubusercontent.com/sgb-cprm/simbologia-mapeamento-geologico/refs/heads/master/fonts/glyphs/stratigraphy-paleontology/U%2B0021-CPRMStratigrPaleontRegular.svg "Acritarcos") |14 / 4,94 |PRETO 100% | Acritarcos | | SGB_geologia |
# 
# 
# ### **SIMBOLOGIA DE ESTRUTURAS SEDIMENTARES**
# 
# 
# | SÍMBOLO  | TAMANHO (points)/(mm) | COR | NOMENCLATURA | OBSERVAÇÕES/DESCRIÇÃO | BIBLIOTECA (Style)
# | --------- |:---------:| :---------: | :---------: | :---------: | :---------: |
# | ![Bimodalidade de grãos](https://raw.githubusercontent.com/sgb-cprm/simbologia-mapeamento-geologico/refs/heads/master/fonts/glyphs/stratigraphy-paleontology/U%2B00A2-CPRMStratigrPaleontRegular.svg "Bimodalidade de grãos") |12 / 4,23 |PRETO 100% | Bimodalidade de grãos | | SGB_geologia |
#

}

#
# main loop 
#
{
        # do cvs files tricks

        # numbers inside quotation marks with commas create fake fields
        $0 = gensub (/" *([0-9]+),([0-9]+) *"/, " \\1.\\2 ", "g", $0)

        # eval it again 
        $0 = $0

        # only parse 6 field lines 

        if ( (NF) != 6 ) {
                next
                }
        
        # match the headers and define variables

        if (/CONVENÇÕES /) {
                titu = $1
                dire = "geology"
                file = "GeologyRegular.svg"
                line = 0
                }

        if (/SIMBOLOGIA DE FÓSSEIS/) {
                titu = $1
                dire = "stratigraphy-paleontology"
                file = "StratigrPaleontRegular.svg"
                line = 0
                }

        if (/SIMBOLOGIA DE ESTRUTURAS SEDIMENTARES/) {
                titu = $1
                dire = "stratigraphy-paleontology"
                file = "StratigrPaleontRegular.svg"
                line = 0
                }

        
        if ( line == 0 ) {
	        print " "
	        print " ## "
                print " ## ***" titu "***"
	        print " "
                print " | SÍMBOLO  | TAMANHO (points)/(mm) | COR | NOMENCLATURA | CÓDIGO UTF-8 | OBSERVAÇÕES/DESCRIÇÃO | " 
                print " | --------- |:---------:| :---------: | :---------: | :---------: | :---------: | "
                line = 1
                next
                }

        # transform 

        gsub ("\"", " ", $3);

        gsub ("[.]", ",", $3);

        gsub ("\"", " ", $4);
        
        gsub ("[.]", ",", $4);

        # reform

        utf8 = $2
        
        gsub ("U","U+",utf8);

        gsub ("U","U%2B",$2);
        
        # print out

        print " | ![" $6 "](" webs "/" dire "/" $2 "-CPRM" file " \"" $6 "\" ) | " $3 " / " $4 " | " $5 " | " $6 " | " utf8 " | "

        line = line + 1

        if (line == maxlines) {
                line = 0
}               }


END {

  print " ~~~ "

  }

  

