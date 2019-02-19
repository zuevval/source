<?php
//requires php 5.x
echo json_encode(0);
$db_host = 'localhost';
$db_user = 'root';
$db_pwd = '';
$database = 'time-forward';

if (!mysql_connect($db_host, $db_user, $db_pwd))
    die("Can't connect to database");
if (!mysql_select_db($database))
    die("Can't select database");
$group_id=$_COOKIE["group_id"];
$day=$_COOKIE["day"];
$table= "grp_".$group_id."_timetable";
$tmtbl_res = mysql_query("SELECT * FROM {$table} WHERE day=$day");
if (!$tmtbl_res) {
    die("Query to show fields from table failed");
}
$timetable = mysql_fetch_row($tmtbl_res);
foreach($timetable as $cell){
    echo $cell."*";
}
?>