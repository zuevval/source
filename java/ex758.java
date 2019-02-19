import java.util.ArrayList;
import java.util.Scanner;

public class ex758 {
	static Node root = null;

	public static void main(String[] args) {
		Scanner sc = new Scanner(System.in);
		int flag = sc.nextInt();
		while (flag != 0) {
			if (root != null) {
				Node n = add(root, flag);
			} else {
				if (find(root, flag) == false)
					root = add(root, flag);
			}
			flag = sc.nextInt();
		}
		int num = 0;
		int  prenum = -1;
		prenum = traverse1 (root, num, prenum);
		System.out.println(prenum);
		// System.out.println(traverse(root, 0));
		// System.out.println(deep(root, 0));
	}

	public static Node add(Node root, int x) {
		if (root == null) {
			root = new Node();
			root.value = x;
			root.left = null;
			root.right = null;
			return root;
		}
		if (x < root.value) {
			root.left = add(root.left, x);
			return root;
		}
		if (x > root.value) {
			root.right = add(root.right, x);
			return root;
		}
		return root;
	}

	public static boolean find(Node root, int x) {
		if (root == null) {
			return false;
		}
		if (root.value == x) {
			return true;
		}
		if (x < root.value) {
			return find(root.left, x);
		}
		return find(root.right, x);
	}

	public static int deep(Node root, int num) {
		if (root == null) {
			return 0;
		}
		num = 1 + deep(root.left, num);
		if (num < 1 + deep(root.right, num))
			num = 1 + deep(root.right, num);
		return num;
	}

	public static int traverse(Node root, int num) {
		if (root == null) {
			return 0;
		}
		num = 1 + traverse(root.left, num);
		num = num + traverse(root.right, num);
		return num;
	}

	public static int traverse1(Node root, int num, int prenum) {
		if (root == null)
			return num;
		if (root.value > num) {
			prenum = num;
			num = root.value;
		}else if (root.value > prenum) {
			prenum = root.value;
		}
		traverse1(root.left, num, prenum);
		traverse1(root.right, num, prenum);
		return (prenum);
	}
}

class Node {
	Node parent, left, right;
	int value;
}
