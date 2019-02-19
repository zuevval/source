window.addEventListener("load", main, false);

function main () {
	//two-dimensional arrays and object-oriented programming
	var ctx = canvas1.getContext("2d");
	var width = canvas1.width;
	var height = canvas1.height;
	var M = [];
	for (var i = 0; i < 5; i++) {
		M[i]=[];
		for (var j = 0; j < 4; j++) {
			M[i][j] = i+j;
		}
	}
	console.log(M);
	
	//cars (object-oriented pr., encapsulation)
	var Lada = new Car("pink", 1500, 140, "Lada");
	var Renault = new Car("black metallic", 2000, 160, "Renault");
	console.log(Lada.color)
	Lada.move(Lada.max_speed);
	Renault.honk();
	
	//Vectors
	var v1 = new Vector(1,2);
	var v2 = v1; //это копирует не объект, а ссылку на него. К 
	//одному и тому же объекту теперь можно обратиться, используя два разных имени.
	s = 5;
	v1.scalar(s);
	v2.scalar(s)
	console.log(v1);
}