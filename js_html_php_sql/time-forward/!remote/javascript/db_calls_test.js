window.addEventListener("load", main, false);

function main () {
	document.cookie = "pass="+'qwerty';
	document.cookie = "login="+'zuev';
	//предыдущие строки следует заменить на чтение из полей ввода
	check_if_logged_in();
	var login=getCookie('login');
	var pass=getCookie('pass');
	var today=0;
	var tomorrow=1;
	var raw_events=get_raw_events(login,pass,today);
	console.log('raw events are '+raw_events);
	var group_id=get_group_id(login,pass);
	console.log('group id is '+group_id);
	var lesson_start=get_lesson_start(201,group_id,today);
	//возвращает номер пятиминутки
	console.log('lesson starts at '+lesson_start);
	var lesson_stop=get_lesson_stop(201,group_id,today);
	//возвращает номер пятиминутки
	console.log('lesson ends at '+lesson_stop);
	var lesson_name=get_lesson_name(201,group_id,today);
	console.log("lesson is "+lesson_name);
	var onl=get_nearest_online(login,pass);
	console.log('nearest online is '+onl);
	get_online(login,pass,213);
	var evnts = [201, 202, 203];
	write_raw_events(login,pass,tomorrow,evnts);
	var schedule= [['история',120,140]];
	schedule[1]=['матмоделирование',144,164];
	schedule[2]=['физкультура',168,188];
	//console.log(schedule);
	write_schedule(login,pass,tomorrow,schedule);
	var s=get_schedule(login,pass,tomorrow);
	console.log(s);
	button1.onclick=function(login,pass){
		redirect_to_input_page(login,pass);
	}
}