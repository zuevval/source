import mysql.connector
from mysql.connector import MySQLConnection, Error
from configparser import ConfigParser

def read_db_config(filename='config.ini', section='mysql'):
    """ Read database configuration file and return a dictionary object
    :param filename: name of the configuration file
    :param section: section of database configuration
    :return: a dictionary of database parameters
    """
    # create parser and read ini configuration file
    parser = ConfigParser()
    parser.read(filename)
 
    # get section, default to mysql
    db = {}
    if parser.has_section(section):
        items = parser.items(section)
        for item in items:
            db[item[0]] = item[1]
    else:
        raise Exception('{0} not found in the {1} file'.format(section, filename))
 
    return db

def query1(tablename, columns):
    """Queries a database with parameters from config.ini
    SELECT <columns> FROM <tablename>
    returns an array of rows
    """
    query_string = '{}{}{}{}'.format("SELECT ", columns, " FROM ", tablename)
    query_rows = [];
    try:
        dbconfig = read_db_config()
        conn = MySQLConnection(**dbconfig)
        cursor = conn.cursor()
        cursor.execute(query_string)

        row = cursor.fetchone()

        while row is not None:
            query_rows.append(list(row))
            row = cursor.fetchone()

    except Error as e:
        print(e)

    finally:
        cursor.close()
        conn.close()
    return list(query_rows);

def dbQuery(query_string):
    """Queries a database with parameters from config.ini
    with query string
    returns an array of rows
    """
    query_rows = [];
    try:
        dbconfig = read_db_config()
        conn = MySQLConnection(**dbconfig)
        cursor = conn.cursor()
        cursor.execute(query_string)

        row = cursor.fetchone()

        while row is not None:
            query_rows.append(list(row))
            row = cursor.fetchone()

    except Error as e:
        print(e)

    finally:
        cursor.close()
        conn.close()
    return list(query_rows);

def dbInsertQuery(query_string):
    """Queries a database with parameters from config.ini
    with query string
    """
    try:
        dbconfig = read_db_config()
        conn = MySQLConnection(**dbconfig)
        cursor = conn.cursor()
        cursor.execute(query_string)
        conn.commit()

    except Error as e:
        print(e)

    finally:
        cursor.close();
        conn.close();

