#groups by year
SELECT gr_id, students.stud_id, stud_surn, stud_name, stud_name2, stud_status
FROM university.students
JOIN university.stud_to_grps
ON university.students.stud_id = university.stud_to_grps.stud_id
WHERE year_study =2018
ORDER BY gr_id, stud_semester DESC, stud_surn, stud_name, stud_name2
#(?) add empty groups