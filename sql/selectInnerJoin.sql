SELECT * FROM university.students 
INNER JOIN university.stud_to_grps 
ON university.stud_to_grps.stud_id=university.students.stud_id;