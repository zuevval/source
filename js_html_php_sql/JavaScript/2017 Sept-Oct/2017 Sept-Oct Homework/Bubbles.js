window.addEventListener("load", main, false);

function main () {
		var ctx = canvas1.getContext("2d");
		ctx.fillStyle = "#0033ff";
		
		var r = (9*Math.random())%9;
		r = r - r%1;
		//random color
		
		var R = (10*Math.random())%10;
		R = R - R%1;
		//bubble's radius
		
		var posx = (100*Math.random())%100;
		posx = posx - posx%1;
		var posy = (100*Math.random())%100;
		posy = posy - posy%1;
		
		var r = (7*Math.random())%7;
		r = r - r%1;
		var c = "ffffff"
		
		function blink() {
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
			ctx.fillStyle = c;
		}
		function bubble() {
			R = (10*Math.random())%10;
			R = R - R%1+5;
			posx = (300*Math.random())%300;
			posx = posx - posx%1;
			var posy = (300*Math.random())%300;
			posy = posy - posy%1;
			ctx.beginPath();
			ctx.arc(posx+20, posy+20, R, 0, Math.PI*2);
			ctx.fill();
			ctx.closePath();
		}
		
		function draw () {
				bubble();
				blink();
		}
		t = 1000/2;
		var Timer1 = setInterval(draw, t);
		button4.onclick = function() {
			clearInterval(Timer1);
			Timer1 = setInterval(draw, t);
		}
		button1.onclick = function() {
			t = t/1.2;
			t = t + t%1;
			clearInterval(Timer1);
			Timer1 = setInterval(draw, t);
			console.log("speed = " + 1000/t + " bubbles per second");
		}
		button2.onclick = function() {
			t = t*1.2;
			t = t + t%1;
			clearInterval(Timer1);
			Timer1 = setInterval(draw, t);
			console.log("speed = " + 1000/t + " bubbles per second");
		}
		button3.onclick = function() {
			clearInterval(Timer1);
		}
}