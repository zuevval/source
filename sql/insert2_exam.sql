SET @id1 = 20;
SET @year1 = NULL;
SELECT dtt_year FROM university.disc_to_teachers
WHERE dtt_instance_id = @id1;
SET @date1 = '2017-11-07';
INSERT INTO university.exams (exm_type, exm_date, dtt_instance_id)
VALUES ('t', @date1, @id1); 