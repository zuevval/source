window.addEventListener("load", main, false);

function main () {
	
	// == != *= /=
	var c = true;
	var a = (4 > 7);
	console.log(c || a); // "or"
	console.log(c && a);
	console.log("a=" + a);
	a = 4==5;
	console.log("a="+a);
	a = 4!=5;
	console.log("a="+a);
	var minHeight = 140;
	var myHeight = 180;
	if(myHeight > minHeight) {
		console.log("Вы можете пройти!")
	}
	}