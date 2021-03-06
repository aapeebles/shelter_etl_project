-- Just the starting code
SELECT *
FROM `austin-animal-shelter-etl.austin_animal_shelter.cleaned_intakes_s1` A
 FULL OUTER JOIN 
 `austin-animal-shelter-etl.austin_animal_shelter.cleaned_outcomes_s1` B 
 ON A.visit_id = B.visit_id
 ORDER BY A.intake_date desc 