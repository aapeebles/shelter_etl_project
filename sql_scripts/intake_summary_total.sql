DECLARE
  intake_sum STRING;
DECLARE
  animal_type_sum STRING;
/* dynamicaly creates query that interates over intake type values so I do not have to type in each column name.
-- I'm not sure if creating permanent tables in the right way to go. */
SET
  intake_sum = (
  SELECT
    CONCAT('CREATE OR REPLACE TABLE `austin-animal-shelter-etl.austin_animal_shelter.temp_animal_intake_type_summary` AS SELECT intake_date, ', STRING_AGG( CONCAT('COUNTIF(intake_type = "', intake_type, '") AS intake_', LOWER(REPLACE(intake_type, " ", "_"))) ), ' FROM `austin-animal-shelter-etl.austin_animal_shelter.intakes_outcomes_s3` GROUP BY intake_date ORDER BY intake_date desc')
  FROM (
    SELECT
      intake_type
    FROM
      `austin-animal-shelter-etl.austin_animal_shelter.intakes_outcomes_s3`
    GROUP BY
      intake_type ));
-- dynamicaly creates query that interates over animal type values so I do not have to type in each column name.
SET
  animal_type_sum = (
  SELECT
    CONCAT('CREATE OR REPLACE TABLE `austin-animal-shelter-etl.austin_animal_shelter.temp_animal_intake_summary` AS SELECT intake_date, ', STRING_AGG( CONCAT('COUNTIF(animal_type = "', animal_type, '") AS animal_', LOWER(REPLACE(animal_type, " ", "_"))) ), ' FROM `austin-animal-shelter-etl.austin_animal_shelter.intakes_outcomes_s3` GROUP BY intake_date ORDER BY intake_date desc')
  FROM (
    SELECT
      animal_type
    FROM
      `austin-animal-shelter-etl.austin_animal_shelter.intakes_outcomes_s3`
    GROUP BY
      animal_type ));
-- using execute to run those queries. 
EXECUTE IMMEDIATE
  animal_type_sum;
EXECUTE IMMEDIATE
  intake_sum;
-- now I do a massive join to get all of those tables together
SELECT
  a.*,
  b.intake_abandoned,
  b.intake_euthanasia_request,
  b.intake_owner_surrender,
  b.intake_public_assist,
  b.intake_stray,
  b.intake_wildlife,
  c.needs_attention,
  d.total_intake,
  e.year,
  e.month,
  e.month_name,
  e.fiscal_year,
  e.fiscal_qtr,
  e.week_day,
  e.day_name,
  e.day_is_weekday
FROM
  `austin-animal-shelter-etl.austin_animal_shelter.temp_animal_intake_summary` a
INNER JOIN
  `austin-animal-shelter-etl.austin_animal_shelter.temp_animal_intake_type_summary` b
ON
  a.intake_date = b.intake_date
INNER JOIN (
  SELECT
    intake_date,
    SUM(needs_attention) AS needs_attention,
  FROM
    `austin-animal-shelter-etl.austin_animal_shelter.intakes_outcomes_s3`
  GROUP BY
    intake_date
  ORDER BY
    intake_date DESC ) c
ON
  a.intake_date = c.intake_date
INNER JOIN (
  SELECT
    intake_date,
    COUNT(visit_id) AS total_intake,
  FROM
    `austin-animal-shelter-etl.austin_animal_shelter.intakes_outcomes_s3`
  GROUP BY
    intake_date
  ORDER BY
    intake_date DESC ) d
ON
  a.intake_date = d.intake_date
INNER JOIN  `austin-animal-shelter-etl.austin_animal_shelter.dates_table_s1` e
ON a.intake_date = e.full_date
ORDER BY
  a.intake_date DESC;