SELECT * 
	FROM university.disc_to_teachers JOIN  university.exams ON
	university.disc_to_teachers.d_id= university.exams.d_id
	WHERE d_year >= exm_date
SELECT * 
	FROM university.stud_to_grps JOIN  university.exams ON
	university.disc_to_teachers.d_id= university.exams.d_id
	WHERE d_year >= exm_date