
for doc in $(seq 1 2100) 
do 
wget -v http://www.metadados.cprm.gov.br/geonetwork/srv/por/xml_iso19139?id=${doc}&styleSheet= -o cprm_inde_${doc}.xml
echo cprm_inde_${doc}.xml
done

