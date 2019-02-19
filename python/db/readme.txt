---required software:---

Python 3.5 or 3.6
MySQL Server v 5.0 or higher
MySQL Connector Python for Python 3.5
PyQT5 graphic library (terminal command: pip install pyqt5)

You can install python 3.6.7, MySQL Connector Python
from 'dist' folder of this package

A working SQL schema named "university" with all necessary tables
must be created on local MySQL server
To load schema, run uni98.sql from "db_dumps" folder
on your local MySQL server
using SQL command line commands:

CREATE DATABASE database_name
USE database_name
source path/to/file (for example, D:/dataVal/Work/SPbSTU/Databases/db_dumps/uni98.sql)

Then write correct parameters in config.ini
 
To run a program, launch application.py

To remove a database from your SQL server, type
drop database database_name
in SQL command line