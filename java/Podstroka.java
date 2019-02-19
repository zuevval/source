//с исправленным багом
import java.util.Scanner;

public class Podstroka {
	public static void main(String[] args) {
		// Scanner sc = new Scanner(System.in);
		Scanner in = new Scanner(System.in);
		String n = in.next();
		String m = in.next();
		int N = n.length();
		int M = m.length();
		int[][] a = new int[N + 1][M + 1];
		int max = 0, mi = 0, mj = 0;
		for (int i = 1; i <= N; i++) {
			char ci = n.charAt(i - 1);
			for (int j = 1; j <= M; j++) {
				char cb = m.charAt(j - 1);
				if (ci == cb) {
					a[i][j] = a[i - 1][j - 1] + 1;
					if (max < a[i][j]) {
						max = a[i][j];
						mi = i;
						mj = j;
					}
				}
			}
		}
		String res = "";
		for (int i = mi - max + 1; i <= mi; i++) {
			res += n.charAt(i - 1);
		}

		System.out.println(res);
	}
}