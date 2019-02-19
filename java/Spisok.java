class Node {
	int value;
	Node next;
	Node prev;
}

public class Spisok {
	static Node head, tail;

	public static void main(String[] args) {
		head = null;
		tail = null;
		addFirst(5);
		addFirst(1);
		addFirst(10);
		System.out.println(get(1));
		delFirst();
		System.out.println(get(1));
		delFirst();
		System.out.println(get(0));
		System.out.println(get(1));
		System.out.println(get(-1));
		addLast(3);
		addLast(4);
		System.out.println(get(3));
		insertAfter(1, 45);
		System.out.println(get(2));
		delAfter (1);
	}

	public static void addFirst(int num) {

		Node tmp = new Node();
		tmp.value = num;
		tmp.prev = null;
		if (head != null) {
			tmp.next = head;
			tmp.next.prev = tmp;
		}
		head = tmp;
		if (tail == null) {
			tail = tmp;
		}
	}

	public static void addLast(int num) {
		Node tmp = new Node();
		tmp.value = num;
		tmp.next = null;
		if (tail != null) {
			tmp.prev = tail;
			tmp.prev.next = tmp;
		}
		tail = tmp;
		if (head == null) {
			head = tmp;
		}

	}

	public static void insertAfter(int num, int I) {
		Node tmp = head;
		if (head != null) {
			for (int i = 1; i < num; i++) {
				if (tmp.next == null) {
					break;
				}
				tmp = tmp.next;
			}
		}
		Node ins = new Node();
		ins.value = I;
		ins.next = tmp.next;
		if (ins.next != null) {
			ins.next.prev = ins;
		} else {
			tail = ins;
		}
		if (head != null) {
			ins.prev = tmp;
			tmp.next = ins;
		} else {
			head = ins;
			head.prev = null;
		}
	}
	public static void insertBefore(int num, int I) {
		insertAfter (num-1, I);
	}

	public static int get(int num) {
		Node tmp = head;
		if (head != null) {
			for (int i = 1; i < num; i++) {
				if (tmp.next == null) {
					break;
				}
				tmp = tmp.next;
			}
			return tmp.value;
		}
		return -1;
	}

	public static int delFirst() {
		if (head != null) {
			head.next.prev = null;
			int res = head.value;
			head = head.next;
			return res;

		} else {
			return -1;
		}

	}
	public static int delAfter(int num) {
		Node tmp = head;
		if (head != null) {
			for (int i = 1; i <= num; i++) {
				if (tmp.next == null) {
					break;
				}
				tmp = tmp.next;
			}
		}
		if (tmp != null) {
			if (tmp.next != null){
			tmp.next.prev = tmp.prev;
			}
			if (tmp != head) {
			tmp.prev.next = tmp.next;
			}
			int res = tmp.value;
			return res;

		} else {
			return -1;
		}

	}
	public static void delBefore(int num) {
		delAfter(num-2);
	}

	public static int delLast() {
		if (tail != null) {
			tail.prev.next = null;
			int res = tail.value;
			tail = tail.next;
			return res;

		} else {
			return -1;
		}
	}
}
