#dropped students by session
SELECT gr_id, students.stud_id, stud_surn, stud_name, stud_name2, stud_status
FROM university.students
JOIN university.stud_to_grps
ON university.students.stud_id = university.stud_to_grps.stud_id
WHERE year_study = 2016 AND stud_semester = 1 #0 in first session, 1 in second
ORDER BY gr_id, stud_semester DESC, stud_surn, stud_name, stud_name2