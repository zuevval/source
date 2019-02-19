window.addEventListener("load", main, false);

//recursion

function main () {
	var w = canvas1.width;
	var h = canvas1.height;
	var fvalue = 1;
	function factorial(n){
		if(n==1|| n==0)
			return 1;
		var a = factorial(n-1);
		return n*a;
	}
	console.log(factorial(5));
	var ctx = canvas1.getContext("2d");
	function progression (a1, d, n){
		if(n==1) return a1;
		var a_n = progression(a1, d, n-1)+d;
		return a_n;
	}
	console.log(progression(1, 1, 5), "a1=1, d=1, n=5");
	console.log(progression(3, 4, 5), "a1=3, d=4, n=5");
	ctx.font="30pt 'Comic Sans Ms'"
	function strokeRes(n){
		ctx.clearRect(0, 0, w, h);
		ctx.strokeText(progression(3,4,n), 100, 100);
	}
	var i=1;
	function stroke(){
		strokeRes(i);
		i++;
	}
	var Timer = setInterval(stroke, 1000);
	}