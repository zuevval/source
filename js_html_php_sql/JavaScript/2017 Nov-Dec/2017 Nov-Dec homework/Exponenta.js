window.addEventListener("load", main, false);

function main () {
	var ctx = canvas1.getContext("2d");
	var width = canvas1.width;
	var height = canvas1.height;
	var counter = 10;
	//var M = [];
	var N = [];
	var ky = 0.05;
	var kx = 0.02;
	var h0 = 100;
	for (var i = 0; i < width; i++){
		//M.push(i);
		N.push(ky*Math.exp(kx*i)+h0);
		ctx.beginPath();
		ctx.arc(i, N[i], 1, 0, Math.PI*2)
		ctx.stroke();
	}
	ctx.closePath();
	ctx.strokeStyle="#7f7f7f";
	for (var i = 0; i < width; i++){
		ctx.beginPath();
		ctx.arc(i, h0, 1, 0, Math.PI*2);
		ctx.stroke();
	}
}