window.addEventListener("load", main, false);
 
//фракталы

function main () {
	var ctx2 = canvas2.getContext("2d");
	var w = canvas1.width;
	var h = canvas1.height;
	var n = 5;
	var hue = 0;
	var rgb = HSVtoRGB(hue / 360, 1, 1);
	var color = RGBtoHEX(rgb.r, rgb.g, rgb.b);
//alert(rgb.r + " " + rgb.g + " " + rgb.b);
	function drawCircle(x,y,r, color){
		ctx2.beginPath();
		ctx2.arc(x,y,r, 0, 2*Math.PI);
		ctx2.fillStyle = color; 
		ctx2.fill();
	}
	function fract_circle(x, y, r, n, hue){
		if (n==1) return;
		rgb = HSVtoRGB(hue / 360, 1, 1);
		color = RGBtoHEX(rgb.r, rgb.g, rgb.b);
		drawCircle(x, y, r, color);
		ctx2.fill();
		console.log(hue);
		console.log(rgb);
		console.log(color);
		console.log(ctx2.fillStyle);
		fract_circle(x-r/Math.sqrt(2), y-r/Math.sqrt(2), r/2, n-1, hue+60);
		fract_circle(x-r/Math.sqrt(2), y+r/Math.sqrt(2), r/2, n-1, hue+60);
		fract_circle(x+r/Math.sqrt(2), y-r/Math.sqrt(2), r/2, n-1, hue+60);
		fract_circle(x+r/Math.sqrt(2), y+r/Math.sqrt(2), r/2, n-1, hue+60);
		ctx2.fillStyle = color;
	}
	fract_circle(150, 150, 70, 6, hue);
	//ctx2.arc(100, 100, 30, 0, 2*Math.PI);
	// ctx2.closePath();
	// function strokeFrac(n){
		// ctx2.clearRect(0, 0, w, h);
		// fract_circle(150, 150, 70, n);
	// }
	// var i=1;
	// function stroke(){
		// while(i < 10)
		// strokeFrac(i);
		// i++;
	// }
	// var Timer = setInterval(stroke, 1000);
}