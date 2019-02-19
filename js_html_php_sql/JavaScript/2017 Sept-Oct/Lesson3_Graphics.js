window.addEventListener("load", main, false);

function main () {
	var ctx = canvas1.getContext("2d");
	ctx.strokeRect(100, 10, 50, 70);
	ctx.strokeStyle="#ff0000";
	ctx.beginPath(); //начало рисования
	ctx.moveTo(140, 50); //начало линии
	ctx.lineTo(200, 90);// куда вести линию
	ctx.stroke(); //конец рисования
	
	ctx.beginPath();
	ctx.strokeStyle="#ff0000";
	ctx.lineWidth="5";
	ctx.moveTo(200, 90); 
	ctx.lineTo(260, 50);
	ctx.stroke();
	
	//Circles
	ctx.beginPath();
	ctx.setLineDash([7, 5]);
	ctx.arc(300, 100, 50, 0, 2*Math.PI);
	ctx.stroke();
	
	ctx.beginPath();
	ctx.lineWidth="10";
	ctx.arc(420, 120, 40, 0, Math.PI);
	ctx.stroke();
	
	ctx.beginPath();
	ctx.arc(420, 120, 40, 0, Math.PI);
	ctx.fill();
	
	// triangles
	ctx.beginPath();
	ctx.moveTo(300, 300);
	ctx.lineTo(350, 300);
	ctx.lineTo(350, 230);
	ctx.lineTo(300,300);
	ctx.stroke();
	ctx.fillStyle = "#ff00ff";
	ctx.fill();
	ctx.closePath();
	ctx.beginPath();
	ctx.setLineDash([0, 0]);
	ctx.translate(-300, 0);
	ctx.scale(2, 1); //растягивание
	ctx.arc(100, 100, 40, 0, Math.PI);
	ctx.stroke();
	ctx.closePath();
	
	/*try{
	ctx.strokeCircle(110, 20, 5, 5);
	} catch(ctx.strokeCircle is not a function){
		console.log(error)
	}*/
}