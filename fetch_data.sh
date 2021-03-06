#!/bin/bash
# Get dynamic record count numbers for each
intake_rec=$(curl -s 'https://data.austintexas.gov/resource/wter-evkm.json?$select=count(*)'| jq -r '.[0].count')
outcome_rec=$(curl -s 'https://data.austintexas.gov/resource/9t4d-g238.json?$select=count(*)'| jq -r '.[0].count')

echo "The income file has ${intake_rec} records"
echo "The outcome file has ${outcome_rec} records"

# get all of the intake info and create raw_intakes.csv
curl "https://data.austintexas.gov/resource/wter-evkm.csv?\$offset=[0-$intake_rec:1000]" -O -s
cat *wter* > raw_intakes.csv
rm *wter*
echo "Intake file created"
read -r FIRSTLINE < raw_intakes.csv
sort -u raw_intakes.csv>raw_intakes2.csv
sed -i '/datetime/d' raw_intakes2.csv
sed -i "1s/^/$FIRSTLINE\n/" raw_intakes2.csv
wc -l raw_intakes2.csv
gsutil cp raw_intakes2.csv gs://shelter-etl-data-folder/raw_intakes.csv

# get all of the outcomes info and create raw_outcomes.csv
curl "https://data.austintexas.gov/resource/9t4d-g238.csv?\$offset=[0-$outcome_rec:1000]" -O -s
cat *g238* > raw_outcomes.csv
rm *g238*
echo "Outcome file created"
read -r FIRSTLINE < raw_outcomes.csv
sed -i '/datetime/d' raw_outcomes.csv
sed -i "1s/^/$FIRSTLINE\n/" raw_coutcomes.csv
sort -u raw_outcomes.csv>  raw_coutcomes2.csv
wc -l raw_outcomes2.csv
gsutil cp raw_outcomes2.csv gs://shelter-etl-data-folder/raw_outcomes.csv



rm *.csv
