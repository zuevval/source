// Вызов функции при нажатии кнопки "Войти" и перенаправление пользователя на его личную страничку
window.addEventListener("load", main, false);
function main () {
	var login=getCookie('login');
	var pass=getCookie('pass');
	check=check_if_logged_in();
      if (check!=-1) {
            window.alert("Вы уже вошли в систему");
            window.location.replace("index.php");
            // Здесь должен быть редирект на страницу логина
      }
	butt1.onclick = function(){
		var login=document.getElementById('login').value,		// Логин, введенныей в форме на index.html
		password=document.getElementById('password').value; // Пароль
		console.log(login);
		console.log(password);
		ID = get_group_id(login, password);
		if (ID != -1) {
			redirect_to_input_page(login, password); // Перенаправляем пользователя на его личную страничку
		}
		else {
			window.location.reload(true); // Обновление страницы
		}
	}
}

/*function login_func() {
	var login=document.getElementById('login').value,		// Логин, введенныей в форме на index.html
		password=document.getElementById('password').value; // Пароль
		console.log(login);
		console.log(password);
		ID = get_group_ID(login, password);
	if (ID != -1) {
		redirect_to_input_page(ID); // Перенаправляем пользователя на его личную страничку
	}
	else if (ID == -1) {
		//window.location.reload(true); // Обновление страницы
	}
}*/
