window.addEventListener("load", main, false);
 
//сортировки

function main () {
	var ctx = canvas1.getContext("2d");
	
	function readSingleFile(e){
		var f = e.target.files[0];
		
		if(f){
			var r = new FileReader();
			r.onload = function(environement){ /*when file
			uploading is finished, browser renders e
			(or environement, or else. Regardless to
			how you name it, it reads e).*/
				var content = environement.target.result;
				process_file(content);
			}
			r.readAsText(f);
		} else{
			console.log('ERR!1!')
		}
	}
	fileinput.addEventListener('change', readSingleFile, false);
	
	var surn = 'Зуев';
	
	function process_file(content){
		//console.log(content);
		var strings = content.split('\n');
		for (var i=0; i<strings.length; i++){
			strings[i]=strings[i].trim();
			//to get rid of \r\n, etc.
		}
		console.log(strings);
		var t1=-1;
		var t2=-1;
		var diff_bin=0;
		for (var j=0; j<100; j++){
		t1=performance.now();
		num = binary_search(strings, surn);
		t2=performance.now();
		diff_bin = diff_bin+t2-t1;
		}
		diff_bin=diff_bin/100;
		console.log('binary search works in '+diff_bin);
		console.log('Фамилия '+surn+' на '+num+' месте в списке');
		
		var diff_bad=0;
		var flag=-1;
		for (var j=0; j<100; j++){
			t1=performance.now();
			flag=-1;
			for (var i=0; i<strings.length; i++){
				if(content[i]==surn)
					flag=i;
			}
			t2=performance.now();
			diff_bad = diff_bad+t2-t1;
		}
		diff_bad=diff_bad/100;
		console.log('stupid search works in '+diff_bad);
		ratio = diff_bad/diff_bin;
		console.log('ratio is '+ratio);
		//num1 = bin_search(strings, surn);
	}
}
	
function bin_search(M, element){
	bin_search_internal(element, M, 0, M.length-1);
}
	
function bin_search_internal(element, M, min, max){
	var mid = Math.floor((min+max)/2);
	if(M[mid]==element) return mid;
	while(min !=max){
		if(element>M[mid])
			bin_search(element,M,mid,max);
			else
			bin_search(element,M,min,mid);
	}
	return -1;
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