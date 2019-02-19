function Vector(x, y) {
	this.x = x;
	this.y = y;
	this.scalar = function(s) {
		this.x = s*this.x;
		this.y = s*this.y;
	}
	this.copy = function() {
		return new Vector(this.x, this.y)
	}
	this.ContinueLine = function(ctx){
		ctx.lineTo(this.x, this.y)
	}
}

function Rect(x1, y1, x2, y2, x3, y3, x4, y4, ctx, color) {
	this.ctx = ctx;
	ctx.strokeStyle = color;
	var v1 = new Vector(x1, y1); 
	var v2 = new Vector(x2, y2); 
	var v3 = new Vector(x3, y3); 
	var v4 = new Vector(x4, y4); 
	ctx.beginPath();
	ctx.moveTo(x4, y4);
	v1.ContinueLine(ctx);
	v2.ContinueLine(ctx);
	v3.ContinueLine(ctx);
	v4.ContinueLine(ctx);
	ctx.closePath();
	ctx.stroke();
}