<?php
//requires php 5.x
$db_host = 'localhost';
$db_user = 'zuevzuevva';
$db_pwd = 'verystrongpass';
$database = 'zuevzuevva';

if (!mysql_connect($db_host, $db_user, $db_pwd))
    die("Can't connect to database");
if (!mysql_select_db($database))
    die("Can't select database");
$pass=$_COOKIE["pass"];
$login=$_COOKIE["login"];
$table='users';
$usr_res = mysql_query("SELECT * FROM {$table} WHERE login='$login' AND pass='$pass'");
if (!$usr_res) {
    die("Query to show fields from table failed");
}
$user_data = mysql_fetch_array($usr_res);
echo json_encode(0);
//echo $user_data['group_id'];
$table1 = "usr_".$user_data['user_id']."_schedule";
$day=$_COOKIE["day"];

$schedule_res = mysql_query("SELECT * FROM {$table1} WHERE day=$day");

if (!$schedule_res) {
    die("Query to show fields from table failed");
}
$rows1_num =  mysql_num_rows($schedule_res);
if ($rows1_num == 0) {
	die("no shedule for this day");
}

$schedule = mysql_fetch_row($schedule_res);
foreach($schedule as $cell){
    //Это если прооблемы с кодировкой (echo $temp)
    //$temp = $cell;
	//$temp = iconv("windows-1251", "UTF-8", "$temp");
    echo $cell."*";
}
?>