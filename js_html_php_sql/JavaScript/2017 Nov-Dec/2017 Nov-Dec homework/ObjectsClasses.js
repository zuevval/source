window.addEventListener("load", main, false);

function main () {
	var ctx = canvas1.getContext("2d");
	var width = canvas1.width;
	var height = canvas1.height;
	var x1=100, y1 =90, x2=200, y2=100;
	var x3=220, y3=200, x4=100, y4=200;
	Rect(x1, y1, x2, y2, x3, y3, x4, y4, ctx, "ffffff");
	numberx1.oninput = function() {
		ctx.clearRect(0, 0, width, height);
		x1 = numberx1.value;
		Rect(x1, y1, x2, y2, x3, y3, x4, y4, ctx, "#ff00cb");
		Circle(x1, y1, 7);
	}
	numberx2.oninput = function() {
		ctx.clearRect(0, 0, width, height);
		x2 = numberx2.value;
		Rect(x1, y1, x2, y2, x3, y3, x4, y4, ctx, "#ff0000");
		Circle(x2, y2, 7);
	}
	numberx3.oninput = function() {
		ctx.clearRect(0, 0, width, height);
		x3 = numberx3.value;
		Rect(x1, y1, x2, y2, x3, y3, x4, y4, ctx, "#ff4700");
		Circle(x3, y3, 7);
	}
	numberx4.oninput = function() {
		ctx.clearRect(0, 0, width, height);
		x4 = numberx4.value;
		Rect(x1, y1, x2, y2, x3, y3, x4, y4, ctx, "#ffff00");
		Circle(x4, y4, 7);
	}
	numbery1.oninput = function() {
		ctx.clearRect(0, 0, width, height);
		y1 = numbery1.value;
		Rect(x1, y1, x2, y2, x3, y3, x4, y4, ctx, "#ff00cb");
		Circle(x1, y1, 7);
	}
	numbery2.oninput = function() {
		ctx.clearRect(0, 0, width, height);
		y2 = numbery2.value;
		Rect(x1, y1, x2, y2, x3, y3, x4, y4, ctx, "#0033ff");
		Circle(x2, y2, 7);
	}
	numbery3.oninput = function() {
		ctx.clearRect(0, 0, width, height);
		y3 = numbery3.value;
		Rect(x1, y1, x2, y2, x3, y3, x4, y4, ctx, "#4902ff");
		Circle(x3, y3, 7);
	}
	numbery4.oninput = function() {
		ctx.clearRect(0, 0, width, height);
		y4 = numbery4.value;
		Rect(x1, y1, x2, y2, x3, y3, x4, y4, ctx, "#ff0000");
		Circle(x4, y4, 7);
	}
}

function Circle(x, y, R) {
	ctx.beginPath();
			ctx.arc(x, y, R, 0, Math.PI*2);
			ctx.fill();
			ctx.closePath();
}