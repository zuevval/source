window.addEventListener("load",main,false);
function main(){
	//численное интегрирование и дифференцирование
	var x0=0;
	var x1=Math.PI;
	var n=1000;
	var func = Math.sin;
	function integrate_rect(func, x0, x1, n){
		var dx = (x1-x0)/n;
		var s=0;
		for (var i=0; i<n; i++){
			var x=x0+dx/2+dx*i;
			var fx=func(x);
			s+=dx*fx;
		}
		return s;
	}
	//var J1=integrate_rect(func, x0,x1,n);
	var J2=integrate_trap(func, x0,x1,n);
	var J3=integrate_mntcrl(func, x0,x1,n);
	//console.log(J1);
	console.log('monte-carlo: '+J3);
	console.log('trapezioidal: '+J2);
	//console.log(J2-J1);
}

function integrate_trap(func, x0, x1, n){
	var dx = (x1-x0)/n;
		var s=0;
		for (var i=0; i<n; i++){
			var x=x0+dx/2+dx*i;
			var fx0=func(x);
			var fx1=func(x+dx);
			s+=dx*(fx0+fx1)/2;
		}
		return s;
}

function integrate_mntcrl(func, x0, x1, n){
	//hometask
	var bounds = find_bounds(func, x0, x1,n);
	var rx=Math.random();
	var ry=Math.random();
	var xi=rx*(x1-x0);
	var yi=ry*(bounds[1]-bounds[0]);
	var res = 0;
	for (var i=0; i<n; i++){
		rx=Math.random();
		ry=Math.random();
		xi=rx*(x1-x0);
		yi=ry*(bounds[1]-bounds[0]);
		if(yi > func(xi) &&func(xi)<=0) res++;
		if(yi < func(xi) &&func(xi)>0) res++;
	}
	
	res=res/n;
	//console.log('res is '+res);
	//console.log('bounds are '+bounds);
	//console.log('x limits are '+x0+' and '+x1);
	res=res*(Math.abs(bounds[1]-bounds[0]));
	res=res*(x1-x0);
	return res;
}

function find_bounds(func, x0, x1,n){
	//hometask
	var min=0;
	var max=0;
	var dx = (x1-x0)/n;
		for (var i=0; i<n; i++){
			var x=dx*i;
			var fx=func(x);
			if(min > fx) min=fx;
			if(max < fx) max=fx;
		}
	return [min,max];
}

// function diff(func, x0, x1){
	// //hometask
	// var min=0;
	// var max=0;
	// var dx = (x1-x0)/n;
		// for (var i=0; i<n; i++){
			// var x=x0+dx/2+dx*i;
			// var fx0=func(x);
			// var fx1=func(x+dx);
			// s+=dx*(fx0+fx1)/2;
		// }
// }