#!/bin/bash

# Beats Registry Cleaner

# Short and sweet script to reconstruct the registry file with only the files that exist within the registry.

#reg_path="/var/lib/beats/registry"
registry_entries=$(cat $reg_path | sed 's/}},/}},\n/g')

match=0

# Start JSON array
echo -n "{"
for reg in $registry_entries;
do

  # clean-up registry entry line
  entry=$(echo $reg | sed 's/^{//g' | sed 's/}}}/}}/g' | sed 's/}},/}}/g')

  # parse out filename
  fname=$(echo $entry | cut -d":" -f1 | sed 's/"//g')

  # see if file exists
  if [ -e "$fname" ];
  then
    #echo "File exists"
    if [ $match -eq 0 ]
    then
      match=1;
      echo -n "$entry";
    else
      echo -n ",$entry";
    fi
  fi
done;

# End JSON array
echo -n "}"
