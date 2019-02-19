window.addEventListener("load", main, false);

function main () {
	var ctx = canvas1.getContext("2d");
	var M = random_array(10);
	insertion_sort(M);
	console.log(binary_search(M, M[4])); //works right
	var Surnames = ['Zuev', 'Velikov', 'Lashkova', 'Bagaev', 'Glukhov'];
	insertion_sort(Surnames);
	console.log(binary_search(Surnames, Surnames[0]));
	console.log(binary_search(Surnames, Surnames[1]));
	console.log(binary_search(Surnames, Surnames[2]));
	console.log(binary_search(Surnames, Surnames[3]));
	}
	
function random_array(l){
	var arr = [];
	for(var i = 0; i < l; i++){
		r=Math.random()*10
		arr.push(r-r%1);
	}
	return arr;
}

function binary_search(M, element){
	var min = 0;
	var max = M.length-1;
	while (min <= max) {
		var mid = Math.floor((max+min)/2);
		if(element == M[mid]) return mid;
		else if(element < M[mid]) max = mid-1;
		else if(element > M[mid]) min = mid+1;
		else return -1;
	}
	return -1;
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