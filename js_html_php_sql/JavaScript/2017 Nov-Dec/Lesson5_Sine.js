window.addEventListener("load", main, false);

//while

function main () {
	var ctx = canvas2.getContext("2d");
	var width = canvas1.width;
	var height = canvas1.height;
	var counter = 10;
	var M = [];
	var N = [];
	var k = 20;
	for (var i = 0; i < 300; i++){
		M.push(i);
		N.push(50*Math.sin(i/k*Math.PI)+100);
		ctx.beginPath();
		ctx.arc(M[i], N[i], 1, 0, Math.PI*2)
		ctx.stroke();
	}
}