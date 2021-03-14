#!/bin/bash
# this script will run the bulk of my etl

# creates cleaned_intakes_s1
bq query -n=0 \
        --destination_table austin_animal_shelter.cleaned_intakes_s1 \
        --use_legacy_sql=false \
        --replace=true \
        "$(cat ~/bin/sql_scripts/clean_intakes.sql)"

# creates cleaned_outcomes_s1
bq query -n=0 \
        --destination_table austin_animal_shelter.cleaned_outcomes_s1 \
        --use_legacy_sql=false \
        --replace=true /
        "$(cat ~/bin/sql_scripts/clean_outcomes.sql)"

# creates joined_intakes_outcomes_s2
bq query-n=0 \
        --destination_table austin_animal_shelter.joined_intakes_outcomes_s2 \
        --use_legacy_sql=false \
        --replace=true \
        "$(cat ~/bin/sql_scripts/join_clean_tables.sql)"

# creates animal_history_records_s3
bq query -n=0 \
        --destination_table austin_animal_shelter.animal_history_records_s3 \
        --use_legacy_sql=false \
        --replace=true \
        "$(cat ~/bin/sql_scripts/animal_visit_history.sql)"

# creates animal_history_records_s3
bq query -n=0 \
        --destination_table austin_animal_shelter.animals_without_outcomes_s3 \
        --use_legacy_sql=false \
        --replace=true \
        "$(cat ~/bin/sql_scripts/in_shelter_now.sql)"

# creates intakes_outcomes_s3
bq query -n=0 \
        --destination_table austin_animal_shelter.intakes_outcomes_s3 \
        --use_legacy_sql=false \
        --replace=true \
       "$(cat ~/bin/sql_scripts/cleaned_intakes_outcomes.sql)"
