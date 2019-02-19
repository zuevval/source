SELECT t_surn, t_name, t_name2, COUNT(mark_value), mark_value FROM university.teachers
JOIN university.marks 
ON university.teachers.t_no = university.marks.t_id
JOIN university.exams
ON university.exams.exm_id = university.marks.exm_id
WHERE YEAR(exm_date) = 2017
	AND MONTH(exm_date) BETWEEN 5 AND 10 #first session
GROUP BY t_id, mark_value
HAVING mark_value <=3
ORDER BY mark_value, COUNT(mark_value) DESC, t_surn