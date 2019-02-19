SELECT students.*, marks.exm_id, exm_type, CONCAT(DAY(exm_date), "-", MONTH(exm_date),"-", YEAR(exm_date)), mark_value
FROM university.marks
JOIN university.students
ON students.stud_id = marks.stud_id
JOIN university.exams
ON marks.exm_id=exams.exm_id
WHERE mark_value < 3;

/*SET @stud_id1 = 7;
UPDATE university.students
SET stud_status = 'd' WHERE stud_id = @stud_id1;*/