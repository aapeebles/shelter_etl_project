select *,
date_diff(outcome_date, birth_date, YEAR) as age_years,
date_diff(outcome_date, birth_date, MONTH) as age_months,
date_diff(outcome_date, birth_date, DAY) as age_days
from `austin-animal-shelter-etl.austin_animal_shelter.joined_intakes_outcomes_s2`
where outcome_date IS NOT NULL AND intake_date IS NOT NULL
ORDER BY
  intake_date DESC,
  intake_time DESC