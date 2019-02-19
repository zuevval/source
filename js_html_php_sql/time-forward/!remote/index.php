<?php
?>

<script type="text/javascript" src="javascript/db_calls.js"></script>
<script type="text/javascript" src="javascript/index_page.js"></script>

<!-- Bootstrap -->
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.4/css/bootstrap.min.css">
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.4/css/bootstrap-theme.min.css"> 
	<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.4/js/bootstrap.min.js"></script>
	<link rel="stylesheet" href="css/index.css">

<!DOCTYPE html>
<html lang="ru">

<head>
    <meta charset="UTF-8">
    <title>Задачи на день</title>
</head>

<body onload="init()">
	<div class="container">
		<div class="nav">
			<ul class="nav nav-pills nav-stacked">
				<li class="profile_text"><a href="#">Алексей</a></li>
				<li><a href="#">Расписание</a></li>
				<li><a href="#">Карта перемещений</a></li>
				<br>
				<li><a href="output.html">Готовое расписание</a></li>
				<li class="byOKStop">&copy; 2018 OK Stop</li>
			</ul>
		</div>

		<div class="main">
			<p>Выберите задачи на день:</p>
			<table class="table" id="tasks">
				<thead>
			    	<tr>
			    		<th scope="col">#</th>
			    		<th scope="col">Имя</th>
			    		<th scope="col">Приоритет</th>
			    		<th scope="col">Время</th>
			    		<th scope="col">Удалить</th>
			    	</tr>
				</thead>
				<tbody>
			    	<tr>
			    		<td>1</td>
			    		<td id="firstRowId"></td>
			    		<td><input type="range" min="1" max="3" step="1"></td>
			    		<td><input type="range" min="10" max="18" step="1"></td>
			    		<td></td>
					</tr>
				</tbody>
			</table>
			<div class="buttons">
					<button id="add_task" onClick="add_row()">Добавить задачу</button>
					<button id="form_schedule" onClick="form_schedule()">Сформировать расписание</button>
			</div>
		</div>
	</div>
</body>
</html>
