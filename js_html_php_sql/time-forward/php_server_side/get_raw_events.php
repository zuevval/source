<?php
//requires php 5.x
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
$table1 = "usr_".$user_data['user_id']."_raw_events";
$day=$_COOKIE["day"];
$raw_res = mysql_query("SELECT * FROM {$table1} WHERE day=$day");
if (!$raw_res) {
    die("Query to show fields from table failed");
}

if (!$raw_res) {
    die("Query to show fields from table failed");
}
$rows1_num =  mysql_num_rows($raw_res);
if ($rows1_num == 0) {
	die("no events for this day");
}

$raw = mysql_fetch_row($raw_res);
foreach($raw as $cell){
    echo $cell."*";
}
/*while ($data = mysql_fetch_array($raw_res)) {
        echo $data['event_id'].' ';
    }*/
?>