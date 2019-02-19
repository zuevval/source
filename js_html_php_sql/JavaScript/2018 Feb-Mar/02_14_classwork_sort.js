window.addEventListener("load", main, false);
 
//сортировки

function main () {
	var ctx = canvas1.getContext("2d");
	var M1 = [3, 4, 9, 1, 7, 6, 8, 5, 2];
	var M2 = [1, 2, 3, 4, 5, 6, 7, 8, 9];
	//bubble_sort(M1);
	stupid_sort(M1);
	mix(M1);
	}
function bubble_sort(M){
	// var L = M.length;
	// var l = M.length-1;
	for (var i = 0; i<M.length-1; i++){
		for (var j = 0; j< M.length-i-1; j++) {
			if(M[j]>M[j+1]) {
				var t = M[j];
				M[j]=M[j+1];
				M[j+1]=t;
			}
			console.log(i, j, M);
		}
	}
}

function stupid_sort (M) { //gnome sort
	var i = 0;
	var ti = 0;
	while(i != M.length){
		if(M[i] > M[i+1]){
			if (i > ti) ti = i;
			var t = M[i];
			M[i] = M[i+1];
			M[i+1]=t;
			i--;
		} else{
			if(i < ti) i=ti;
			else i++;
		}
		console.log(i, M);
	}
}
// function mix(M){
	// for (var i = 0; i < M.length-1; i++){
		// for (var j = 0; j < M.length-1; j++){
			// var r = Math.random(10)%3;
			// r =r-r%1;
			
		// }
	// }
// }