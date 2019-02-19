window.addEventListener("load", main, false);
 
//сортировки

function main () {
	var ctx = canvas1.getContext("2d");
	var M1 = [3, 4, 9, 1, 7, 6, 8, 5, 2];
	var M2 = [1, 2, 3, 4, 5, 6, 7, 8, 9];
	
	}
	
function insertion_sort(M){
	for(var i = 0; i< M.length-1; i++){
		if(M[i]>M[i+1]){
			var t=M[i+1];
			for (var j = i; j >= 0; j--){
				M[j+1]=M[j];
				if(j==0||M[j-1]<=t){ //fortunately he doesn't try to call -1th element here
					M[j]=t;
					break;
				}
			}	
		}
	}
}

function bin_search(m, M, min, max){
	var mid = Math.floor((min+max)/2);
	if(M[mid]==m) return mid;
	while(min !=max){
		if(m>M[mid])
			bin_search(m,M,mid,max);
			else
			bin_search(m,M,min,mid);
	}
	return -1;
}

function random_array(){
	var arr = [];
	for(var i = 0; i < 10; i++){
		r=Math.random()*10
		arr.push(r-r%1);
	}
	return arr;
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

function stupid_sort (M) {
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