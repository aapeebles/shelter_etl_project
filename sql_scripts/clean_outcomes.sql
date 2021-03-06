-- This query populates table cleaned_outcomes_s1
with  outcome_data as
(
SELECT 
  animal_id,
  REPLACE(name,chr(42),'') as name,
  DATE(datetime) AS outcome_date,
  FORMAT_TIME('%r',TIME(datetime)) AS outcome_time,
  outcome_type,
  outcome_subtype,
  if(LOWER(sex_upon_outcome)='unknown','unknown',IF(SPLIT(sex_upon_outcome,' ')[OFFSET(0)] in ('Neutered', 'Spayed'), 'Neutered',SPLIT(sex_upon_outcome,' ')[OFFSET(0)])) as reproductive_status_outcome
 FROM `austin-animal-shelter-etl.austin_animal_shelter.raw_outcomes` 
)
SELECT 
      CONCAT(outcome_data.animal_id,"_",visits.rownum) as visit_id,  outcome_data.*
FROM outcome_data 
INNER JOIN (SELECT animal_id,
                  DATE(datetime) AS outcome_date,
                  ROW_NUMBER() OVER ( PARTITION BY animal_id ORDER BY DATE(datetime) desc  ) AS rownum
                  FROM `austin-animal-shelter-etl.austin_animal_shelter.raw_outcomes`) AS visits
                  ON (outcome_data.animal_id=visits.animal_id) AND (outcome_data.outcome_date=visits.outcome_date)
ORDER BY outcome_date desc ;