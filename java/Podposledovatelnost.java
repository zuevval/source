import java.util.Scanner;

public class Podposledovatelnost {
	public static void main(String[] args) {
		Scanner sc = new Scanner(System.in);
		int l = sc.nextInt();
		int[] a = new int[l];
		for (int i = 0; i < l; i++) {
			a[i] = sc.nextInt();
		}
		sc.close();
		int[] d = new int[l];
		for (int i = 0; i < l; i++) {
			d[i] = 1;
		}
		int flag = -1;
		int min = Integer.MAX_VALUE;
		for (int i = 0; i < l; i++) {
			if (a[i] < min) {
				min = a[i];
			}
			for (int k = 0; k <= i; k++) {
				if (a[i] > a[i - k]) {
					d[i] = Math.max(d[i], d[i - k] + 1);
				}
			}
			if (d[i] > flag) {
				flag = d[i];
			}
		}
		int[] res = new int[flag];
		int b = 0;
		int c = flag + 1;
		for (int i = l-1; i > -1; i--) {
			if (b == 0) {
				if (d[i] == flag) {
					b = 1;
				}
			}
			if (b == 1) {
				if (d[i] == c-1) {
					res[c-2] = a[i];
					c = c-1;
				}
			}
		}
		 for (int i = 0; i < flag; i++) {
			 System.out.print(res[i]);
		 }

		// System.out.println(flag);
		// System.out.println(min);
	}
}