window.addEventListener("load",main,false);
function main(){
	cl1=new Cycle_list();
	for (var i=1; i<31;i++)
	cl1.add(i);
	console.log(cl1);
	var e= cl1.head;
	var k=1;
	while(e.next!=e){
		while (k<4){
			e=e.next;
			k++;
		}
		k=0;
		e.next=e.next.next;
	}
	cl1.head=e;
	/*for (var i=0; i<30; i++)
	flag=cl1.remove(5)
	flag=cl1.remove(5)
	flag=cl1.remove(5)
	flag=cl1.remove(5)
	flag=cl1.remove(5)*/
	console.log(cl1);
	console.log(flag);
	
}


function Node_CL(data){
	this.value=data;
	this.next=null;
}

function Cycle_list(){
	this.head=null;
}

Cycle_list.prototype.add = function(data) {
	var node = new Node_CL(data);
	if(this.head==null){
		this.head = node;
		node.next=node;
 	} else {
		var element_i = this.head;
		while (element_i.next != this.head) {
			element_i=element_i.next;
		}
	element_i.next = node;
	node.next = this.head;
	}
}

Cycle_list.prototype.remove1 = function(n) {
	if(this.head==null)
		return -1;
	var element_i=this.head;
	for (var i=0; i<n-1;i++)
		element_i=element_i.next;
	console.log(element_i.value);
	if(element_i.next==this.head) {
		this.head=element_i.next.next;
		element_i.next=element_i.next.next;
	} else{
		element_i.next=element_i.next.next;
	}
}

Cycle_list.prototype.remove = function(n){
	//по какой-то причине сравнение this.head.next==this.head не работает
	if(this.head!=null||this.head.next==this.head)
		var element_i=this.head;
	else return -1;
	for(var i=0; i<n-1; i++){
		element_i=element_i.next;
	}
	element_i.next=element_i.next.next;
	return n;
	
}

//функция, удаляющая каждый пятый элемент до тех пор, пока не останется один
//развернуть односвязный список. не создавая новый