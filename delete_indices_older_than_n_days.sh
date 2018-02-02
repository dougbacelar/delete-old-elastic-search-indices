#!/bin/bash

HOST_URL=$1
NUMBER_OF_DAYS=$2

# sending delete request to elastic to delete indices
deleteIndex(){
	printf  "\n\nDeleting index: $1\n"
	curl -X "DELETE" "$HOST_URL/$1"
	sleep 1
}

if ! [ $# -eq 2 ]; then
  printf "\n\nPlease run this script with the host url and number of days. E.g.\n\n"
	echo "To delete indices older than 30 days on localhost:"
	echo "./delete_indices_older_than_n_days.sh http://localhost:9200 30"
  exit 1
fi

if ! [ $NUMBER_OF_DAYS -gt 0 ]; then
  printf "\n\nInvalid number of days inserted. Choose a positive number.\n"
  exit 1
fi

printf "\n\nDeleting indexes older than $NUMBER_OF_DAYS days from $HOST_URL\n"

effectiveDate=$(date --date "-$NUMBER_OF_DAYS days" +'%Y.%m.%d')
printf "\n\neffectiveDate: $effectiveDate\n"

day=$(awk -F. '{print $3}' <<< $effectiveDate)
printf "\nday: $day"

month=$(awk -F. '{print $2}' <<< $effectiveDate)
printf "\nmonth: $month"

year=$(awk -F. '{print $1}' <<< $effectiveDate)
printf "\nyear: $year\n\n"

# removing any leading zeros in day variable
day=$(echo $day | sed 's/^0*//')

# deleting all indices from given day, until day 01
for((;day >= 1; day--))
{
	if [ $day -lt 10 ]; then
		index="*$year.$month.0$day"
	else
		index="*$year.$month.$day"
	fi

	deleteIndex $index
}

# removing any leading zeros in month variable
month=$(echo $month | sed 's/^0*//')

# deleting all indices from given month, until month 01
for((month--;month >= 1; month--))
{
	if [ $month -lt 10 ]; then
		index="*$year.0$month.*"
	else
		index="*$year.$month.*"
	fi

	deleteIndex $index
}

# removing previous 3 years of indices
for((counter=3, year--; counter > 0; year--, counter--))
{
	index="*$year.*.*"
	deleteIndex $index
}
