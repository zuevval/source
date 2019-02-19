import java.util.Scanner;

public class ex765 {
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
		traverse (root);
		// System.out.println(traverse(root));
		// System.out.println(deep(root, 0));
	}

	public static Node add(Node root, int x) {
		if (root == null) {
			root = new Node();
			root.value = x;
			root.num = 1;
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
		if (x == root.value) {
			root.num = root.num + 1;
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

	public static void traverse(Node root) {
		if (root == null)
			return;
		traverse(root.left);
		System.out.println(root.value + " " + root.num);
		traverse(root.right);
	}

}

class Node {
	Node parent, left, right;
	int value, num;
}
