window.addEventListener("load",main,false);
function main(){
	dl1=new Double_List();
	for (var i=0; i<100; i++)
		dl1.add(i);
	console.log(dl1);
	console.log(dl1.length());
	//dl1.remove_if_more_than(3);
	console.log(dl1.get_element_n(10));
	console.log('removed '+dl1.remove(10));
}

function Double_List(){
	this.head=null;
}
function Node_DL(value){
	this.value=value;
	this.next=null;
	this.prev=null;
}

Double_List.prototype.add=function(value){
	var node = new Node_DL(value);
	if(this.head==null)
		this.head=node;
	else {
		var nodi=this.head;
		while(nodi.next!=null)
			nodi=nodi.next;
		nodi.next=node;
		node.prev=nodi;
	}
}

Double_List.prototype.length=function(){
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

Double_List.prototype.remove=function(k){
	//removes element No.(k) (countig from 0)
	if(this.get_element_n(k)!=null){
		if(k==0){
			this.head=this.head.next;
			this.head.prev=null;
		}
		else{
			this.get_element_n(k-1).next=this.get_element_n(k).next;
			this.get_element_n(k).prev=this.get_element_n(k);
		}
		return k;
	}
	return -1;
}

Double_List.prototype.get_element_n=function(n){
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

Double_List.prototype.remove_if_more_than = function(x){
	var M = [];
	var t=this.head;
	if (t!=null){
		var i=0;
		if(t.value>x) M.push(0); 
		while (t.next!=null){
			if (t.value > x) M.push(i);'
			i++;
			t=t.next;
		}
		for (var i = M.length(); i >=0; i--){
			this.remove(M[i]);
		}
	}
}

// Double_List.prototype.remove_if_more_than = function(x){
	// var t=this.head;
	// while (t.next != null) {
		// if (t.value>x)
		// t1=t.next;
		// t.next.prev=t.prev;
		// t.prev.next=t.next;
		// t=t1;
	// }
	// if (t.value > x){}
		
// }