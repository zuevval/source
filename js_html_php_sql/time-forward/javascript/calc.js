
function calc(login, pass, day){
	var long = calc_long(login, pass, day);
	for(var i=0; i<long.length; i++){
		if(long[i]==-1)
			long[i]=0;
	}
	console.log(long);
	var short = calc_short(long, login, pass);
	return short;
}


function calc_long(login,pass,day){ //в общем для полноценного тестировангия нужно будет интегрировать уже на сервер
	var time_gaps=[];
	var Error_log=[];
	for(var i=0; i<288;i++)time_gaps.push(-1);
	var group_id = get_group_id(login,pass);
	var lessons=get_raw_events(login, pass,day); //всё до кучи
	console.log(lessons);
	for (var i=0; i< lessons.length; i++){
		if(lessons[i] > 210 || lessons[i] < 200)
			lessons.pop(i);
	}
	console.log(lessons);
	//lessons=[201, 202, 203];
	console.log(lessons[0]);
	for (var i=0; i< lessons.length; i++){
		var s = get_lesson_start(lessons[i],group_id,day);
		var k = get_lesson_stop(lessons[i],group_id,day);
		for(s; s<=k; s++)
			time_gaps[s]=lessons[i];
	}
	
	var nearest_deadline = get_nearest_online(login,pass)
	var possible_start=0; 
	var count=1;
	var earliest_time = 100;
	// раньше earliest_time не ставятся курсы
	//var nearest_deadline=[0,1488,400,"бесконченость не предел"]
	online_filling:
	{
		for(var i=earliest_time;i<288;i++){
			if (time_gaps[i]==-1){ //проверка на то что пятиминутка не занята
				if(count==1)possible_start=i
				//console.log(count)
				if (count*5>=nearest_deadline[2]){ //предполагю что дано в минутах минимальное время
					console.log(count)
					console.log(possible_start)
					for(var p=possible_start; p<possible_start+count;p++){ //само заполнение
						time_gaps[p]=nearest_deadline[1]
						}
					break online_filling // я заполняю один дедлайн!
				}else count++
			}else count=1
		}Error_log.push("не удалось разместить онлайн курс")
	}
	//console.log(time_gaps)
	//var electives=get_electives()// откуд берётся эта информация?
	// var electives=[[666,0,120]] // это для теста
	// for (var i=0;i<electives.length;i++){
		// var s = electives[i][1]
		// var k = electives[i][2]
		// elective_filling:
		// {
			// for(var p=s; p<=k;p++){
				// if(time_gaps[p]!=-1 ){ //это то что происходит при конфликте
					// if (time_gaps.length<145) time_gaps.push(-2) // что-то там надо добавлять
					// time_gaps.push(electives[i][0])
					// break elective_filling
				// }
			// }
			// for(s;s<=k;s++)time_gaps[s]=electives[i][0]
		// }
	// }
	//console.log(time_gaps)
	return time_gaps
}

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
	m1=String(m1);
	m2=String(m2);
	h1=String(h1);
	h2=String(h2);
	//var M=["Начало в "+h1+':'+m1+' ','Конец в '+h2+':'+m2]
	var M=[h1+m1,h2+m2]
	return M
}

function calc_short(M,login,pass){  //На вход подается массив пятиминуток, login и pass. На выход подается (здесь) одномерный массив
	var A=['name','start','finish']; //на вывод
	A['name']=[]; //id занятия СТОЛБЕЦ
	A['start']=[]; // начало СТОЛБЕЦ
	A['finish']=[]; // конец СТОЛБЕЦ
	
	M=[0].concat(M);
	M=M.concat(0);
	
	var group_id = get_group_id(login, pass);
	
	for (var i=0;i<=M.length;i++){
		if(M[i]!=0 && M[i]!=M[i-1] && M[i]!=M[i+1]){
			if(M[i]>200&&M[i]<=210){
				var name1 = get_lesson_name(M[i], group_id, day);
				A['name'].push(name1);
				A['start'].push(time(i-1,1)[0]);
				A['finish'].push(time(1,i-1)[1]);
			} else if (M[i]>210){
				var name1 = get_lesson_name(M[i], group_id, day);
				A['name'].push(name1);
				A['start'].push(time(i-1,1)[0]);
				A['finish'].push(time(1,i-1)[1]);
			}
		}
		
		if(M[i]!=0 && M[i]!=M[i-1] && M[i]==M[i+1]){
			if(M[i]>200&&M[i]<=210){
				var name1 = get_lesson_name(M[i], group_id, day);
				A['name'].push(name1);
				A['start'].push(time(i-1,1)[0]);
			} else if (M[i]>210){
				var name1 = get_lesson_name(M[i], group_id, day);
				A['name'].push(name1);
				A['start'].push(time(i-1,1)[0]);
			}
		}
		if(M[i]!=0 && M[i]==M[i-1] && M[i]!=M[i+1]){
			A['finish'].push(time(1,i-1)[1]);
		}
	}
	A['name'].pop();
	A['start'].pop();
	console.log(A);
	var V=[];
	for (var i=0; i<=A['name'].length;i++){
		V.push(A['name'][i]);
		V.push(A['start'][i]);
		V.push(A['finish'][i]);
	}
	console.log(V);
	V.pop();V.pop();V.pop();
	var V1 = [];
	var temp = [];
	for (var i=0; i < V.length/3; i++){
		temp.push(V[3*i]);
		temp.push(V[3*i+1]);
		temp.push(V[3*i+2]);
		V1.push(temp);
		temp = [];
	}
	return V1;
}