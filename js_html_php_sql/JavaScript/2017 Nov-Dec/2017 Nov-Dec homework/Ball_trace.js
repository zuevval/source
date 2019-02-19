window.addEventListener("load", main, false);

const g = 0.2;
const dt = 1000/40;

var dx1;
var dy1;

function main () {
	var ctx = canvas1.getContext("2d");
	var width = canvas1.width;
	var height = canvas1.height;
	
	var v = range1.value;
	var alpha = range2.value*3.1416/180;
	var t = 1000;
	var ax = [];
	var ay = [];
	var i = 0;
	
	/*var Timer1 = setInterval(step, dt);
	clearInterval(Timer1);*/
	
	Timer1 = setInterval(EmptyFun, dt);
	button1.onclick = function(){
		v = range1.value;
		alpha = range2.value*3.1416/180;
		i = 0;
		ax = [];
		ay = [];
		for(var i=0; i<t; i++){
		ax.push(v*i*Math.cos(alpha));
		ay.push(v*i*Math.sin(alpha)-g*i*i/2);
	}
	console.log(ax);
	console.log(ay);
	console.log(alpha);
	clearInterval(Timer1);
		Timer1 = setInterval(step1, dt);
	}
	function step1(){
		step(ax,ay,i,t, height);
		i++;
	}
}