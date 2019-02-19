window.addEventListener("load", main, false);

function main () {
	spanMain.innerHTML="<br> Hello guys" //Привязываем интерфейс SpanMain в ХТМЛ
	var button_presses=0;
	button_calc.onclick = function(){
		var a = parseInt(number1.value);
		var b = parseInt(number2.value);
		console.log(a+b);
		spanMain.innerHTML="<br> HalfSum = "+(a+b)/2;
	}
	button2.onclick = function(){
		var rVal = range1.value;
		number3.value = rVal;
	}
	number3.oninput = function () {
		var fieldVal = number3.value;
		range1.value = fieldVal;
	}
	button0.onclick = function() {
	var a = parseInt(number1.value);
	var b = parseInt(number2.value);		
		if(a+b>10)
			span2.innerHTML = (a+b)*(a+b)
		else
			span2.innerHTML = "Function (input - first two text fields) = " + parseInt(a+b)
	}
}