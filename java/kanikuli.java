import java.util.Scanner;

public class kanikuli {

	public static void main(String[] args) {
		Scanner sc = new Scanner(System.in);
		int n = sc.nextInt();
		int[] a = new int[n];
		for (int i = 0; i < n; i++) {
			a[i] = sc.nextInt();
		}
		int m = sc.nextInt();
		int[] b = new int[m];
		for (int i = 0; i < m; i++) {
			b[i] = sc.nextInt();
		}
		sc.close();
		int[][] d = new int[n][m];
		for (int i = 0; i < n; i++) {
			for (int j = 0; j < m; j++) {
				if (a[i] == b[j]) {
					d[i][j] = 1;
				}
			}
		}
		int flag = 0, flagi = 0, flagj = 0;
		for (int i = 0; i < n - 1; i++) {
			for (int j = 0; j < m - 1; j++) {
				if (d[i][j] > 0) {
					for (int x = i + 1; x < n; x++) {
						for (int y = j + 1; y < m; y++) {
							if (d[x][y] > 0 && d[x][y] < d[i][j] + 1
									&& a[x] >= a[i]) {
								d[x][y] = d[i][j] + 1;
								if(d[x][y] > flag) {
									flag = d[x][y];
									flagi = x;
									flagj = y;
								}
							}
						}
					}
				}
			}
		}
		int[] r = new int[flag];
		r[r.length-1] = a[flagi];
		for (int z = flag-1; z > 0; z--) {
			for (int i = 0; i < flagi; i++) {
				for (int j = 0; j < flagj; j++) {
					if(d[i][j] == z && a[i] < a[flagi]) {
						r[z-1] = a[i];
						flagi = i;
						flagj = j;
					}
				}
			}
		}
		for (int i = 0; i < flag; i++) {
			System.out.print (r[i] + " ");
		}
	}

}
