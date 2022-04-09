#!/usr/bin/bash

if [ $3 -eq $NULL ]
then
   echo "./lsm_prod_gen.sh LSMFILE.xlsx X.X.00 YYYYMMDDHHMM"
   exit 1
fi

masterfile=$1
shortname=$2
datedict=$3

echo $masterfile
echo $shortname
echo $datedict

LSM_DIR="../LSM/LSM"
ECO_DIR="../LSM/ECO"

echo "Generating csvz, please be patient"
./xlsx2csv.py -a $masterfile $shortname

find .$shortname/  -maxdepth 1 -type f ! -iname "*Master.csv" -delete

cd $shortname

echo "{" > "$shortname"

for f in ./*
do

 echo "Processing $f"
 branch=`echo $f | sed -e 's/\.\/\(.*\)_Master.csv/\1/'`
 echo $branch

 locality="Local"
 if [ $branch == "ATLANTIS" ]
 then 
  locality=National
 fi

   f=`echo $f | sed 's/[[:space:]]*,[[:space:]]*/,/g'`

   awk -F, -v branch=$branch -v locality=$locality '{ print "  \"" $6 "\": \"" $4 "," $5 "," $10 "," $16 "," $33 "," $34 "," $35 "," $36 "," $40 ","$41 "," $43 "," branch "," locality "," "Encoder" "\"," }' $f | sed -n '/^  "2/p' >> "$shortname"
   awk -F, -v branch=$branch -v locality=$locality '{ print "  \"" $13 "\": \"" $4 "," $5 "," $10 "," $16 "," $33 "," $34 "," $35 "," $36 "," $40 ","$41 "," $43 "," branch "," locality "," "Output" "\"," }' $f | sed -n '/^  "2/p' >> "$shortname"

done

sed -i '$s/,$//' "$shortname"

echo "}" >> "$shortname"

cd ..

mv $shortname/$shortname ../dictionaries/$shortname.json && mv $masterfile $LSM_DIR && echo "SUCCESS!!!" && rm -rf $shortname && exit 0
