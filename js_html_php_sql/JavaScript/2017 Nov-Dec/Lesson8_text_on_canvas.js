window.addEventListener("load", main, false);

function main () {
	var ctx = canvas1.getContext("2d");
	var width = canvas1.width;
	var height = canvas1.height;
	
	ctx.font = "30pt 'Comic Sans MS'";
	//выравнивание по горизонтали по центру
	ctx.textAlign="center"; // (or) left right
	//выравнивание по вертикали по центру
	ctx.textBaseLine="middle"; //(or) top bottom
	ctx.fillText("Hello world", width/2, height/2);
	ctx.strokeText("Hi there", 200,100);
	ctx.lineStyle="black";
	ctx.moveTo(0,height/2);
	ctx.lineTo(width,height/2);
	ctx.stroke();
	ctx.moveTo(width/2,0);
	ctx.lineTo(width/2,height);
	ctx.stroke();
	
	var ctx3 = canvas3.getContext("2d");
	var width3 = canvas3.width;
	var height3 = canvas3.height;
	ctx3.moveTo(0,0);
	ctx3.lineTo(height3, width3);
	ctx3.stroke();
	}