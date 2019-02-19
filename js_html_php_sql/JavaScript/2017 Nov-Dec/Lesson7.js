window.addEventListener("load", main, false);

var dx1;
var dy1;

function main () {
	var ctx = canvas1.getContext("2d");
	var width = canvas1.width;
	var height = canvas1.height;
	var vect = {x:5, y:7, draw:function(ctx, x1, y1){
		ctx.beginPath();
		ctx.moveTo(x1,y1);
		ctx.lineTo(x1+this.x, y1+this.y);
		ctx.stroke();
	}
	}
	console.log(vect.x, vect.y);
	vect.draw(ctx, 50,50);
	
	dx1 = 0;
	dy1 = 0;
	
	bx=40;
	by=50;
	ball(40, 50);
	ball1(bx,by);
	var b = false;
	//var vect = {r:new Vector (2,4)};
	//onmousedown срабатывает на нажатие левой клавиши мыши
	canvas1.onmousedown = function(e){
		var R = mouse_coordinates(e);
		var dx = R.x-bx;
		var dy = R.y-by;
		if(Math.sqrt(dx*dx+dy*dy) > 20){
			console.log("Не попал в кружок, неудачник");
			b = false;
		} else {
			b = true;
		}
	}
	
	canvas1.onmouseup = function(e){
	var R = mouse_coordinates(e);
		var dx = R.x-bx;
		var dy = R.y-by;
		if(Math.sqrt(dx*dx+dy*dy) > 20 || b==true){
			b = false;
		} else {
			b = true;
		}	
	}
	
	canvas1.onmousemove = function(e) {
		var R = mouse_coordinates(e);
		if(b == true) {
			bx=R.x + dx;
			by=R.y+dy;
			ball1(bx,by);
		}
	}
}

//getting coordinates value
function mouse_coordinates(e){
	var m = {};
	var rect = canvas1.getBoundingClientRect();
	m.x = e.clientX - rect.left;
	m.y = e.clientY - rect.top;
	return m;
	//e ("event") is a variable returned by browser. It renders all actions done by user.
}