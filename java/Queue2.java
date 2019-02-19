import java.util.Scanner;

public class Queue2 {
	static int a[];
	static int start;
	static int size;

	public static void main(String[] args) {
		a = new int[100];
		start = 0;
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
				if (0 != size) {
					System.out.println(pop());
				} else {
					System.out.println("error");
				}
			}
			if (st1.equals("front")) {
				if (size !=0) {
					System.out.println(a[(start) % 100]);
				} else {
					System.out.println("error");
				}

			}
			if (st1.equals("size")) {
				System.out.println(size);
			}
			if (st1.equals("clear")) {
				start = 0;
				size = 0;
				System.out.println("ok");
			}
			st1 = sc.next();
		}
		System.out.println("bye");

	}

	public static void push(int num) {
		a[(start + size) % 100] = num;
		size++;
	}

	public static int pop() {
		start++;
		size--;
		return a[(start - 1) % 100];
	}
}
