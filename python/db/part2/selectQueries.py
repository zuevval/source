from dbfunctions import dbQuery;
import time;

def measure1(n):
    #time.process_time() for some reasons shows strange results
    keyFieldTime = 0;
    for i in range(100):
        start = time.perf_counter()
        keyFieldQuery(10*i*n, n);
        stop = time.perf_counter()
        keyFieldTime += stop - start;
    print ("key field select query: time = ")
    print( keyFieldTime/100);
    NKFTime = 0;
    for i in range(100):
        start = time.perf_counter()
        notKFQuery(10*i*n, n);
        stop = time.perf_counter()
        NKFTime += stop - start;
    print ("non-key field select query: time = ")
    print(NKFTime/100);

def measure2 (n):
    maskQueryTime = 0;
    for i in range(100):
        start = time.perf_counter()
        maskQuery(i*n, n);
        stop = time.perf_counter()
        maskQueryTime += stop - start;
    print ("not key field select query with mask: time = ")
    print( maskQueryTime/100);

def measure10 (n):
    time100 = 0;
    start = time.perf_counter()
    optimize(n);
    stop = time.perf_counter()
    time100 += stop - start;
    print ("optimize: time = ")
    print( time100/100);

def maskQuery(lastDigits, n):
    query_string = '{}{}{}{}{}'.format("\
        SELECT * \
        FROM teachers",n,"k.teachers \
        WHERE t_surn LIKE '%",lastDigits,"';")
    query_rows_list = dbQuery(query_string);
    return query_rows_list;

def keyFieldQuery(t_no, n):
    query_string = '{}{}{}{}{}'.format("\
        SELECT *\
        FROM teachers",n,"k.teachers\
        WHERE t_no =",t_no,";");
    query_rows_list = dbQuery(query_string);
    return query_rows_list;

def notKFQuery(t_no, n):
    query_string = '{}{}{}{}{}'.format("\
        SELECT *\
        FROM teachers",n,"k.teachers\
        WHERE t_name ='name",t_no,"';");
    query_rows_list = dbQuery(query_string);
    return query_rows_list;

def optimize(n):
    query_string = '{}{}{}'.format("\
        OPTIMIZE TABLE teachers",n,"k.test_table;");
    print(query_string);
    query_rows_list = dbQuery(query_string);
    return query_rows_list;

#maskQuery(200, 10)
#keyFieldQuery(1000, 1)
#notKFQuery(1000, 1)
#measure(1)
#optimize()
