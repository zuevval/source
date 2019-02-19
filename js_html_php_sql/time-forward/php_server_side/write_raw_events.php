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
$table1 = "usr_".$user_data['user_id']."_raw_events";
$day=$_COOKIE["day"];
$raw_res = mysql_query("SELECT * FROM {$table1} WHERE day=$day");
$rows1_num =  mysql_num_rows($raw_res);
if ($rows1_num == 0) {
    //запись raw_events в новую строку
    echo "создаём новую строку";
    $res=mysql_query("INSERT INTO {$table1} (day) VALUES ($day)");
    if (!$res) {
    	die("Query to show fields from table failed");
    }
}
$fields_num = mysql_num_fields($raw_res);
$fields = [];
for($i=0; $i<$fields_num; $i++)
{
    $field = mysql_fetch_field($raw_res);
	$fields[$i] = $field;
}
$events_string = htmlspecialchars($_GET["events_string"]);
$raw_events = [];
for ($i=0; $i< strlen($events_string)/3; $i++){
	$j=$i+1;
	$raw_events['id_'.$j]=substr($events_string, 3*$i, 3);
}
echo '  '.$raw_events['id_2'].'  ';
foreach($fields as $field){
	if($field->name!='day'){
		if($raw_events[$field->name]){
			$resj=mysql_query("UPDATE {$table1} SET ".$field->name." = ".$raw_events[$field->name]." WHERE day=$day");
	    echo ' replaced field '.$field->name;
		} else{
			$resj=mysql_query("UPDATE {$table1} SET ".$field->name." = -1 WHERE day=$day");
		}
		if (!$resj)
	    		die("Query to update table failed");
	}
}
?>