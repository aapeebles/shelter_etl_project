/*This query populates table cleaned_intakes_s1*/
with intake_data as
(
SELECT 
  animal_id,
  REPLACE(name,chr(42),'') as name,
  DATE(datetime) AS intake_date,
  animal_type,
  FORMAT_TIME('%R',TIME(datetime2)) AS intake_time,
  intake_type,
  intake_condition,
  IF(LOWER(TRIM(intake_condition))!='normal', 1,0) as needs_attention,
  if(LOWER(sex_upon_intake)='unknown','unknown', SPLIT(sex_upon_intake,' ')[SAFE_OFFSET(1)]) as sex,
  if(LOWER(sex_upon_intake)='unknown','unknown',IF(SPLIT(sex_upon_intake,' ')[OFFSET(0)] in ('Neutered', 'Spayed'), 'Neutered',SPLIT(sex_upon_intake,' ')[OFFSET(0)])) as reproductive_status_intake,
  CASE WHEN LEFT(SPLIT(age_upon_intake,' ')[SAFE_OFFSET(1)], 3) = 'day'
            THEN DATE_SUB(DATE(datetime), INTERVAL CAST(REGEXP_EXTRACT(age_upon_intake,r"[0-9]") AS INT64) DAY) 
      WHEN LOWER(LEFT(SPLIT(age_upon_intake,' ')[SAFE_OFFSET(1)], 3)) = 'mon' 
            THEN DATE_SUB(DATE(datetime), INTERVAL CAST(REGEXP_EXTRACT(age_upon_intake,r"[0-9]") AS INT64)  MONTH) 
      WHEN LEFT(SPLIT(age_upon_intake,' ')[SAFE_OFFSET(1)], 3) = 'wee' 
            THEN DATE_SUB(DATE(datetime), INTERVAL CAST(REGEXP_EXTRACT(age_upon_intake,r"[0-9]") AS INT64)  WEEK)
      ELSE DATE_SUB(DATE(datetime), INTERVAL CAST(REGEXP_EXTRACT(age_upon_intake,r"[0-9]") AS INT64)  YEAR) 
      END AS birth_date,
      breed  
 FROM `austin-animal-shelter-etl.austin_animal_shelter.raw_intakes` 
)
SELECT 
      CONCAT(intake_data.animal_id,"_",visits.rownum) as visit_id, 
      intake_data.*
FROM intake_data 
INNER JOIN (SELECT animal_id,
                  DATE(datetime) AS intake_date,
                  ROW_NUMBER() OVER ( PARTITION BY animal_id ORDER BY DATE(datetime) ) AS rownum
                  FROM `austin-animal-shelter-etl.austin_animal_shelter.raw_intakes`) AS visits
                  ON (intake_data.animal_id=visits.animal_id) AND (intake_data.intake_date=visits.intake_date)
ORDER BY intake_date desc;