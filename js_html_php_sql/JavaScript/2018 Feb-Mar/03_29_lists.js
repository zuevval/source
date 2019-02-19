window.addEventListener("load",main,false);
function main(){
	var list1 = new Single_List();
	console.log('list length is '+list1.length());
	list1.add(10);
	console.log('added element')
	console.log('list length is '+list1.length());
	var a=0;
	console.log('element no '+a+' is '+list1.get_element_n(a).value);
	a=1
	console.log('element no '+a+' is '+list1.get_element_n(a))
	log_remove=list1.remove(a);
	console.log('tried to remove element no '+a);
	console.log('removed element no '+log_remove);
	list1.add(20);
	console.log('added element')
	list1.add(30);
	console.log('added element')
	list1.add(40);
	console.log('added element')
	list1.add(50);
	console.log('added element')
	console.log('list length is '+list1.length());
	a=1;
	console.log('element no '+a+' is '+list1.get_element_n(a).value);
	a=0;
	log_remove=list1.remove(a);
	console.log('tried to remove element no '+a);
	console.log('removed element no '+log_remove);
	console.log('list length is '+list1.length());
	console.log('element no '+a+' is '+list1.get_element_n(a).value);
	a=1;
	console.log('element no '+a+' is '+list1.get_element_n(a).value);
	log_remove=list1.remove(a);
	console.log('tried to remove element no '+a);
	console.log('removed element no '+log_remove);
	console.log('list length is '+list1.length());
	console.log('element no '+a+' is '+list1.get_element_n(a).value);
	a=2;
	console.log('element no '+a+' is '+list1.get_element_n(a).value);
	list1.invert();
}

function Single_List(){
	this.head=null;
}
function Node_SL(value){
	this.value=value;
	this.next=null;
}

Single_List.prototype.add=function(value){
	var node = new Node_SL(value);
	if(this.head==null)
		this.head=node;
	else {
		var nodi=this.head;
		while(nodi.next!=null)
			nodi=nodi.next;
		nodi.next=node;
	}
}

Single_List.prototype.length=function(){
	if(this.head==null)
		return 0;
	var N=1;
	var nodi=this.head;
	while(nodi.next!=null){
		nodi=nodi.next;
		N++;
	}
	return N;
}
Single_List.prototype.get_element_n=function(n){
	if(this.head==null)
		return null;
	var nodi=this.head;
	for (var i=1; i<=n; i++){
		if(nodi.next==null)
			return null;
		nodi=nodi.next;
	}
	//returns node No.(n) (countiog from 0)
	return nodi;
}
Single_List.prototype.remove=function(k){
	//removes element No.(k) (countig from 0)
	if(this.get_element_n(k)!=null){
		if(k==0)
			this.head=this.head.next;
		else
			this.get_element_n(k-1).next=this.get_element_n(k).next;
		return k;
	}
	return -1;
	
}

Single_List.prototype.invert=function(){
	l=this.length();
	var new_head=this.get_element_n(l-1);
	var element_i=this.head;
	var element_i=this.head;
	for (var i=1; i<l;i++){
		element_t=new Node_SL(element_i.value);
		element_t.next=new_head.next;
		new_head.next=element_t.next;
		element_i=element_i.next;
	}
	this.head=new_head;
}