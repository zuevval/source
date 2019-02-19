window.addEventListener("load", main, false);

function main () {
	var A = [];
	A.push([0,0]);
	A.push([1,1]);
	var B = [];
	for (var i=0; i<A.length; i++){
		B[i]=[];
		B[i][0]=A[i][0];
		B[i][1]=A[i][1];
	}
	A[1][1]=5;
	console.log(B);
	}