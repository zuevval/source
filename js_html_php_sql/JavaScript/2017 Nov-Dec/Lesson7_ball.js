window.addEventListener("load", main, false);

var dx1;
var dy1;

function main () {
	var ctx = canvas1.getContext("2d");
	var width = canvas1.width;
	var height = canvas1.height;
	dx1 = 0;
	dy1 = 0;
	//var vect = {r:new Vector (2,4)};
	range1.onchange = function(){
		console.log(range1.value);
	}
	button1.onclick = function(){
		v = range1.value;
		fi = range2.value;
		var ax=1;
		var t = 1000/2;
		var Timer1 = setInterval(move(v,fi),t);
	}
}

function move(v, fi){
	//циклом нарисовать мячик в разных позициях (или всё же ввести какую-то физику?)
}

function ball(x, y) {
	var ctx = canvas2.getContext("2d");
	var width = canvas2.width;
	var height = canvas2.height;

	ctx.clearRect(0, 0, width, height);
	ctx.beginPath();
	ctx.arc(x, y, 20, 0, 2*Math.PI);
	ctx.stroke();
	ctx.closePath();
	console.log("ball");
}

function ball1(x, y) {
	var ctx = canvas1.getContext("2d");
	var width = canvas1.width;
	var height = canvas1.height;

	ctx.clearRect(0, 0, width, height);
	ctx.beginPath();
	ctx.arc(x, y, 20, 0, 2*Math.PI);
	ctx.stroke();
	ctx.closePath();
	console.log("ball");
}