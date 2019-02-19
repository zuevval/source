SELECT d_group, gr_spec, d_name, marks.exm_id, exm_type, exm_date, t_no, t_surn, t_name, t_name2, students.stud_id, stud_surn, stud_name, stud_name2, mark_id, mark_value
FROM university.exams
JOIN university.disc_to_teachers
USING (dtt_instance_id)
JOIN university.disciplines
USING (d_id)
JOIN university.teachers
USING (t_no)
JOIN university.marks
USING (exm_id)
JOIN university.uni_groups
ON university.uni_groups.gr_id = university.disc_to_teachers.d_group
JOIN university.students
USING (stud_id)
ORDER BY exm_date, d_name, gr_spec, marks.stud_id;

#mark some fields as "do not fill. Filled automatically"
#@stud_id1, @gr_id1 : @gr_id1 = gr_id FROM university.stud_to_grps WHERE stud_id = @stud_id1 
/*SET @exm_id1 = 4;
SET @t_id1 = 4;
SET @stud_id1 = 4;
SET @mark_value1 = 3;
INSERT INTO university.marks (mark_value, stud_id, exm_id)
VALUES (@mark_value1, @stud_id1, @exm_id1, @t_id1);*/