import java.util.Scanner;

public class ex756 {
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
		int res = a[i];
		for (int j = i; j < l+i; j++) {
			a[j] = a[j + 1];
		}
		l--;
		return res;

	}

	public static void main(String[] args) {
		Scanner sc = new Scanner(System.in);
		int N = sc.nextInt();
		int K = sc.nextInt();
		a = new int[N + 1];
		int b[] = new int[N + 1];
		for (int i = 0; i < N + 1; i++) {
			b[i] = i;
		}
		for (int i = 1; i <= N-K+1; i++) {
			l=K;
			while(b[i] < i) {
				extract(i);
			}
		}
		/*
		 * for (int i = 0; i <= N; i++) { System.out.println(a[i]); }
		 */
	}

}