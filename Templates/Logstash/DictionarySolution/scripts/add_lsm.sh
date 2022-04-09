#!/usr/bin/bash



if [ $3 -eq $NULL ]
then
   echo "USAGE: ./add_lsm.sh LSMFILE.xlsx X.X.00 YYYYMMDDHHMM"
   exit 0
fi

if [ ${#3} -ne 12 ]
then
   echo "Something wrong with the date.... "
   echo "USAGE: ./add_lsm.sh LSMFILE.xlsx X.X.00 YYYYMMDDHHMM"
   exit 0
fi

if [ ! -e $1 ]
then
   echo "File name correct?  I don't see that file... $1"
   echo "USAGE: ./add_lsm.sh LSMFILE.xlsx X.X.00 YYYYMMDDHHMM"
   exit 0
fi

masterfile=$1
shortname=$2
datedict=$3

echo "Creating new dictionary from LSM"

./lsm_prod_gen.sh $masterfile $shortname $datedict

if [ $? -eq 0 ]
then
   echo "Success!"
   ./dict_index.sh $shortname $datedict

   if [ $? -eq 0 ]
   then
      echo "Success!"
      exit 0
   else
   echo "Uh oh, couldn't create the index in the range config.. call for help!"
   exit 1
   fi

else
   echo "Uh oh... could not generate LSM... better get help!"
   exit 1
fi


