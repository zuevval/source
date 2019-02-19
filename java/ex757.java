import java.util.LinkedList;
import java.util.Queue;
import java.util.Scanner;

class Node {
	Node parent, left, right;
	int value;
}

public class ex757 {
	static Node root = null;

	public static void main(String[] args) {
		Scanner sc = new Scanner(System.in);
		int flag = sc.nextInt();
		while (flag != 0) {
			Node n = add(root, flag);
			flag = sc.nextInt();
		}
		System.out.println(BFS(root));
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
		if (x >= root.value) {
			root.right = add(root.right, x);
			return root;
		}
		return root;
	}

	public static int BFS(Node root) {
		LinkedList<Node> q = new LinkedList<Node>();
		q.add(root);
		while (q.isEmpty() == false) {
			Node tmp = q.remove();

			if (tmp.left != null)
				q.add(tmp.left);
			if (tmp.right != null)
				q.add(tmp.right);
		}
		int h = 0;
		if (q.size() == 1) {
			h = 1;
		} else {
			int f = 1;
			for (int i = 2; i <= q.size(); i++) {
				if (q.get(i).value < q.get(i - 1).value) {
					f = f + 1;
				} else {
					if (f > h) {
						h = f;
					}
					f = 0;
				}
			}
		}
		return h;

	}

	public static int traverseH(Node root) {
		// if (root == null)
		// return;
		int h1 = 0;
		int h2 = 0;
		int h = 0;
		while (root != null) {
			traverseH(root.left);
			h1 = h1 + 1;
		}
		while (root != null) {
			traverseH(root.right);
			h2 = h2 + 1;
		}
		h = Math.max(h1, h2);
		return h;
	}
}
