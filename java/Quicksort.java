import java.util.Scanner;
import java.util.Random;

public class Quicksort {
	static int[] a;

	public static int divide(int beg, int end) {
		int iN = beg;
		int iO = end;
		while (iN != iO) {
			if (iN < iO) {
				if (a[iN] > a[iO]) {
					int tmp = a[iN];
					a[iN] = a[iO];
					a[iO] = tmp;
					tmp = iN;
					iN = iO;
					iO = tmp;
					iO++;
				} else {
					iO--;
				}
			} else {
				if (a[iN] > a[iO]) {
					int tmp = a[iN];
					a[iN] = a[iO];
					a[iO] = tmp;
					tmp = iN;
					iN = iO;
					iO = tmp;
					iO--;
				} else {
					iO++;
				}
			}
		}
		return iN;
	}

	public static void qsort(int beg, int end) {
		if (end > beg) {
			int num = divide(beg, end);
			qsort(beg, num - 1);
			qsort(num + 1, end);
		}
	}

	public static void main(String[] args) {
		Scanner sc = new Scanner(System.in);
		int N = sc.nextInt();
		a = new int[N];
		Random r = new Random();
		for (int i = 0; i < N; i++) {
			a[i] = r.nextInt(100);
		}
		for (int i = 0; i < N; i++) {
			System.out.println(a[i]);
		}
		qsort (0,N-1);
		for (int i = 0; i < N; i++) {
			System.out.println(a[i]);
		}
	}

}
