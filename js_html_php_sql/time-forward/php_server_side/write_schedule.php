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
$table1 = "usr_".$user_data['user_id']."_schedule";
$day=$_COOKIE["day"];
$schedule_res = mysql_query("SELECT * FROM {$table1} WHERE day=$day");
$rows1_num =  mysql_num_rows($schedule_res);
if ($rows1_num == 0) {
    //запись schedule в новую строку
    echo "создаём новую строку";
    $res=mysql_query("INSERT INTO {$table1} (day) VALUES ($day)");
    if (!$res) {
    	die("Query to insert new row failed");
    }
}
$fields_num = mysql_num_fields($schedule_res);
$fields = [];
for($i=0; $i<$fields_num; $i++)
{
    $field = mysql_fetch_field($schedule_res);
	$fields[$i] = $field;
	//echo $field->name;
}
$events_string = htmlspecialchars($_GET["events_string"]);

$events0=explode("*",$events_string);
$events1=[];
for ($i=0; $i< count($events0)/3; $i++){
	$j=$i+1;
	$events1['name_'.$j]=$events0[$i*3];
	$events1['start_'.$j]=$events0[$i*3+1];
	$events1['stop_'.$j]=$events0[$i*3+2];
	//echo $events0[$i].'__';
}

foreach($fields as $field){
	if($field->name!='day'){
		if($events1[$field->name]){
			if(substr($field->name, 0, 4)!='name')
				$resj=mysql_query("UPDATE {$table1} SET ".$field->name." = ".$events1[$field->name]." WHERE day=$day");
			else $resj=mysql_query("UPDATE {$table1} SET ".$field->name." = '".$events1[$field->name]."' WHERE day=$day");
	    echo ' replaced field '.$field->name;
		} else{
			$resj=mysql_query("UPDATE {$table1} SET ".$field->name." = -1 WHERE day=$day");
		}
		if (!$resj)
	    		die("Query to update table failed");
	}
}
?>