#!/bin/bash
# this script will run the bulk of my etl

# creates dates table
bq query <./sql_scripts/dates_table.sql --use_legacy_sql=false

# creates cleaned_intakes_s1
bq query <./sql_scripts/cleaned_intakes.sql \
    --destination_table austin_animal_shelter.cleaned_intakes_s1\
    --replace = true \
    --use_legacy_sql = false