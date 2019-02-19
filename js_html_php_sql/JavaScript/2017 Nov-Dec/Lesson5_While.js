window.addEventListener("load", main, false);

//while

function main () {
	var ctx = canvas1.getContext("2d");
	var width = canvas1.width;
	var height = canvas1.height;
	var counter = 10;
	while (counter > 0) {
		counter--;
		if (counter == 6)
			continue;
		//allows skipping a step
		if (counter == 5)
			break;
		console.log("counter = " + counter);
	}
	ctx.beginPath();
	var x = 60, y = 60;
	var vx = 2, vy = 3;
	var dt = 1;
	var ulim = 50, llim = 50, rlim = 150, dlim = 150;
		ctx.strokeRect(llim, ulim, rlim-llim, dlim-ulim);
	
	counter = 20;
	while (counter > 0) {
		counter--;
		if(counter == 4)
			continue;
		circle(ctx, counter*10+50, 200, 5);
	}
	
	for (var i = 0; i < 20; i++){
		for (var j = 0; j < 20; j++) {
			if (i == j)
				continue;
			circle(ctx, 10*i+200, 10*j+200, 5);
		}
	}
	function jump () {
		movex(x, y, vy, dt, llim, rlim, dlim, ulim);
		circle(ctx, x, y);
	}
	setInterval(jump, 1000/2)
}
	
	function circle (ctx,x, y, r) {
	ctx.beginPath();
	ctx.arc(x, y, r, 0, 2*Math.PI);
	ctx.fill();
}
function movex(x, vx, dt, llim, rlim, dlim, ulim) {
	if(x > llim && x < rlim && y < dlim && y > ulim)
		x = x + vx*dt;
	//console.log("x= "+ x + "y= " + y);
}

function movey(y, vy, dt, llim, rlim, dlim, ulim) {
	if(x > llim && x < rlim && y < dlim && y > ulim)
		y = y + vy *dt;
	//console.log("x= "+ x + "y= " + y);
}
	