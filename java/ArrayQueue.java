public class ArrayQueue implements IQueue {
	int a[];
	int start = 0;
	int size = 0;

	public void push(int num) {
		a[start + size] = num;
		size++;
	}

	public int pop() {
		start++;
		size--;
		return a[size];
	}

}
