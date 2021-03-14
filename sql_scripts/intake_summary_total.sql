#standardSQL
DECLARE
  intake_sum STRING;
DECLARE
  animal_type_sum STRING;
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
EXECUTE IMMEDIATE
  animal_type_sum;
EXECUTE IMMEDIATE
  intake_sum;
SELECT
  a.*,
  b.intake_abandoned,
  b.intake_euthanasia_request,
  b.intake_owner_surrender,
  b.intake_public_assist,
  b.intake_stray,
  b.intake_wildlife,
  c.needs_attention,
  d.total_intake
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
ORDER BY
  a.intake_date DESC;