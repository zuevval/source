from dbfunctions import dbQuery;
def queryExams(year):
    query_string = '{}{}{}{}{}'.format("\
        SELECT exm_type, YEAR(exm_date), MONTH(exm_date), DAY(exm_date), d_name \
        FROM university.exams\
        JOIN university.disc_to_teachers\
        USING (dtt_instance_id)\
        JOIN university.disciplines\
        USING (d_id)\
        WHERE exm_date BETWEEN '",year,"-01-01' AND '",year+1,"-01-01'\
        ORDER BY exm_date, exm_type");
    query_rows_list = dbQuery(query_string);
    return query_rows_list;

def queryGroups(year):
    query_string = '{}{}{}'.format("\
        SELECT gr_id, students.stud_id, stud_surn, stud_name, stud_name2, stud_status\
        FROM university.students\
        JOIN university.stud_to_grps\
        ON university.students.stud_id = university.stud_to_grps.stud_id\
        WHERE year_study =",year,"\
        ORDER BY gr_id, stud_semester DESC, stud_surn, stud_name, stud_name2");
    query_rows_list = dbQuery(query_string);
    return query_rows_list

def queryDropped(year, semester):
    """
    year is integer like 2016, 2017, 2018
    semester is short integer, 1 or 2
    """
    if semester == 3:
        where_string = '{}{}'.format("WHERE year_study = ",year);
    else:
        where_string = '{}{}{}{}'.format("WHERE year_study = ",year," AND stud_semester = ",semester-1);
    query_string = '{}{}{}'.format("\
        SELECT gr_id, students.stud_id, stud_surn, stud_name, stud_name2, stud_status\
        FROM university.students\
        JOIN university.stud_to_grps\
        ON university.students.stud_id = university.stud_to_grps.stud_id\
        ",where_string,"\
        ORDER BY gr_id, stud_semester DESC, stud_surn, stud_name, stud_name2");
    query_rows_list = dbQuery(query_string);
    return query_rows_list;

def queryEvilTeachers(year, semester, min_count, mark_value):
    """
    year is integer like 2016, 2017, 2018, or string 'ALL'
    semester is short integer, 1 or 2, or 3 (both semesters)
    """
    #min_count = 1
    #mark_value = 3
    if semester == 1:
        lower_month = 4;
        upper_month = 8;
    elif semester == 2:
        lower_month = 10;
        upper_month = 12;
    elif semester == 3: #both semesters
        lower_month = 4;
        upper_month = 12;

    if year == 'ALL':
        where_string = '{}{}{}{}{}{}'.format("\
            WHERE MONTH(exm_date) BETWEEN ",lower_month," AND ",upper_month," AND mark_value = ",mark_value);
    else:
        where_string = '{}{}{}{}{}{}{}{}'.format("\
            WHERE YEAR(exm_date) = ",year,"\
                AND MONTH(exm_date) BETWEEN ",lower_month," AND ",upper_month,' AND mark_value = ', mark_value);
    print(where_string);
    query_string = '{}{}{}{}{}'.format("\
        SELECT t_surn, t_name, t_name2, COUNT(mark_id), mark_value\
        FROM university.teachers\
        JOIN university.disc_to_teachers\
        USING (t_no)\
        JOIN university.exams\
        USING (dtt_instance_id)\
        JOIN university.marks\
        USING (exm_id)",
        where_string, "\
        GROUP BY teachers.t_no, mark_value\
        HAVING COUNT(mark_id) >= ",min_count,"\
        ORDER BY mark_value, COUNT(mark_value) DESC, t_surn");
    query_rows_list = dbQuery(query_string);
    return query_rows_list;

#queryExams(2016)
#queryGroups(2016)
#queryDropped(2016, 2)
#queryEvilTeachers(2017, 1)
