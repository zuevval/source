import java.util.Scanner;

public class Stack {
	static int[] a;
	static int size;

	public static void main(String[] args) {
		a = new int[100];
		size = 0;
		Scanner sc = new Scanner(System.in);
		String st1 = sc.next();
		System.out.println();
		while (!st1.equals("exit")) {
			if (st1.equals("push")) {
				push(sc.nextInt());
				System.out.println("ok");
			}
			if (st1.equals("pop")) {
				if (size == 0) {
					System.out.println("error");
				} else {
					System.out.println(pop());
				}
			}
			if (st1.equals("back")) {
				if (size == 0) {
					System.out.println("error");
				} else {
					System.out.println(back());
				}
			}
			if (st1.equals("size")) {
				System.out.println(size());
			}
			if (st1.equals("clear")) {
				clear();
				System.out.println("ok");
			}
			st1 = sc.next();
		}
		System.out.println("bye");

	}

	public static void push(int num) {
		a[size] = num;
		size++;
	}

	public static int pop() {
		size--;
		return a[size];
	}

	public static int back() {
		return a[size - 1];
	}

	public static int size() {
		return size;
	}

	public static void clear() {
		size = 0;
	}

}