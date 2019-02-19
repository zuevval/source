#ALTER TABLE university.students
	#ADD CONSTRAINT secKey1 UNIQUE (stud_surn, stud_name, stud_name2); #added
#ALTER TABLE university.marks
	#ADD CONSTRAINT secKey1 UNIQUE (stud_id, exm_id); #added
#ALTER TABLE university.teachers
	#ADD CONSTRAINT secKey1 UNIQUE (t_surn, t_name, t_name2); #added
#ALTER TABLE university.disc_to_teachers
	#ADD CONSTRAINT secKey1 UNIQUE (d_id, d_group, d_sem, d_year); #added
#ALTER TABLE university.stud_to_grps
	#ADD CONSTRAINT secKey1 UNIQUE (stud_id, gr_id, stud_semester, year_study); #added
#ALTER TABLE university.disc_to_teachers
#	ADD CONSTRAINT examInRightYear 
#		CHECK (
#			NOT EXISTS (
#				SELECT * 
#				FROM university.disc_to_teachers 
#				WHERE d_year >= 2016
#                ));
#ALTER TABLE university.disc_to_teachers
#	ADD CONSTRAINT examInRightYear1 
#		CHECK (
#			NOT EXISTS (
#				SELECT * 
#				FROM university.disc_to_teachers JOIN  university.exams ON
#				university.disc_to_teachers.d_id= university.exams.d_id
#				WHERE d_year >= exm_date
#               )); #done
#ALTER TABLE university.exams
#	ADD CONSTRAINT examInRightYear2 
#		CHECK (
#			NOT EXISTS (
#				SELECT * 
#				FROM university.disc_to_teachers JOIN  university.exams ON
#				university.disc_to_teachers.d_id= university.exams.d_id
#				WHERE d_year >= exm_date
#               )); #done