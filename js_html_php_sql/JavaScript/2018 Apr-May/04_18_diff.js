window.addEventListener("load",main,false);
function main(){
	var ctx = canvas1.getContext("2d");
	var w = canvas1.width;
	var h = canvas1.height;
	var x0=0;
	var x1=Math.PI;
	var n=1000;
	var func = Math.sin;
	ctx.beginPath();
	//ctx.fillRect(0, 0, w, h);
	ctx.moveTo(0, h/2);
	for (var i=0; i<n; i++){
		var x= i/(n-1)*Math.PI*2;
		var y = Math.sin(x);
		var rx = i/(n-1)*w;
		var ry = h/2 - y*h/2;
		ctx.lineTo(rx, ry);
		//console.log(ry);
	}
	ctx.stroke();
	ctx.closePath();
	console.log(diff(Math.sin,0,n));
}

function diff (func, x, n){
	var dx = 1/n;
	var x0 = x-dx;
	var x1 = x+dx;
	var fx0 = func(x0);
	var fx1 = func(x1);
	var res = fx1-fx0;
	res=res/(2*dx);
	return res;
}