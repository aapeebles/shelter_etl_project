#!/bin/bash
# this script will run the bulk of my etl

# creates cleaned_intakes_s1
bq query <./sql_scripts/clean_intakes.sql \
        -n=0 \
        --destination_table austin_animal_shelter.cleaned_intakes_s1 \
        --use_legacy_sql=false \
        --replace=true

# creates cleaned_outcomes_s1
bq query <./sql_scripts/clean_outcomes.sql \
        -n=0 \
        --destination_table austin_animal_shelter.cleaned_outcomes_s1 \
        --use_legacy_sql=false \
        --replace=true

# creates joined_intakes_outcomes_s2
bq query <./sql_scripts/join_clean_tables.sql \
        -n=0 \
        --destination_table austin_animal_shelter.joined_intakes_outcomes_s2 \
        --use_legacy_sql=false \
        --replace=true

# creates animal_history_records_s3
bq query <./sql_scripts/animal_visit_history.sql \
        -n=0 \
        --destination_table austin_animal_shelter.animal_history_records_s3 \
        --use_legacy_sql=false \
        --replace=true

# creates animal_history_records_s3
bq query <./sql_scripts/in_shelter_now.sql \
        -n=0 \
        --destination_table austin_animal_shelter.animals_without_outcomes_s3 \
        --use_legacy_sql=false \
        --replace=true

# creates intakes_outcomes_s3
bq query <./sql_scripts/cleaned_intakes_outcomes.sql \
        -n=0 \
        --destination_table austin_animal_shelter.intakes_outcomes_s3 \
        --use_legacy_sql=false \
        --replace=true
