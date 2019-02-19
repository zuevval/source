window.addEventListener("load",main,false);
function main(){
	var list1 = new Single_List();
	list1.add(1);
	list1.add(2);
	list1.add(3);
	list1.add(4);
	list1.invert();
	console.log(list1);
	
}

function Single_List(){
	this.head=null;
}
function Node_SL(value){
	this.value=value;
	this.next=null;
}

Single_List.prototype.invert=function(){
	l=this.length();
	var new_head=this.get_element_n(l-1);
	var element_i=this.head;
	var element_t=this.head;
	for (var i=1; i<l;i++){
		element_t=new Node_SL(element_i.value);
		element_t.next=new_head.next;
		new_head.next=element_t;
		element_i=element_i.next;
	}
	this.head=new_head;
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