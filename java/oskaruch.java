import java.util.Scanner;

public class oskaruch {
	public static void main(String[] args) {
		Scanner sc = new Scanner(System.in);
		int x = sc.nextInt();
		int y = sc.nextInt();
		int N = sc.nextInt();
		int M = sc.nextInt();
		int[][] A = new int[N + 1][M + 1];
		for (int i = 1; i <= N; i++) {
			for (int j = 1; j <= M; j++) {
				A[i][j] = sc.nextInt();
			}
		}
		int flagi = 0;
		int flagj = 0;
		int[][] n = new int[N + 1][M + 1];
		n[1][1] = 0;
		int[][] F = new int[N + 1][M + 1];
		F[1][1] = A[1][1] + y;
		
		int[][] res = new int[N + 1][M + 1];
		res[1][1] = n[1][1] - F[1][1];// =0 - A[1][1] - y + x*0
		for (int i = 1; i <= N; i++) {
			// n[i][1] = n[i-1][1] + 1;
			res[i][1] = res[i - 1][1] + 1 + x * i - A[i][1];
			flagi = res[i][1];
			for (int a = 1; a < i; a++) {
				if (res[a][1] + (i - a) * (x + 1) - A[i][1] > flagi) {
					flagi = res[a][1] + (i - a) * (x + 1) - A[i][1];
				}
			}
		}
		for (int j = 1; j <= N; j++) {
			// n[i][1] = n[i-1][1] + 1;
			res[1][j] = res[1][j -1] + 1 + x * j - A[1][j];
			flagj = res[1][j];
			for (int a = 1; a < j; a++) {
				if (res[1][a] + (j - a) * (x + 1) - A[1][j] > flagj) {
					flagj = res[1][a] + (j - a) * (x + 1) - A[1][j];
				}
			}
		}
		
		for (int i = 2; i <= N; i++) {
			for (int j = 2; j <= M; j++) {
				res[i][1] = res[i - 1][1] + 1 + x * i - A[i][1];
				flagi = res[i][j];
				flagj = res[i][j];
				for (int a = 1; a < i; a++) {
					if (res[a][j] + (i - a) * (x + 1) - A[i][j] > flagi) {
						flagi = res[a][j] + (i - a) * (x + 1) - A[i][j];
					}
				}
				for (int b = 1; b < j; b++) {
					if (res[i][b] + (j - b) * (x + 1) - A[i][j] > flagi) {
						flagj = res[i][b] + (j - b) * (x + 1) - A[i][j];
					}
				}
				res[i][j] = Math.min(flagi, flagj);
			}
		}
		System.out.println(res[N][M]);
	}
}
