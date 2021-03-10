# Animal Shelter ETL Project
## By Alison Peebles Madigan
#### (While between jobs)

![doggo](https://images.pexels.com/photos/406014/pexels-photo-406014.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=640&w=426)

## Project GOALS:
- Create an automated ETL pipeline from data api to dashboard
- Create two dashboards
  - The first would be a "landing page" of who is currently in the shelter and their special needs. The target audience would be a shift manager or vet tech.
  - The second would be a "trends page," where someone more senior could see year over year trendsand potential inform more long term planning 
- Prefer scripting over point and click
- Learn **A LOT**

## Why the Austin Animal Center data?
I have three rescue dogs. Look at those stupid cute faces. 
[insert future picture here, imagine two bulldogs and a senior mutt in the meantime]

According to their own [webpage](https://www.austintexas.gov/department/about-austin-animal-center)

>Austin Animal Center provides shelter to more than 16,000 animals annually plus animal protection and pet resource services to Austin and unincorporated parts of Travis County. We accept stray and owned animals regardless of age, health, species or breed.

>Our goal is to place all adoptable animals in forever homes through adoption, foster care or rescue partner groups.

> Animal Services has numerous programs and partnerships designed to help pets in the shelter, in the community and in your home.

Sounds cool, right?

## Show me the data!
They are the only shelter in US (that I know of) that shares their intake and outcomes data publically. Both APIs can be found through the [offical City of Austin open data portal](https://data.austintexas.gov/browse?q=austin%20animal%20center&sortBy=relevance&utf8=%E2%9C%93)

## Project plan
While ever in flux, here is what I hope to acheive
 - [ ] create basic google cloud infrastructure
   - [X] create a storage bucket
   - [X] provision a tiny compute engine
   - [X] create a big query db
   - [X] activate DataPrep (Trifacta)
   - [ ] activate DataStudio
 - [X] get data from api to google storage 
 - [X] get data from gs to big query 
 - [X] do data clean/transform in DataPrep
 - [X] run DataPrep job
 - [X] automate data transfers from api through bigquery with `cron`, `bash`, and various `gsutil/bq` commands
 - [X] convert DataPrep wrangles to SQL **DONE!**
    - [X] chat with SQL SME to learn some best practices regarding staging, table naming, different flows, etc
 - [ ] contact animal center with questions about business logic **New!**
   - [ ] animals that only have outcomes and no intake, safe to remove?
   - [ ] what about the animals with intakes, but no outcomes, that are *years* old?
   - [ ] what is the capacity of the shelter? does animals being in foster count as not having an outcome? 
 - [ ] Update Flow 1 with updated business logic
 - [ ] Figure out SQL for summary tables in Flow 2 
 - [ ] have data pipeline fully go through scripts
 - [ ] create dashboards in DataStudio

Right now I'm on the Wrangles to SQL. Going to learn about temporary tables and ETL, baby!!
Will update this as I make progress.


### Directory Structure
```
.
├── ETL_DAG.PNG
├── README.md
├── fetch_data.sh                             # bash script that uses curl, sed, etc to get data from animal center api
├── load_data.sh                              # bash script that loads the raw api data into bigquery
├── run_queries.sh                            # this will be renamed "Flow_1" - it populates bigquery from the sql files
├── sql_scripts                               # the code does the ETL. I am keeping each table's sql in separate files
│   ├── animal_visit_history.sql
│   ├── clean_intakes.sql
│   ├── clean_outcomes.sql
│   ├── dates_table.sql
│   ├── in_shelter_now.sql
│   └── join_clean_tables.sql
└── wrangle_files                             # files downloaded from google dataprep recording transformations
    ├── animals_in_shelter.wrangle
    ├── first_clean_intakes.wrangle
    ├── first_clean_outcomes.wrangle
    ├── intake_outcome_records.wrangle
    └── joined_intake_outcomes.wrangle
```
    
