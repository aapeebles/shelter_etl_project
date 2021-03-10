WITH
  animal_join AS (
    SELECT A.*,
    B.outcome_date,
    B.outcome_time,
    B.outcome_type,
    B.outcome_subtype,
    B.reproductive_status_outcome
  FROM
    `austin-animal-shelter-etl.austin_animal_shelter.cleaned_intakes_s1` A
  FULL OUTER JOIN 
    
      `austin-animal-shelter-etl.austin_animal_shelter.cleaned_outcomes_s1` B
  ON
    A.visit_id = B.visit_id
  ORDER BY
    A.intake_date DESC,
    A.intake_time DESC)
SELECT
  *,
IF
  (outcome_date IS NOT NULL,
    DATE_DIFF(outcome_date,intake_date, DAY),
    NULL) AS days_in_shelter,
IF(reproductive_status_outcome IS NOT NULL, IF(reproductive_status_intake != reproductive_status_outcome, 1,0), NULL) as neutered_during_stay
FROM
  animal_join
ORDER BY
  intake_date DESC,
  intake_time DESC