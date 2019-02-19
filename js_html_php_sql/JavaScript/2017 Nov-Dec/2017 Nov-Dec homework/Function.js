window.addEventListener("load", main, false);

function main (e) {
	var ctx = canvas1.getContext("2d");
	var width = canvas1.width;
	var height = canvas1.height;
	//интервал от +5 до -5
	//по ординате интервал от -1 до 26
	const k = 10/width;
	const yk = height/27;
	var Y = [];
	var X = [];
	var x = 0;
	ctx.beginPath();
	for(var i=0; i<=width; i++){
		X.push(k*(i-width/2));
		Y.push(height-yk*fun(X[i])-yk);
		ctx.arc(i,Y[i], 1, 0, 2*Math.PI);
	}
	//ctx.arc(200,100, 3, 0, 2*Math.PI);
	ctx.stroke();
	ctx.closePath();
	ctx.beginPath();
	ctx.moveTo(0,height-yk);
	ctx.lineTo(width, height-yk);
	ctx.lineTo(width-5, height-yk-5);
	ctx.lineTo(width-5, height-yk+5);
	ctx.stroke;
	ctx.closePath();
	text1.innerHTML = 'y(x)=';
	text3.innerHTML = 'x=';
	var b = false;
	var x1=0;
	var tx=0;
	var R =mouse_coordinates(e);
	canvas1.onmousedown = function(e){
		R = mouse_coordinates(e);
		if(Math.abs(R.x-x1)<=90){
			b=true;
			tx=R.x;
		}
	}
	canvas1.onmouseup = function(e){
		b=false;
	}

	canvas1.onmousemove = function(e){
		if(b==true){
			//ctx.clearRect(R.x-2, 0, R.x+2, height)
			ctx.clearRect(0, 0, width, height);
			R=mouse_coordinates(e);
			x1 = x1+R.x-tx;
			tx=R.x;
			ctx.beginPath();
			ctx.moveTo(R.x,0);
			ctx.lineTo(R.x,height);
			ctx.stroke();
			ctx.closePath();
			text2.innerHTML = fun(X[R.x]);
			text4.innerHTML = X[R.x];
		ctx.beginPath();
		for(var i=0; i<width; i++){
			ctx.arc(i,Y[i], 1, 0, 2*Math.PI);
		}
		ctx.stroke();
		ctx.closePath();
		ctx.beginPath();
	ctx.moveTo(0,height-yk);
	ctx.lineTo(width, height-yk);
	ctx.lineTo(width-5, height-yk-5);
	ctx.lineTo(width-5, height-yk+5);
	ctx.stroke;
	ctx.closePath();
		}
	}
}

function fun(x){
	y=Math.sin(3*x)+Math.pow(x,2);
	return y;
}

function mouse_coordinates(e){
	var m = {};
	var rect = canvas1.getBoundingClientRect();
	m.x = e.clientX - rect.left;
	m.y = e.clientY - rect.top;
	return m;
	//e ("event") is a variable returned by browser. It renders all actions done by user.
}