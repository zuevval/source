/*SELECT * FROM university.disc_to_teachers;
SET @d_name1 = 'maths';
SET @d_type1 = 't';
SET @date1 = '2017-11-25';
SET @t_id = 4;
SET @grp_id1 = 3;
SET @d_id1 = NULL;
SELECT d_id FROM university.disciplines 
WHERE d_name = @d_name1 LIMIT 1 INTO @d_id1;
INSERT INTO university.exams (exm_type, exm_date, d_id, exm_set) 
VALUES (@d_type1, @date1, @d_id1, 0);

SET @exm_id1 = NULL;
SELECT exm_id FROM university.exams 
ORDER BY exm_id DESC LIMIT 1
INTO @exm_id1;

INSERT INTO university.disc_to_teachers (d_group, exm_id, t_no)
VALUES (@grp_id1, @exm_id1, @t_id1);*/

SELECT d_group,  dtt_year, dtt_sem, t_no, exm_type, exams.exm_id, MONTH(exm_date), DAY(exm_date)
FROM university.exams
RIGHT JOIN university.disc_to_teachers
USING (dtt_instance_id)
JOIN university.disciplines
USING (d_id)
ORDER BY exm_date DESC, dtt_year DESC, dtt_sem DESC, d_group;
