window.addEventListener("load", main, false);

function main () {
	var counter = 0;
	var t = 0;
	var res = 0;
	var n2value = 0;
	number1.oninput = function () {
		t = number1.value;
		while(t != 0) {
			if(t%5==0) {
				counter++;
				res = res+5*counter;
				t--;
			}else
			t=t-t%5;
		}
		n2value = res;
		number2.value = n2value;
		counter = 0;
		res = 0;
	}
	number2.oninput = function () {
		number2.value = n2value;
	}
}