from dbfunctions import dbQuery;
import time;

def measure3 (n):
    time100 = 0;
    for i in range(100):
        start = time.perf_counter()
        insertOne(1000*n+10+i, n);
        stop = time.perf_counter()
        time100 += stop - start;
    print ("insert one row: time = ")
    print( time100/100);

def measure4 (n):
    time100 = 0;
    for i in range(100):
        start = time.perf_counter()
        insertMulti(1000*n+10+i*4, n);
        stop = time.perf_counter()
        time100 += stop - start;
    print ("insert three rows: time = ")
    print( time100/100);

def measure5 (n):
    time100 = 0;
    for i in range(100):
        start = time.perf_counter()
        updateQuery(10*n*i, n);
        stop = time.perf_counter()
        time100 += stop - start;
    print ("update one row: time = ")
    print( time100/100);

def measure6 (n):
    time100 = 0;
    for i in range(100):
        start = time.perf_counter()
        updateMultiNKey(10*n*i, n);
        stop = time.perf_counter()
        time100 += stop - start;
    print ("update one row (not key): time = ")
    print( time100/100);

def measure7 (n):
    time100 = 0;
    for i in range(100):
        start = time.perf_counter()
        removeOne(10*n*i, n);
        stop = time.perf_counter()
        time100 += stop - start;
    print ("remove one row (search by key): time = ")
    print( time100/100);

def measure8 (n):
    time100 = 0;
    for i in range(100):
        start = time.perf_counter()
        removeOneNKey(10*n*(i+2), n);
        stop = time.perf_counter()
        time100 += stop - start;
    print ("remove one row (search not by key): time = ")
    print( time100/100);

def measure9 (n):
    time100 = 0;
    for i in range(100):
        start = time.perf_counter()
        removeMulti(10*n*(i+2), n);
        stop = time.perf_counter()
        time100 += stop - start;
    print ("remove three rows (search not by key): time = ")
    print( time100/100);

def removeOne (t_no, n):
    query_string = '{}{}{}{}{}'.format("DELETE FROM teachers",n,"k.teachers \
            WHERE (t_no = '",t_no,"');")
    query_rows_list = dbQuery(query_string);
    return query_rows_list;

def removeOneNKey (t_no, n):
    query_string = '{}{}{}{}{}'.format("DELETE FROM teachers",n,"k.teachers \
            WHERE (t_surn = 'surn",t_no,"');")
    query_rows_list = dbQuery(query_string);
    return query_rows_list;

def removeMulti (t_no, n):
    qsTotal = "";
    for i in range (9):
        query_string = '{}{}{}{}{}'.format("DELETE FROM teachers",n,"k.teachers \
            WHERE (t_surn = 'surn",t_no,"');")
        qsTotal += query_string;
        t_no += 1;
    query_rows_list = dbQuery(qsTotal);
    return query_rows_list;



def insertOne (t_no, n):
    query_string = '{}{}{}{}{}{}{}{}{}{}{}'.format("INSERT INTO teachers",n,"k.teachers \
            (t_no, t_surn, t_name, t_name2)\
            VALUES (",t_no,", 'surn",t_no,"', 'name",t_no,"', 'name2",t_no,"');");
    query_rows_list = dbQuery(query_string);
    return query_rows_list;
    
def insertMulti (t_no, n):
    qsTotal = "";
    for i in range (3):
        query_string = '{}{}{}{}{}{}{}{}{}{}{}'.format("INSERT INTO teachers",n,"k.teachers \
            (t_no, t_surn, t_name, t_name2)\
            VALUES (",t_no,", 'surn",t_no,"', 'name",t_no,"', 'name2",t_no,"');");
        qsTotal += query_string;
        t_no += 1;
    query_rows_list = dbQuery(qsTotal);
    return query_rows_list;

def updateQuery (t_no, n):
    query_string = '{}{}{}{}{}{}{}'.format("UPDATE teachers",n,"k.teachers\
        SET t_name = 'name", t_no + 1,"', t_name2 = 'name2100008'\
        WHERE (t_no = '",t_no,"');")
    query_rows_list = dbQuery(query_string);
    return query_rows_list;

def updateMultiNKey (t_no, n):
    qsTotal = "";
    for i in range (1):
        query_string = '{}{}{}{}{}{}{}'.format("UPDATE teachers",n,"k.teachers\
        SET t_name = 'name", t_no + 1,"', t_name2 = 'nameUpdateMultiNKey'\
        WHERE (t_surn = 'surn",t_no,"');")
        qsTotal += query_string;
        t_no += 1;
    query_rows_list = dbQuery(qsTotal);
    return query_rows_list;
