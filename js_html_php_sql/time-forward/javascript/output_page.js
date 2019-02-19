//Раскомментировать
var login=getCookie('login');
var pass=getCookie('pass');

var day = 0;
var res = get_schedule(login, pass, day);
var group_id = get_group_id(login, pass);

var d = document;
//res = ['матан', '12.00', '13.40', 'линал', '14.00', '15.40', 'спм', '16.00', '17.40', 'теормех', '18.00', '19.40'];


// Заполним расписание списком res:

/**/
function init() { // После открытия страницы выполняем:
      // if (login==-1||pass==-1) window.alert("Пожалуйста, авторизуйтесь");
      // Здесь должен быть редирект на страницу логина

	  var th=0;
	  var tmin=0;
      var tbody = d.getElementById('tbody');
      for (var i = 0; i < res.length; i+=3) {
      var row = d.createElement('tr');
      tbody.appendChild(row);
      var td1 = d.createElement('td'),
            td2 = d.createElement('td'),
            td3 = d.createElement('td');
      row.appendChild(td1);
      row.appendChild(td2);
      row.appendChild(td3);
      td1.innerHTML = res[i];
	  th = Math.floor(res[i+1]/100);
	  tmin = res[i+1]%100;
	  if(tmin%10==0) tmin = '0' + String(tmin);
      td2.innerHTML = th+':'+tmin;
	  th = Math.floor(res[i+2]/100);
	  tmin = res[i+2]%100;
	  if(Math.floor(tmin/10)==0) tmin = '0' + String(tmin);
      td3.innerHTML = th+':'+tmin;
      }
}
