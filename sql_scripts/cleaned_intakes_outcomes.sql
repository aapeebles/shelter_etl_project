/*Removes records that only have outcome data*/
select * 
from `austin-animal-shelter-etl.austin_animal_shelter.joined_intakes_outcomes_s2`
where intake_date IS NOT NULL;