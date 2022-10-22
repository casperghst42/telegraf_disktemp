#!/usr/bin/env bash

# Runs smartctl to report current temperature of all disks.

JSON="["

DISKS=$(ls /dev/sd?)

for i in ${DISKS[@]} ; do
  # Get temperature from smartctl (requires root).
  TEMP=$(smartctl -l scttemp $i | grep '^Current Temperature:' | awk '{print $3}')
  MODEL=$(smartctl -i $i | grep "^Device Model:" | awk '{printf "%s %s", $3, $4}')
  CAPACITY=$(smartctl -i $i | grep "^User Capacity:" | awk '{print $3}' | sed 's/,//g' )
  SERIAL=$(smartctl -i $i | grep "^Serial Number:" | awk '{printf $3}')

  if [ ${TEMP:-0} -gt 0 ]
  then
    JSON=$(echo "${JSON}{")
    JSON=$(echo "${JSON}\"disk\":\"${i}\",")
    JSON=$(echo "${JSON}\"model\":\"${MODEL}\",")
    JSON=$(echo "${JSON}\"serial\":\"${SERIAL}\"")
    JSON=$(echo "${JSON}\"capacity\":\"${CAPACITY}\",")
    JSON=$(echo "${JSON}\"temperature\":${TEMP}")
    JSON=$(echo "${JSON}},")
  fi

done

# Remove trailing "," on last field.
JSON=$(echo ${JSON} | sed 's/,$//')

echo -e "${JSON}]"
