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
}