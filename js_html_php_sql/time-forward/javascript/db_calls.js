function login_page_check(){
	var login=getCookie('login');
	var pass=getCookie('pass');
	console.log(login);
	var check=0;
	if(login==-1||pass==-1){
		check = -1;
	}
    else {
    	var oReq = new XMLHttpRequest();
	    oReq.onload = function() {
			//console.log(this.responseText);
			var resp=this.responseText;
			resp = resp.replace('0', '');
			console.log(resp);
			check = Number(resp);
	    };
	    oReq.open("get", "../php_server_side/check_if_logged_in.php", false);
	    oReq.send();
	    if(check==-1){
	    	document.cookie = "pass="+ '-1';
			document.cookie = "login="+ '-1';
	    }
	}
    return check;
}
function check_if_logged_in(){
	var login=getCookie('login');
	var pass=getCookie('pass');
	console.log(login);
	var check=0;
	if(login==-1||pass==-1){
		window.alert("пожалуйста, авторизуйтесь");
		check = -1;
	}
    else {
    	var oReq = new XMLHttpRequest();
	    oReq.onload = function() {
			//console.log(this.responseText);
			var resp=this.responseText;
			resp = resp.replace('0', '');
			console.log(resp);
			check = Number(resp);
	    };
	    oReq.open("get", "../php_server_side/check_if_logged_in.php", false);
	    oReq.send();
	    if(check==-1){
	    	window.alert("логин и пароль не совпадают");
	    	document.cookie = "pass="+ '-1';
			document.cookie = "login="+ '-1';
	    }
	}
    return check;
}

function redirect_to_input_page(login,pass){
	document.cookie = "pass="+pass;
	document.cookie = "login="+login;
	window.location.replace("index.php");

}

function write_schedule(login,pass,day,schedule){
	//schedule - двумерный массив
	document.cookie = "pass="+pass;
	document.cookie = "login="+login;
	document.cookie = "day="+day;
	var events_string = "";
	for (var i=0; i<schedule.length; i++){
		for (var j=0; j<schedule[i].length;j++){
			events_string=events_string+schedule[i][j];
			events_string=events_string+'*';
		}
	}
	//events_string=events_string.replace(/,/gi,'');
	console.log(events_string);
	var oReq = new XMLHttpRequest();
    oReq.onload = function() {
		var resp=this.responseText;
		resp = resp.replace('0', '');
		console.log(this.responseText);
    };
    //oReq.open("get", "php/write_schedule.php", false);
    //oReq.send();
	var PageToSendTo = "../php_server_side/write_schedule.php?";
	var VariablePlaceholder = "events_string=";
 	var UrlToSend = PageToSendTo + VariablePlaceholder + events_string;
	var oReq = new XMLHttpRequest();
    oReq.onload = function() {
		var resp=this.responseText;
		resp = resp.replace('0', '');
		console.log(this.responseText);
    };
    oReq.open("get", UrlToSend, false);
    oReq.send();
}

function write_raw_events(login,pass,day,evnts){
	//events пока - одномерный массив идентификаторов
	//идентификаторов от 0 до 12
	//важно! Каждый идентификатор трёхзначный
	document.cookie = "pass="+pass;
	document.cookie = "login="+login;
	document.cookie = "day="+day;
	var events_string = "";
	for (var i=0; i<evnts.length; i++){
		events_string=events_string+evnts[i];
	}
	console.log(evnts);
	console.log(events_string);
	var PageToSendTo = "../php_server_side/write_raw_events.php?";
	var VariablePlaceholder = "events_string=";
 	var UrlToSend = PageToSendTo + VariablePlaceholder + events_string;
	var oReq = new XMLHttpRequest();
    oReq.onload = function() {
		var resp=this.responseText;
		resp = resp.replace('0', '');
		console.log(this.responseText);
    };
    oReq.open("get", UrlToSend, false);
    oReq.send();
}

function get_online(login, pass,online_id){
	document.cookie = "pass="+pass;
	document.cookie = "login="+login;
	document.cookie = "online_id="+online_id;
	var online = [];
    var oReq = new XMLHttpRequest();
    oReq.onload = function() {
		//console.log(this.responseText);
		var resp=this.responseText;
		resp = resp.replace('0', '');
		resp = resp.replace('0', '');
		var res = resp.split('*');
		for (var i=0; i<res.length; i++){
			res[i]=res[i].trim();
		}
		for (var i=0; i<4; i++)
			res[i]=Number(res[i]);
		online=res;
		console.log(online);
    };
    oReq.open("get", "../php_server_side/get_online.php", false);
    oReq.send();
    return online.slice(0,5);
}

function get_nearest_online(login,pass){
	document.cookie = "pass="+pass;
	document.cookie = "login="+login;
	var online = [];
    var oReq = new XMLHttpRequest();
    oReq.onload = function() {
		//console.log(this.responseText);
		var resp=this.responseText;
		resp = resp.replace('0', '');
		resp = resp.replace('0', '');
		var res = resp.split('*');
		for (var i=0; i<res.length; i++){
			res[i]=res[i].trim();
			//res[i] = res[i].replace(' ', '');
			//res[i]=Number(res[i]);
		}
		for (var i=0; i<4; i++)
			res[i]=Number(res[i]);
		online=res;
		//console.log(online);
    };
    oReq.open("get", "../php_server_side/get_nearest_online.php", false);
    oReq.send();
    return online.slice(0,5);
}

function get_schedule(login,pass,day){
	//пока что будет работать неправильно, если
	//расписания ещё нет
	//пока возвращает одномерный массив-строку,
	//в которой последовательно записаны событие, начало, конец
	document.cookie = "pass="+pass;
	document.cookie = "login="+login;
	document.cookie = "day="+day;
	var schedule = [];
    var oReq = new XMLHttpRequest();
    oReq.onload = function() {
		//console.log(this.responseText);
		var resp=this.responseText;
		console.log(resp);
		resp = resp.replace('0', '');
		var res = resp.split('*');
		res = res.slice(1,res.length-1);
		var flag=0;
		for (var i=0; i<res.length; i++){
			res[i]=res[i].trim();
			if(i%3!=0)
				res[i]=Number(res[i]);
			if((res[i]==-1||res[i]==['-1'])&&flag==0)
				flag=i;
		}
		res = res.slice(0,flag);
		console.log(res);
		events=res;
    };
    oReq.open("get", "../php_server_side/get_schedule.php", false);
    oReq.send();
    return events;
}

function get_raw_events(login,pass,day){
	//пока что будет работать неправильно, если
	//событий ещё нет
	document.cookie = "pass="+pass;
	document.cookie = "login="+login;
	document.cookie = "day="+day;
	var raw_events = [];
    var oReq = new XMLHttpRequest();
    oReq.onload = function() {
		//console.log(this.responseText);
		var resp=this.responseText;
		//resp = resp.replace('0', '');
		var res = resp.split('*');
		for (var i=0; i<res.length; i++){
			res[i]=res[i].trim();
			res[i] = res[i].replace(' ', '');
			res[i]=Number(res[i]);
		}
		res = res.slice(1,res.length-1);
		//console.log(res);
		raw_events=[];
		for (var i=0; i<res.length; i++){
			if(res[i]!= -1) raw_events.push(res[i]);
		}
    };
    oReq.open("get", "../php_server_side/get_raw_events.php", false);
    oReq.send();
    return raw_events;
}

function get_group_id(login,pass){
	document.cookie = "pass="+pass;
	document.cookie = "login="+login;
	var group_id=0;
    var oReq = new XMLHttpRequest();
    oReq.onload = function() {
		//console.log(this.responseText);
		var resp=this.responseText;
		resp = resp.replace('0', '');
		//console.log('group id is '+resp);
		if(resp.length !=6) return -1;
		group_id = Number(resp);
    };
    oReq.open("get", "../php_server_side/get_group_id.php", false);
    oReq.send();
    return group_id;
}

function get_lesson_start(lesson_id,group_id,day){
	var lesson_num=lesson_id%10;
	var res=get_timetable(group_id,day);
	for (var i=0; i<res.length; i++) 
		res[i]=Number(res[i]);
	return res[lesson_num*3-1];
}

function get_lesson_stop(lesson_id,group_id,day){
	var lesson_num=lesson_id%10;
	var res=get_timetable(group_id,day);
	for (var i=0; i<res.length; i++) 
		res[i]=Number(res[i]);
	return res[lesson_num*3];
}
function get_lesson_name(lesson_id,group_id,day){
	var lesson_num=lesson_id%10;
	var res=get_timetable(group_id,day);
	return res[lesson_num+15];
}

function get_tmtbl_id (group_id,day){
	var list1 =get_timetable(group_id,day);
	var res = [];
	for (var i=0; i < 5; i++){
		if(list1[i*3+1]!=0)
			res.push(Number(list1[i*3+1]) + 200);
	}
	console.log(res);
	return res;
}

function get_timetable(group_id,day){
	document.cookie = "group_id="+group_id;
	document.cookie = "day="+day;
	var timetable=[];
	var oReq = new XMLHttpRequest();
    oReq.onload = function() {
		var resp=this.responseText;
		resp = resp.replace('0', '');
		var res = resp.split('*');
		for (var i=0; i<res.length; i++){
			res[i]=res[i].trim();
			//res[i] = res[i].replace(' ', '');
		}
		//console.log(res);
		timetable=res;
    };
    oReq.open("get", "../php_server_side/get_timetable.php", false);
    oReq.send();
    return timetable;
}

function getCookie(cname) {
    var name = cname + "=";
    var decodedCookie = decodeURIComponent(document.cookie);
    var ca = decodedCookie.split(';');
    for(var i = 0; i <ca.length; i++) {
        var c = ca[i];
        while (c.charAt(0) == ' ') {
            c = c.substring(1);
        }
        if (c.indexOf(name) == 0) {
            return c.substring(name.length, c.length);
        }
    }
    return -1;
}