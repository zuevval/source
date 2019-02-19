from dbfunctions import dbQuery, dbInsertQuery;
def defineLecturers_overview() :
    query_string = "\
        SELECT d_group,  dtt_year, dtt_sem, t_no, exm_type,\
        d_name,\
        exams.exm_id, MONTH(exm_date), DAY(exm_date), dtt_instance_id\
        FROM university.exams\
        RIGHT JOIN university.disc_to_teachers\
        USING (dtt_instance_id)\
        JOIN university.disciplines\
        USING (d_id)\
        ORDER BY exm_date DESC, dtt_year DESC, dtt_sem DESC, d_group;";
    query_rows_list = dbQuery(query_string);
    return query_rows_list;

def defineLecturers(year, semester, d_id, t_no, gr_id):
    """
    Example: d_type = 't', year = 2017, semester = 2, d_id = 2
    t_no = 4, gr_id = 3
    """
    query_string ='INSERT INTO university.disc_to_teachers\
        (d_group, t_no, d_id, dtt_year, dtt_sem)\
        VALUES ({}, {}, {}, {}, {});'.format(gr_id, t_no, d_id, year, semester);
    return dbInsertQuery(query_string);

def defLectrComboGrps():
    query_string = "SELECT CONCAT(d_id, '-', d_name) FROM university.disciplines\
        ORDER BY d_id"
    query_rows_list = dbQuery(query_string)
    return query_rows_list

def defineExamPreview ():
    #yet unused
    res = defineLecturers_overview();
    return res;

def defineExam (dtt_instance_id, day, month, exm_type):
    query_string = 'SELECT dtt_year FROM university.disc_to_teachers\
        WHERE dtt_instance_id = {};'.format(dtt_instance_id);
    year = dbQuery(query_string);
    year = year[0][0];
    date = '{}-{}-{}'.format(year, month, day);
    print(date);
    query_string = 'INSERT INTO university.exams (exm_type, exm_date, dtt_instance_id)\
        VALUES (\'{}\', \'{}\', {});'.format(exm_type, date, dtt_instance_id);
    dbInsertQuery(query_string);
    return year;

def insertMarkPreview ():
    query_string = "SELECT\
        CONCAT(d_group, \" (\", gr_spec, \")\"),\
        d_name,\
        CONCAT(marks.exm_id, \" (\", exm_type, \")\"),\
        CONCAT(DAY(exm_date), \"-\", MONTH(exm_date),\"-\", YEAR(exm_date)),\
        CONCAT(t_no, \" - \", t_surn, \" \", t_name, \" \", t_name2),\
        CONCAT(students.stud_id, \" - \", stud_surn, \" \", stud_name, \" \",\
        if (stud_name2 is null, '', stud_name2)),\
        mark_value\
        FROM university.exams\
        JOIN university.disc_to_teachers\
        USING (dtt_instance_id)\
        JOIN university.disciplines\
        USING (d_id)\
        JOIN university.teachers\
        USING (t_no)\
        JOIN university.marks\
        USING (exm_id)\
        JOIN university.uni_groups\
        ON university.uni_groups.gr_id = university.disc_to_teachers.d_group\
        JOIN university.students\
        USING (stud_id)\
        ORDER BY exm_date, d_name, gr_spec, marks.stud_id;"
    query_rows_list = dbQuery(query_string);
    return query_rows_list;

def insertMarkCombo1 ():
    query_string = "SELECT exm_id,\
        concat(exm_id,' - ', d_name, '; type ', exm_type,\
        '; group ', d_group, '; ', exm_date),\
        d_group\
        FROM university.exams\
        JOIN university.disc_to_teachers\
        USING (dtt_instance_id)\
        JOIN university.disciplines\
        USING (d_id)\
        ORDER BY exm_id;"
    query_rows_list = dbQuery(query_string);
    return query_rows_list;

def insertMarkCombo2 (gr_id):
    query_string = "SELECT stud_id,\
        concat(stud_id, ' - ',\
        stud_surn, ' ', stud_name, ' ', if (stud_name2 is null, '', stud_name2),\
        ' (status: ', stud_status,')')\
        FROM university.students\
        JOIN university.stud_to_grps\
        USING (stud_id)\
        WHERE gr_id = "
    query_string = '{}{};'.format(query_string, gr_id);
    query_rows_list = dbQuery(query_string);
    return query_rows_list;

def combo3 ():
    query_string = "SELECT t_no,\
        concat(t_no, ' - ', t_surn, ' ', t_name, ' ', t_name2)\
        FROM university.teachers\
        ORDER BY t_no;"
    query_rows_list = dbQuery(query_string);
    return query_rows_list;

def insertMark(mark_value, stud_id, exm_id):
    query_string = 'INSERT INTO university.marks (mark_value, stud_id, exm_id)\
VALUES ({}, {}, {})'.format(mark_value, stud_id, exm_id)
    return dbInsertQuery(query_string);

def dropStudentsPreview():
    query_string = "SELECT students.*, marks.exm_id, mark_value, exm_type,\
        CONCAT(DAY(exm_date), \"-\", MONTH(exm_date),\"-\", YEAR(exm_date))\
        FROM university.marks\
        JOIN university.students\
        ON students.stud_id = marks.stud_id\
        JOIN university.exams\
        ON marks.exm_id=exams.exm_id\
        WHERE mark_value < 3;"
    query_rows_list = dbQuery(query_string);
    return query_rows_list;

def dropStudent (stud_id):
    query_string = 'UPDATE university.students\
        SET stud_status = \'d\' WHERE stud_id = {};'.format(stud_id);
    dbInsertQuery(query_string);
    

"""
defineLecturers(2017, 1, 1, 4, 2)
defineLecturers_overview()
defineExamPreview ()
defineExam (5, 2, 1, 't')
insertMarkPreview ()
insertMarkCombo1 ()
insertMarkCombo2 (1)
insertMark(2, 5, 1)
dropStudentsPreview()
dropStudent (3)
"""
