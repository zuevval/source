function calc_long(login,pass,day){ //в общем для полноценного тестировангия нужно будет интегрировать уже на сервер
	var time_gaps=[];
	var Error_log=[];
	for(var i=0; i<144;i++)time_gaps.push(-1);
	// group = get_user_info(login,pass); вот это точно пока не надо
	//lessons=get_schedule(login,pass,day); ето потом тестим
	lessons=[[236,10,20]]
	console.log(lessons[0][1])
	for(var i=0;i<lessons.length;i++){
		//var id_lesson=get_id_lesson_by_name(lessons[i][0]); // мне нужен айди события, а функция получения расписания выдаёт название (мне кажется лучше передавать id события + имя в доп ячейкии массива или вообще передавать только id и сделать функцию получения  по id имени
		var id_lesson=236
		var s=lessons[i][1]
		var k=lessons[i][2] //тут творится чертовщина
		for( /* t=lessons[i][1] */s; s<=k/* t<=lessons[i][2] */;/* i++ */s++)time_gaps[s]=id_lesson;
	}
	//var nearest_deadline = get_nearest_online(login,pass)
	var possible_start=0;
	var count=1
	var nearest_deadline=[0,1488,400,"бесконченость не предел"]
	online_filling:
	{
		for(var i=0;i<144;i++){
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
	console.log(time_gaps)
}
