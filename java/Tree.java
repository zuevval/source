import java.util.Scanner;

class Node {
	Node parent, left, right;
	int value;
}

public class Tree {
	static Node root = null;

	public static void main(String[] args) {
		Scanner sc = new Scanner(System.in);
		root = new Node();
		root.value = sc.nextInt();
		for (int i = 0; i < 5; i++) {
			Node node = add(root, sc.nextInt());
			System.out.println(find(root, 0));
			if (findRef(root, 0) != null) {
				System.out.println(findRef(root, 0).value);
			} else {
				System.out.println("нет такого");
			}
			if (findRef(root, 1) != null) {
				System.out.println(findRef(root, 1).value);
			} else {
				System.out.println("нет такого");
			}
		}
		traverse(root);
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

	public static Node findRef(Node root, int x) {
		if (root == null) {
			return null;
		}
		if (root.value == x) {
			return root;
		}
		if (x < root.value) {
			return findRef(root.left, x);
		}
		return findRef(root.right, x);
	}

	public static Node add(Node root, int x) {
		if (root == null) {
			root = new Node();
			root.value = x;
			root.left = null;
			root.right = null;
		}
		if (x < root.value) {
			root.left = add(root.left, x);
			return root;
		}
		if (x >= root.value) {
			root.right = add(root.right, x);
			return root;
		}
		return root;
	}

	public static void traverse(Node root) {
		if (root == null)
			return;
		traverse(root.left);
		System.out.println(root.value);
		traverse(root.right);
	}
	public static void remove (Node root, int x) {
		if (x < root.value) {
			remove(root.left, x);
		}
		if (x > root.value) {
			remove(root.right, x);
		}
		if (x == root.value) {
			root = null;
		}
	}

}
