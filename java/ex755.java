import java.util.Scanner;

public class ex755 {
	static int l;
	static int[] a;

	public static void insert(int num) {
		l++;
		a[l] = num;
		int i = l;
		while (a[i] > a[(i - 1) / 2]) {
			a[i] = a[(i - 1) / 2];
			a[(i - 1) / 2] = num;
			i = (i - 1) / 2;
		}
	}

	public static int extract(int i) {
		int res = a[1];
		for (int j = 1; j < l; j++) {
			a[j] = a[j+1];
		}
		l--;
		return res;

	}

	public static void main(String[] args) {
		Scanner sc = new Scanner(System.in);
		int N = sc.nextInt();
		a = new int[N + 1];
		a[0] = Integer.MAX_VALUE;
		int b[] = new int[N + 1];
		for (int i = 0; i < N + 1; i++) {
			b[i] = i;
		}
		for (int i = 0; i < N; i++) {
			int flag = sc.nextInt();
			if (flag == 1) {
				System.out.println(extract(l));
			} else {
				insert(sc.nextInt());
			}
		}
		/*for (int i = 0; i <= N; i++) {
			System.out.println(a[i]);
		}*/
	}

}