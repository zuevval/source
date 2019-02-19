window.addEventListener("load", main, false);

//comment
/*Commenting
multiple
lines*/

function main () {
	var a = 777;
	var b = 7;
	var c = 'a';
	var d = Math.max(a, b);
	var d = Math.sin(Math.PI*0.5);
	// int a1 = 0;
	console.log("d = "+d);
	console.log(a+c);
	console.log("Hello World");
	span_hi.innerHTML="Hello guys" //Привязываем интерфейс в ХТМЛ
	var button_presses=0;
	button_out.onclick= function() {
		button_presses = button_presses +1;
		console.log("Нажата МегаКнопень")
		console.log("уже аж " + button_presses + " раз(а)")
	}
	radio1.onchange = function(){
		console.log("не меняй мнение")
	}
	checkbox_gravity.onchange = function(){
			console.log("Изменён режим графитации")
			console.log(checkbox_gravity.checked)
			if(checkbox_gravity.checked==false)
				console.log("------------------Земля")
			else
				console.log("Земля-----------------")
		}
		number1.onclick = function(){
			console.log("input area clicked");
		}
}