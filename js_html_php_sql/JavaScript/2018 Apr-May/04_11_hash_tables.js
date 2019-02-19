window.addEventListener("load",main,false);
function main(){

	var str=" Абашичева, Абашкин, Абашкина, Абашкина-Логинова, Абашков, Абашкова, Абашмадзе, Абашо, Абашуев, Абашцев, Абаюшкина, Абаясов, Аббабий, Аббазов, Аббазова, Аббакумов, Аббакумова, Аббакумовская, Аббакумовский";
	str=str.toLowerCase();
	console.log(str_stat(str));
	//HASH['+_)(+_']="some_value";
	var r = Math.random();
	var data = [];
	for (var i=0; i<10000; i++){
		r = Math.random();
		data.push(r);
	}
	console.log(data);
	//вывести количество чисел в 
	//каждом отрезке, которые попадают в 0-0.1;
	var gauss=[];
	for (var i=0; i<2000; i++){
		var t=0;
		for (var j=0; j<5; j++)
			t=t+data[5*i+j];
		t=t/5;
		t=Math.floor(10*t)/10;
		gauss.push(t);
	}
	console.log(gauss);
	var dist = str_stat(gauss);
	for (var i=0.0; i< 10; i++){
		var s = (String)(i/10);
		console.log(dist[s])
	}
	var ctx = canvas1.getContext("2d");
	var w = canvas1.width;
	var h = canvas1.height;
	ctx.beginPath();
	var k=0.3;
	for (var i=0.0; i< 10; i++){
		var s = (String)(i/10);
		var y=dist[s];
		ctx.strokeRect(10*i,h-y*k,10,y*k);
	}
}

function str_stat (str){
	var HASH={}; //Не совсем объект
	for (var i=0; i<str.length; i++){
		var ch=str[i];
		if(HASH[ch]==undefined) HASH[ch]=1;
		else HASH[ch]++;
	}
	return HASH;
}