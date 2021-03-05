# Animal Shelter ETL Project
## By Alison Peebles Madigan
### While between jobs

## Project GOALS:
- Create an automated ETL pipeline from data api to dashboard
- Create two dashboards
  - The first would be a "landing page" of who is currently in the shelter and their special needs. The target audience would be a shift manager or vet tech.
  - The second would be a "trends page," where someone more senior could see year over year trendsand potential inform more long term planning 
- Prefer scripting over point and click
- Learn **A LOT**

## Why the Austin Animal Shetler data?
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
   - [ ] activate dashboard software i forget the name of
 - [X] get data from api to google storage 
 - [X] get data from gs to big query 
 - [X] do data clean/transform in DataPrep
 - [X] run DataPrep job
 - [X] automate data transfers from api through bigquery with `cron`, `bash`, and various `gsutil/bq` commands
 - [ ] convert DataPrep wrangles to SQL
 - [ ] have data pipeline fully go through scripts
 - [ ] create dashboards
 - [ ] maybe email the animal shelter? 

Right now I'm on the Wrangles to SQL. Going to learn about temporary tables and ETL, baby!!
Will update this as I make progress.


### Directory Structure
```
├── ETL_DAG.PNG
├── README.md
├── fetch_data.sh
├── load_data.sh
├── run_queries.sh
├── sql_scripts
│   └── dates_table.sql
└── wrangle_files
    ├── animals_in_shelter.wrangle
    ├── first_clean_intakes.wrangle
    ├── first_clean_outcomes.wrangle
    ├── intake_outcome_records.wrangle
    └── joined_intake_outcomes.wrangle
```
    
