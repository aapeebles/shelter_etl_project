/*This code creates the dates table using the min date from intakes
First, create and define min_date_var*/
DECLARE min_date_var DATE;
SET min_date_var = (
  SELECT
    MIN(DATE(datetime)) AS min_date
  FROM
    `austin-animal-shelter-etl.austin_animal_shelter.raw_intakes`);

--Make date table
CREATE OR REPLACE TABLE `austin-animal-shelter-etl.austin_animal_shelter.dates_table_s1` AS
SELECT
  FORMAT_DATE('%F', d) AS id,
  d AS full_date,
  EXTRACT(YEAR
  FROM
    d) AS year,
  EXTRACT(WEEK
  FROM
    d) AS year_week,
  EXTRACT(DAY
  FROM
    d) AS year_day,
  EXTRACT(YEAR
  FROM
    d) AS fiscal_year,
  FORMAT_DATE('%Q', d) AS fiscal_qtr,
  EXTRACT(MONTH
  FROM
    d) AS month,
  FORMAT_DATE('%B', d) AS month_name,
  FORMAT_DATE('%w', d) AS week_day,
  FORMAT_DATE('%A', d) AS day_name,
  (CASE
      WHEN FORMAT_DATE('%A', d) IN ('Sunday', 'Saturday') THEN 0
    ELSE
    1
  END
    ) AS day_is_weekday,
FROM (
  SELECT
    *
  FROM
    UNNEST(GENERATE_DATE_ARRAY(min_date_var, current_date, INTERVAL 1 DAY)) AS d )
ORDER BY full_date desc;