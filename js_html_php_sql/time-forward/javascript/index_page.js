//Раскомментировать
var login=getCookie('login');
var pass=getCookie('pass');

var day = 0;
var group_id = get_group_id(login,pass);
var events_id = get_tmtbl_id(group_id, day);
console.log(events_id);
events_id=events_id.concat(get_raw_events(login, pass, day));
//console.log(events_id);

var events_for_choosing = raw_events_table(events_id, group_id, day); // Массив всех возможных задач
console.log(events_for_choosing);
//events_for_choosing = ['матан', 'линал', 'физра', 'матмод', 'физика', 'спм']; // пример

var d = document,
      last_id = 1;

function init() { // При открытии страницы выполняем:
      check=check_if_logged_in();
      if (check==-1) {
            //window.alert("Пожалуйста, авторизуйтесь");
            window.location.replace("login.html");
            // Здесь должен быть редирект на страницу логина
      }

      // Заполним ячейку выбора в первой строке списком events_for_choosing:
      var select = d.createElement("select");
      for (var i = 0; i < events_for_choosing.length; i++) {
            var option = d.createElement("option");
            option.text = events_for_choosing[i];
            select.appendChild(option);
      }
      select.id = "select"+last_id;
      td1 = d.getElementById('firstRowId');
      td1.appendChild(select);
}

function add_row() {
      // Находим нужную таблицу
      var tbody = d.getElementById('tasks').getElementsByTagName('tbody')[0];

      // Создаем строку таблицы и добавляем ее
      var row = d.createElement("tr");
      row.id = "rowId"+parseInt(last_id+1);
      tbody.appendChild(row);

      // Создаем ячейки в вышесозданной строке
      var td2 = d.createElement("td");
      var td3 = d.createElement("td");
      var td4 = d.createElement("td");
      var td5 = d.createElement("td");
      var td6 = d.createElement("td");
      
      row.appendChild(td2);
      row.appendChild(td3);
      row.appendChild(td4);
      row.appendChild(td5);
      row.appendChild(td6);

      last_id += 1;

      // Создадим меню выбора:
      var select = d.createElement("select");
      for (var i = 0; i < events_for_choosing.length; i++) {
            var option = d.createElement("option");
            option.text = events_for_choosing[i];
            select.appendChild(option);
      }
      select.id = "select"+last_id;
      td3.appendChild(select);

      td2.innerHTML = last_id;
      td4.innerHTML = '<input type="range" min="1" max="3" step="1">';
      td5.innerHTML = '<input type="range" min="10" max="18" step="1">';
      td6.innerHTML = '<button id="butId'+parseInt(last_id)+'" class="button_delete" onClick="remove_row(this.id)">X</button>';
}

function remove_row(buttonIdToRemove) {
      idToRemove = Number(buttonIdToRemove.slice(5,20));
      rowIdToRemove = 'rowId'+idToRemove;

      // Находим нужную таблицу
      var tbody = d.getElementById('tasks').getElementsByTagName('tbody')[0];
      // В таблице удаляем строку с id "buttonIdToRemove"
      var toRemove = d.getElementById('tasks').getElementsByTagName('tr')[idToRemove];
      // Удаляем нужную строку
      tbody.removeChild(toRemove);

      // Обновляем индексы кнопок
      for (var i=idToRemove+1; i<=last_id; i++){ // Пройдемся по строкам,
      // следущими за buttonIdToRemove, и перенесем id каждого на единицу вверх (уменьшим id)
            d.getElementById('butId'+parseInt(i)).id = 'butId'+parseInt(i-1);
      // Обновляем индексы строк в таблице
            d.getElementById('rowId'+parseInt(i)).id = 'rowId'+parseInt(i-1);
      // А теперь обновим числа в столбце "#":
            var nextToRemove = d.getElementById('tasks').getElementsByTagName('tr')[i-1].getElementsByTagName('td')[0];
            nextToRemove.innerHTML = parseInt(i-1);
      }
      
      last_id -= 1;
}

function raw_events_table(events_id, group_id, day) {
      // Возвращает названия задач, чтобы пользователь смог добавить задачи в расписание 
      var onlines = []; // Массив названий онлайн-дисциплин
      var lesson_names = []; // Массив названий учебных офлайн-занятий
      var elective_names = []; // Массив названий учебных дополнительных офлайн-занятий

      for (var i = 0; i < events_id.length; i+=2) {
            if(events_id[i]>210)
            onlines.push(get_online(login, pass, events_id[i])[0]);
      }

      for (var i = 0; i < events_id.length; i++) {
            //console.log(events_id[i]);
            if(events_id[i]>200&&events_id[i]<=210)
            lesson_names.push(get_lesson_name(events_id[i], group_id, day));
            //elective_names.push(get_elective_name(events_id[i], day));
            //такой функции (elective_names) пока нет
      }

      /*
      Использовал функции:
      get_online(login, pass, online_id);
      get_lesson_name(lesson_id, group_id);
      get_elective_name(elective_id, day);
      */
      console.log(lesson_names);
      var events_for_choosing = lesson_names.concat(elective_names, onlines);
      return events_for_choosing;
}

function form_schedule() {

      var choosed_events_names = [];
      for (var i = 1; i <= last_id; i++) {
            choosed_events_names.push(d.getElementById("select"+parseInt(i)).value);
      }
      var choosed_events_id = [];
      for (var i=0; i < choosed_events_names.length; i++){
            for (var j=0; j < events_for_choosing.length; j++){
                  if (events_for_choosing[j]==choosed_events_names[i]){
					  choosed_events_id.push(events_id[j]);
					  break;
				  }
            }
      }
      console.log(choosed_events_id);
      if(choosed_events_id.length >  12)
            window.alert("Не многовато? Выберите двенадцать событий или меньше! Тринадцатое несчастливое");
      else {
            write_raw_events(login, pass, day, choosed_events_id);
			var res1 = calc(login, pass, day);
			write_schedule(login, pass, day, res1);
			console.log(res1);
            window.location.replace("output.html");
      }
}