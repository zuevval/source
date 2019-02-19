function Single_list(){
	this.head=null;
}
function Node_SL(data){
	this.data=data;
	this.next=null;
}
Single_list.prototype.add = function(data){
	var node = new Node_SL(data);
	if(this.head == null){
		this.head=node;
	} else {
		var element_i = this.head;
		while (element_i.next != null){
			element_i = element_i.next;
		}
		element_i.next = node;
	}
}
Single_list.prototype.length = function(){
var N=1;
if(this.head == null){
	return 0
	} else {
		var element_i = this.head;
		while (element_i.next != null){
			element_i = element_i.next;
			N++
		}
		return N
	}
}
Single_list.prototype.del=function(index){
	if(this.length()<index){
		return "Error, not enough length"
	}
	var i=1
	element_i=this.head
	while(i-1<index){
		element_i = element_i.next;
	}
	var tmp=element_i.next
	
	