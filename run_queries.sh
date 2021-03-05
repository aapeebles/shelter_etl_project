#!/bin/bash
# this script will run the bulk of my etl

# creates dates table
bq query <./sql_scripts/dates_table.sql --use_legacy_sql=false