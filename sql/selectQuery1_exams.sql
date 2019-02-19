#exams by year
SELECT exm_type, exm_date, d_name 
FROM university.exams
JOIN university.disciplines
ON university.exams.d_id = university.disciplines.d_id
WHERE exm_date BETWEEN '2016-01-01' AND '2017-01-01'
ORDER BY exm_date, exm_type
#to add average score
#(?) add exams related to groups using UNION and DISTINCT