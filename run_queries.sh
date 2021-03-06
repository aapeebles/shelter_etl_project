#!/bin/bash
# this script will run the bulk of my etl

# creates dates table
bq query <./sql_scripts/dates_table.sql --use_legacy_sql=false

# creates cleaned_intakes_s1
bq query <./sql_scripts/clean_intakes.sql \
        -n=0 \
        --destination_table austin_animal_shelter.cleaned_intakes_s1 \
        --use_legacy_sql=false \
        --replace=true
