select visit_id,
        animal_id,
        name,
        animal_type,
        intake_date,
        intake_time,
        intake_type,
        intake_condition,
        needs_attention,
        sex,
        reproductive_status_intake,
        birth_date,
        breed,        
        date_diff(intake_date, birth_date, YEAR) as age_years,
        date_diff(intake_date, birth_date, MONTH) as age_months,
        date_diff(intake_date, birth_date, DAY) as age_days
from `austin-animal-shelter-etl.austin_animal_shelter.joined_intakes_outcomes_s2`
where outcome_date IS NULL AND intake_date IS NOT NULL
ORDER BY
  intake_date DESC,
  intake_time DESC