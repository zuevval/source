window.addEventListener("load", main, false);

function main () {
	var ctx = canvas1.getContext("2d");
	
	var r = (7*Math.random())%7;
	r = r - r%1;
	var c = "ffffff"
	
	function blink() {
	for (var i = 20; i < 200; i=i+20){
		for(var j =20; j < 200; j=j+20){
			r = (9*Math.random())%9;
			r = r - r%1;
			switch (r) {
				case 0: c = "#ff4700";
				break;
				case 1: c = "#ffff00";
				break;
				case 2: c = "#00ffea";
				break;
				case 3: c = "#0033ff";
				break;
				case 4: c = "#ff0000";
				break;
				case 5: c = "#000000";
				break;
				case 6: c = "#0aff00";
				break;
				case 7: c = "#ff00cb";
				break;
				case 8: c = "#4902ff";
				break;
				default: c = "ffffff";
			}
			
			//console.log(r);
			ctx.beginPath();
			ctx.arc(i, j, 5, 0, Math.PI*2);
			ctx.fillStyle = c;
			ctx.fill();
			ctx.closePath();
		}
	}
	
	}
	
setInterval(blink, 1000/2)
	//arrays
	
	var drinks = ["milk", "juice", "Mountine Dew", "beer"];
	
	for (var i = 0; i < drinks.length; i++){
		console.log(drinks[i]);
	}
	
	drinks[3] = "tea";
	console.log(drinks[3]);
	
	var names = [];
	names.push("Igor");
	names.push("Valerii");
	console.log(names.pop());
	
	//Math.floor(x) отрезает дробную часть
	//Math.round(x) округляет x
	//Math.ceil(x) возвращает миимальное целое, большее x
	
	//average temperature in April
	var T = [];
	var sum = 0;
	for (var i = 0; i < 30; i++) {
		T.push(2 + 5*Math.random());
		sum = sum + T[i];
	}
	console.log(sum/30);
	
	//hometask
	
	for (var i = 30; i < 300; i = i + 30) {
		ctx.beginPath();
		ctx.arc(i, 250, 5, 0, Math.PI*2);
		ctx.stroke();
		if((i/30)%2==0){
			ctx.fill();
		}	
		ctx.closePath();
	}
	}