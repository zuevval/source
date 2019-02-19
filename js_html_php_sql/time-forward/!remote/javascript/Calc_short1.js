/*	time(n,k) выводит по начальной (n) и конечной (k) пятиминутке
	время начала и конца события в нормальном виде*/
	
function time(n,k){//n-начало  k-конец  (пятиминутки)
	var x1=n*5;//всего минут
	var x2=k*5+5;
	var h1=Math.floor(x1/60);//часов
	var h2=Math.floor(x2/60);
	var m1=x1%60;//минут
	var m2=x2%60;
	if (m1<10){m1='0'+m1}
	if (m2<10){m2='0'+m2}
	var M=["Начало в "+h1+':'+m1+' ','Конец в '+h2+':'+m2]
	return M
}

function calc_short(M,login,pass){  //На вход подается массив пятиминуток, login и pass. На выход подается двумерный массив: событие-время начала-время конца.
	var A=['name','start','finish']; //на вывод
	A['name']=[]; //id занятия СТОЛБЕЦ
	A['start']=[]; // начало СТОЛБЕЦ
	A['finish']=[]; // конец СТОЛБЕЦ
	
	M=[0].concat(M);
	M=M.concat(0);
	
	for (var i=0;i<=M.length;i++){
		if(M[i]!=0 && M[i]!=M[i-1] && M[i]!=M[i+1]){
			A['name'].push(M[i]);
			A['start'].push(time(i-1,1)[0]);
			A['finish'].push(time(1,i-1)[1]);
		}
		
		if(M[i]!=0 && M[i]!=M[i-1] && M[i]==M[i+1]){
			A['name'].push(M[i]);
			A['start'].push(time(i-1,1)[0]);
		}
		if(M[i]!=0 && M[i]==M[i-1] && M[i]!=M[i+1]){
			A['finish'].push(time(1,i-1)[1]);
		}
	}
	A['name'].pop();
	A['start'].pop();
	
	var V=[];
	for (var i=0; i<=A['name'].length;i++){
		V.push(A['name'][i]);
		V.push(A['start'][i]);
		V.push(A['finish'][i]);
	}
	V.pop();V.pop();V.pop();
	return V;
}