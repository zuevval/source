import java.util.Arrays;
import java.util.Random;

public class Heapify {
	static int[] ta;
	static int l;
	static int[] a;

	public static void heap(int num) {
		int x = a[num] + 1;
		int y = a[num] + 1;
		if (2 * num + 2 < l)
			y = a[2 * num + 2];
		if ((x <= a[num]) && (x <= y)) {
			int tmp = a[num];
			a[num] = a[2 * num + 1];
			a[2 * num + 1] = tmp;
			heap(2 * num + 1);
		} else if ((y <= a[num]) && (y <= x)) {
			int tmp = a[num];
			a[num] = a[2 * num + 2];
			a[2 * num + 2] = tmp;
			heap(2 * num + 2);
		}
	}

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

	public static void merge(int begin1, int begin2, int end2) {
		int end1 = begin2 - 1;
		int i1 = begin1;
		int i2 = begin2;
		int ti = begin1;
		while ((i1 <= end1) && (i2 <= end2)) {
			if (a[i1] < a[i2]) {
				ta[ti] = a[i1];
				i1++;
			} else {
				ta[ti] = a[i2];
				i2++;
			}
			ti++;
		}
		while (i1 <= end1) {
			ta[ti] = a[i1];
			ti++;
			i1++;
		}
		while (i2 < end2) {
			ta[ti] = a[i2];
			ti++;
			i2++;
		}
		for (int i = begin1; i <= end2; i++) {
			a[i] = ta[i];
		}
	}

	public static void mergeSort(int begin, int end) {
		if (end - begin <= 0) {
			return;
		}
		int m = (end + begin) / 2;
		mergeSort(begin, m);
		mergeSort(m + 1, end);
		merge(begin, m + 1, end);
	}

	public static void main(String[] args) {

		Random r = new Random();
		int N = 50000;
		l = N;

		System.out.println("N");
		for (int i1 = 0; i1 <= 20; i1++) {
			System.out.println(N);
			N = N + 2050000;
		}
		System.out.println("heap sort ");
		N = 50000;

		for (int i1 = 0; i1 <= 20; i1++) {

			l = N;
			a = new int[N];
			ta = new int[N];
			for (int i = 0; i < N; i++) {
				a[i] = r.nextInt();
			}
			long beg = System.currentTimeMillis();
			/*for (int i = N - 1; i >= 0; i--)
				heap(i);
			for (int i = 0; i < N; i++) {
				int tmp = a[0];
				a[0] = a[l - 1];
				a[l - 1] = tmp;
				l--;
				heap(0);
			}*/
			long time1 = System.currentTimeMillis() - beg;
			System.out.println(time1);
			N = N + 2050000;
		}

		N = 50000;
		System.out.println("java sort");
		/*for (int i1 = 0; i1 <= 20; i1++) {

			l = N;
			a = new int[N];
			ta = new int[N];
			for (int i = 0; i < N; i++) {
				a[i] = r.nextInt();
			}
			long beg2 = System.currentTimeMillis();
			Arrays.sort(a);
			long time2 = System.currentTimeMillis() - beg2;
			System.out.println(time2);
			N = N + 2050000;
		}
		System.out.println("merge sort");
		N = 50000;
		for (int i1 = 0; i1 <= 20; i1++) {

			for (int i = 0; i < N; i++) {
				a[i] = r.nextInt();
			}
			long beg3 = System.currentTimeMillis();
			mergeSort(0, N - 1);
			long time3 = System.currentTimeMillis() - beg3;
			System.out.println(time3);
			N = N + 2050000;
		}*/
		N = 50000;
		System.out.println("quick sort");
		for (int i1 = 0; i1 <= 20; i1++) {

			l = N;
			a = new int[N];
			for (int i = 0; i < N; i++) {
				a[i] = r.nextInt(1000);
			}
			long beg2 = System.currentTimeMillis();
			qsort(0, N - 1);
			long time2 = System.currentTimeMillis() - beg2;
			System.out.println(time2);
			N = N + 2050000;
		}

	}
}