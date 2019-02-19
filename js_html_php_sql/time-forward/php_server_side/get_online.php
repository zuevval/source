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
$table1 = "usr_".$user_data['user_id']."_online";
//$table1 = "usr_1_online";
$online_id=$_COOKIE["online_id"];

$online_res = mysql_query("SELECT * FROM {$table1} WHERE id=$online_id");
if (!$online_res) {
    die("Query to show fields from table failed");
}
$online = mysql_fetch_row($online_res);
foreach($online as $cell){
    //Это если прооблемы с кодировкой (echo $temp)
    //$temp = $cell;
	//$temp = iconv("windows-1251", "UTF-8", "$temp");
    echo $cell."*";
}
?>