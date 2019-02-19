window.addEventListener("load", main, false);

//emphasis on functions

function main () {
	var ctx = canvas1.getContext("2d");
	
	/*for (var i = 0; i < 20; i++) {
		ctx.beginPath();
		ctx.arc(10*i, 20, 0, 2*Math.PI);
		ctx.stroke();
	}*/
	half(4);
	var res = isEven(25);
	console.log("25 is even: " + res);
	
	ctx.fillStyle = "#00ffea";
	circle(ctx, 20, 20, 5);
	}
	
function half(x) {
	console.log(x/2);
}

function isEven(x) {
	//finds out whether x is odd or even
	var result = ((x%2)==0);
	return result;
}

function circle (ctx,x, y, r) {
	ctx.beginPath();
	ctx.arc(x, y, r, 0, 2*Math.PI);
	ctx.fill();
}
//function move(x,y, vx, vy)