<?php
//requires php 5.x
$db_host = 'localhost';
$db_user = 'root';
$db_pwd = '';
$database = 'time-forward';

echo json_encode(0);

if (!mysql_connect($db_host, $db_user, $db_pwd))
    die("-1");
if (!mysql_select_db($database))
    die("-1");
$pass=$_COOKIE["pass"];
$login=$_COOKIE["login"];
$table='users';
$usr_res = mysql_query("SELECT * FROM {$table} WHERE login='$login' AND pass='$pass'");
if (!$usr_res) {
    die("-1");
}
$rows_num =  mysql_num_rows($usr_res);
if ($rows_num == 0) {
	die("-1");
}
?>