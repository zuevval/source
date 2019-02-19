window.addEventListener("load",main_prog,false);
function main_prog(){
	// var single_list={};
	// single_list.head=null;
	
	// var first_element = {};
	// first_element.data=12;
	// first_element.next=null;
	// single_list.head=first_element;
	
	// var second_element={};
	// second_element.data=99;
	// second_element.next=null;
	// first_element.next=second_element;
	
	// var third_element={};
	// third_element.data=37;
	// third_element.next=null;
	// second_element.next=third_element;
	
	// var element_i = single_list.head
	// while (element_i != null) {
		// console.log(element_i.data);
		// element_i = element_i.next;
	// }
	// console.log(single_list)
	// начало второй части
	// var single_list = new Single_list();
	// var first_element = new Node_SL(12);
	// var second_element = new Node_SL(99);
	// var third_element = new Node_SL (37);
	
	// single_list.head=first_element;
	// first_element.next=second_element;
	// second_element.next=third_element;
	
	// var element_i = single_list.head
	// while (element_i != null) {
		// console.log(element_i.data);
		// element_i = element_i.next;
	// }
	// console.log(single_list)
	//начало третьей части
	
	var single_list = new Single_list();
	single_list.add(77);
	single_list.add(78);
	single_list.add(79);
	console.log(single_list)
	console.log(single_list.length())
}	