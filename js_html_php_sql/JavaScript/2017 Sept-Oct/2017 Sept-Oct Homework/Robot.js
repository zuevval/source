window.addEventListener("load", main, false);

function main () {
	var ct = canvas1.getContext("2d");
	var k = 20;
	//right eye
	ct.beginPath();
	ct.moveTo(7*k, 2*k);
	ct.lineTo(6*k, 3*k);
	ct.lineTo(6*k, 4*k);
	ct.lineTo(7*k, 5*k);
	ct.lineTo(8*k, 5*k);
	ct.lineTo(9*k, 4*k);
	ct.lineTo(10*k, 4*k);
	ct.lineTo(11*k, 3*k);
	ct.lineTo(10*k, 2*k);
	ct.lineTo(7*k, 2*k);
	ct.stroke();
	ct.closePath();
	
	//left eye
	ct.beginPath();
	ct.moveTo(23*k-7*k, 2*k);
	ct.lineTo(23*k-6*k, 3*k);
	ct.lineTo(23*k-6*k, 4*k);
	ct.lineTo(23*k-7*k, 5*k);
	ct.lineTo(23*k-8*k, 5*k);
	ct.lineTo(23*k-9*k, 4*k);
	ct.lineTo(23*k-10*k, 4*k);
	ct.lineTo(23*k-11*k, 3*k);
	ct.lineTo(23*k-10*k, 2*k);
	ct.lineTo(23*k-7*k, 2*k);
	ct.stroke();
	ct.closePath();

	//right arm
	ct.beginPath();
	ct.moveTo(6*k, 6*k);
	var arr1 = [4, 5, 7, 6];
	var arr2 = [8.5, 8.5, 6, 6];
	for(i=0; i < arr1.length; i++){
		ct.lineTo(arr1[i]*k, arr2[i]*k);
	}

	ct.moveTo((23-6)*k, 6*k);
	for(i=0; i < arr1.length; i++){
		ct.lineTo(23*k-arr1[i]*k, arr2[i]*k);
	}
	ct.stroke();
	ct.closePath();
	/*
	ct.lineTo(4*k, 8.5*k);
	ct.lineTo(5*k, 8.5*k);
	ct.lineTo(7*k, 6*k);
	ct.lineTo(6*k, 6*k);
	ct.stroke();
	ct.closePath();*/
	
	//hands
	ct.beginPath();
	ct.moveTo(4*k, 8.5*k);
	arr1 = [4, 5, 5, 4.5, 4.5, 5, 5, 4];
	arr2 = [10, 10, 9.5, 9.5, 9, 9, 8.5, 8.5];
	for(i=0; i < arr1.length; i++){
		ct.lineTo(arr1[i]*k, arr2[i]*k);
	}
	ct.moveTo(23*k-4*k, 8.5*k);
	for(i=0; i < arr1.length; i++){
		ct.lineTo(23*k-arr1[i]*k, arr2[i]*k);
	}
	ct.stroke();
	ct.closePath();
	
	//body
	ct.beginPath();
	ct.moveTo(7*k, 6*k);
	arr1 = [7, 16, 16, 7];
	arr2 = [14, 14, 6, 6];
	for(i=0; i < arr1.length; i++){
		ct.lineTo(arr1[i]*k, arr2[i]*k);
	}
	ct.stroke();
	ct.fillStyle="#ffff00";
	ct.fill();
	ct.closePath();
	
	//tracks
	var PosY=11;
	for(i=0; i < 6; i ++){
		ct.beginPath();
		ct.strokeRect(3*k, PosY*k, 3*k, k);
		ct.closePath();
		PosY++;
	}
	var PosY=11;
	for(i=0; i < 6; i ++){
		ct.beginPath();
		ct.strokeRect((23-3-3)*k, PosY*k, 3*k, k);
		ct.closePath();
		PosY++;
	}
	
	
	/*
	ct.beginPath();
	ct.moveTo(7*k, 6*k);
	arr1 = [, , , ];
	arr2 = [, , , ];
	for(i=0; i < arr1.length; i++){
		ct.lineTo(arr1[i]*k, arr2[i]*k);
	}
	ct.stroke();
	ct.closePath();
	*/
	}