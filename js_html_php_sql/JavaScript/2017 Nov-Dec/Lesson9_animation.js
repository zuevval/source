window.addEventListener("load", main, false);

const dt = 1000/60;

function main (e) {
	var ctx = canvas1.getContext("2d");
	var width = canvas1.width;
	var height = canvas1.height;
	//Timer1 = setInterval(Empty);
	//clearInterval(Timer1);
	var x = width/2;
	var y = height/2;
	var r = 50;
	var step = 0;
	var A=height/3;
	var omega = 0.01
	var v = 3;
	var b = true;
	
	function calculation () {
		step++;
		if(b==true){
			x = x+v;
			y=height/2-A*Math.sin(step*omega);
			if(x+r>width)
			b=false;
		}
			
		else {
			y=height/2-A*Math.sin(step*omega);
			if(r-x<=0)
			b==true;
			x = x-v;
		}
	}

	function draw(){
		ctx.clearRect(0, 0, width, height);
		ctx.beginPath();
		ctx.arc(x,y,r,0, Math.PI*2);
		ctx.stroke();
	}

	function control(){
	calculation();
	draw();
	}
	
	Timer1 = setInterval(control, dt);
}