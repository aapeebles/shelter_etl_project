#!/bin/bash
# loads data from gs into big query

# load raw_intakes into big query
bq load --source_format=CSV \
       	--skip_leading_rows=1 \
		--replace=true \
	austin_animal_shelter.raw_intakes \
	gs://shelter-etl-data-folder/raw_intakes.csv 

# load raw_outcomes into big query
bq load --source_format=CSV \
	--skip_leading_rows=1 \
	--replace=true \
	austin_animal_shelter.raw_outcomes \
	gs://shelter-etl-data-folder/raw_outcomes.csv 

# creates dates table
bq query <~/bin/sql_scripts/dates_table.sql --use_legacy_sql=false --replace=true 

