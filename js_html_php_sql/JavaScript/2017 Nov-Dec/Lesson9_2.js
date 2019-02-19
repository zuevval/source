window.addEventListener("load", main, false);

//const dt = 1000/60;

function main (e) {
	var ctx = canvas2.getContext("2d");
	var width = canvas2.width;
	var height = canvas2.height;
	//Timer1 = setInterval(Empty);
	//clearInterval(Timer1);
	var x = width/2;
	var y = height/2;
	var r = 50;
	var step = 0;
	var step2=0;
	var A=height/2;
	var omega = 0.01
	var v = 3;
	var shift = false;
	var paused = false;
	
	var M = [];
	M.push(3);
	M.push(20);
	M.push(100);
	
	button_pause.onclick = function(){
		paused = !paused;
	}
	button_shift.onclick = function(){
		shift = !shift;
	}
	
	function calculation () {
			M.push(A*Math.random()*Math.sin(0.05*step2));
			step2++;
	}

	function draw(){
		var N = M.length;
		ctx.clearRect(0, 0, width, height);
		ctx.beginPath();
		if(shift == false){
		ctx.moveTo(0, M[0]);
		for(var i=1; i<N; i++){
			ctx.lineTo(width*i/(N-1), M[i]);
		}
		ctx.stroke();
		} else{
			step++;
			ctx.moveTo(0,M[step]);
			for(var i=step; i<N; i++){
			ctx.lineTo(width*(i-step)/(N-1-step), M[i]);
		}
		ctx.stroke();
		}
	}

	function control(){
		if(paused == false){
			calculation();
			draw();
		}
	}
	
	Timer2 = setInterval(control, dt);
}