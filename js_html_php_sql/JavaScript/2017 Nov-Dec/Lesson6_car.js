function Car(color, weight, max_speed, model) {
	this.color = color;
	this.weight = weight;
	this.max_speed = max_speed;
	this.model = model;
	//var engine is invisible outside - encapsulation
	//engine is a private variable
	var engine = false;
	this.move = function(speed) {
		if (engine == false) {
			start_engine();
		}
		console.log(model + " едет со скоростью " + speed + " миль в час");
	}
	this.honk = function() {
		console.log(model + " гудит")
	}
	function start_engine() {
		console.log(model + ": движок запущен")
	}
}