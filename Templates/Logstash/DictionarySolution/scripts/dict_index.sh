#!/usr/bin/bash

if [ $2 -eq $NULL ]
then
   echo "./dict_index.sh X.X.00 YYYYMMDDHHMM"
   exit 1
fi

shortname=$1
datedict=$2

indexpath="../conf.d/131-filter-range.conf"
newindex="../conf.d/newindex.conf"

#stcurrent - Start Time Current
#etcurrent - End Time Current
#stlast - Start Time Last run
#etlast - End Time Last run
#vercur - Version Current
#verlast - Version Previous

stcurrent=0
etcurrent=0
stlast=0
etlast=0
vercur="0"
verlast="0"
theend=999999999999

rm -f $newindex

while read -r line
do

if [ $(echo $line | awk '{print NF}') -ne 4 ]
then
  echo $line >> $newindex
else
  stlast=$stcurrent
  etlast=$etcurrent
  verlast=$vercur

  stcurrent=${line:12:12}
  etcurrent=${line:26:12}
  vercur=${line:54:6}

echo "$stcurrent, $etcurrent, $vercur"

  #Sanity
  if [ $stcurrent -gt $etcurrent ]
	then
	echo "Something not right... Start: $stcurrent End: $etcurrent"
	rm $newindex
	exit 1
  fi

  #BAU
  if [ $stcurrent -gt $datedict ] || [ $etcurrent -lt $datedict ]
	then
	echo $line >> $newindex
  fi

  #Insert new LSM dict stuff
  if [ $stcurrent -lt $datedict ] && [ $etcurrent -gt $datedict ]
	then

	if [ $etcurrent -eq $theend ]
	then
	echo "Found the end"
	let 'etnew=datedict-1'
	echo "\"datedict\", "$stcurrent", "$etnew", \"field:lsmver:"$vercur"\"," >> $newindex
	echo "\"datedict\", "$datedict", "$theend", \"field:lsmver:"$shortname"\"" >> $newindex
	
	else 
	echo "Not most recent... better check the dates"
	rm $newindex
	exit 1
	fi
	
  fi
  
fi

done < $indexpath

tar -czvf "../backups/$(date '+%y-%m-%d')filter-range.tar.gz" $indexpath && mv $newindex $indexpath && exit 0
