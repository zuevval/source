import java.util.Scanner;

public class ex759 {
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
		boolean b = true;
		traverse(root, b);
		if (b = true)
		System.out.println("YES");
		if (b = false)
			System.out.println("NO");
		// System.out.println(traverse(root));
		// System.out.println(deep(root, 0));
	}

	public static boolean traverse(Node root, boolean b) {
		if (root == null)
			return true;
		b = traverse(root.left, b);
		if (deep(root.left, 0) > deep(root.right, 0) + 1) {
			if (deep(root.left, 0) < deep(root.right, 0) - 1) {
				return false;
			}
		}
		b = traverse(root.right, b);
		return b;
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
}

class Node {
	Node parent, left, right;
	int value;
}