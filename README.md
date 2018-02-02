# delete-old-elastic-search-indices

Shell script that **deletes** Elastic Search indices older than given amount of days

It will send a number of `DELETE` requests to the host specified. Will preserve indexes newer than the number of days specified on parameter.

## Warning

This script will **REMOVE** Elastic Search indices **PERMANENTLY**. Use it with care and at your own risk.

## Note

The script assumes your indices are named on the following format: name-yyyy.mm.dd. E.g. `my-index-2018.02.02`

## Usage

Run the script with the host url as the first parameter and number of days as second parameter.

To delete indices from localhost:9200 older than 30 days:

```shell
./delete_indices_older_than_n_days.sh http://localhost:9200 30
```
