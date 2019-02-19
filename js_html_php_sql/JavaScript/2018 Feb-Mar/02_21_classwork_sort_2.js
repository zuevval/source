window.addEventListener("load", main, false);
 
//сортировки. Продолжение

function main () {
	var ctx = canvas1.getContext("2d");
	var M1 = [3, 4, 9, 1, 7, 6, 8, 5, 2];
	var M2 = [9,8,7,6,5,4,3,2,1];
	//При копировании примитивных типов копируется объект.
	//При копировании массива и другого объекта копируется лишь ссылка.
	//поэтому массивы надо копировать поэлементно
	var M3 = [];
	for(var i = 0; i < M2.length; i++){
		M3.push(M2[i]);
	}
	//var M4=M3.slice(); //only for one-dimensional arrays
	var insert_sort_steps = 0;
	insertion_sort(M2, insert_sort_steps);
	M2=M3.slice();
	console.log(M2);
	ins_srt(M2, insert_sort_steps);
	console.log(insert_sort_steps);
	console.log(M2);
	}
	
function insertion_sort(M, steps){
	steps++;
	for(var i = 0; i< M.length-1; i++){
		if(M[i]>M[i+1]){
			var t=M[i+1];
			for (var j = i; j >= 0; j--){
				M[j+1]=M[j];
				if(j==0||M[j-1]<=t){ //fortunately it doesn't try to call -1th element here
					M[j]=t;
					break;
				}
			}	
		}
	}
}
function ins_srt(M){
	var i = 0;
	var i_sorted = 0;
	while(i<M.length-1){
		//count_ins++;
		if(M[i]>M[i+1]){
			var temp = M[i];
			M[i]=M[i+1];
			M[i+1]=temp;
			i--;
			if(i<0) i=0;
		}else{
			i++;
			if(i_sorted < i) i_sorted = i;
			if(i_sorted > i) i=i_sorted+i;
		}
	}
}