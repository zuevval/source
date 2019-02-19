function step(ax, ay, i, t, h){
	if(ay[i]>=0&&ax[i]>=0&&i<t){
		ball(ax[i], h-ay[i]);
		ballSmall(ax[i],h-ay[i]);
	}
	console.log("i");
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
	//console.log("ball");
}

function ballSmall(x, y) {
	var ctx = canvas1.getContext("2d");
	var width = canvas1.width;
	var height = canvas1.height;

	ctx.beginPath();
	ctx.arc(x, y, 2, 0, 2*Math.PI);
	ctx.stroke();
	ctx.closePath();
	//console.log("ballSmall");
}

function EmptyFun(){}