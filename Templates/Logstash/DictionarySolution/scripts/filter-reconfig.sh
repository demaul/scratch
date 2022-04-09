#!/usr/bin/bash

if [ $1 -eq $NULL ]
then
   echo "./lsm_prod_gen.sh /path/to/range-traslate.conf"
   exit 1
fi

dictpath=$1
confpath="../conf.d/135-filter-translate.conf"
newconf="../conf.d/newconf.conf"
ifvalue="if"

rm -f $newconf

echo "filter {" >> $newconf
echo "if \"IQ-CSV\" in [tags]" >> $newconf
echo "{" >> $newconf



while read -r line
do

if [[ $line == "\"datedict\""* ]]
then

  
  lsmver=${line:54:6}
  
  echo "$ifvalue [lsmver] == \"$lsmver\"" >> $newconf
  echo "{" >> $newconf
  echo "translate {" >> $newconf
  echo "fallback => \"no_dictionary_match\"" >> $newconf
  echo "dictionary_path => \"../dictionaries/$lsmver.json\"" >> $newconf
  echo "field => \"iqdestIp\"" >> $newconf
  echo "destination => \"lsmcsv\"" >> $newconf
  echo "}" >> $newconf
  echo "}" >> $newconf 
  ifvalue="else if" 

fi

done < $dictpath

echo "" >> $newconf
echo "csv {" >> $newconf
echo "autogenerate_column_names => \"false\"" >> $newconf
echo "separator => \",\"" >> $newconf
echo "skip_empty_columns => \"true\"" >> $newconf
echo "source => \"lsmcsv\"" >> $newconf
echo "columns =>      [\"vsoProcessDescription\",\"mrASERVER\",\"vsoIngressBR\",\"vsoEgressBR\",\"vsoPicType\",\"vsoMusic\",\"vsoCallLetters\",\"vsoServiceCollection\",\"vsoChanType\",\"vsoLAI\",\"vsoTVE\",\"mrBranch\",\"iqLocality\",\"vsoNetPos\"]" >> $newconf
echo "}" >> $newconf
echo "}" >> $newconf
echo "}" >> $newconf

cd ../
tar -czvf "backups/$(date '+%y-%m-%d')filter-range.tar.gz" $confpath && mv $newconf $confpath && exit 0
