import java.util.Scanner;

public class stairsphtsh {

	public static void main(String[] args) {
		Scanner sc = new Scanner (System.in);
		int n = sc.nextInt ();
		int [] arr = new int [n+1];
		for (int i = 1; i < n+1; i ++) {
			arr[i] = sc.nextInt ();
		}
		sc.close();
		int m = 0;
		if (n%2 != 0) {
			m = m+1;
		}
		m = m+ n/2;
		int[][] A = new int [n][m];
		int[][] G = new int [n][m];
		
		for (int i = 0; i < n; i ++) {
			for (int j = 0; j < m; j++) {
				G [i][j] = arr [i+1 + 2*j];
			}
		}
		A[0][0] = arr[1];
		for (int i = 1; i < n; i ++) {
			A [i][0] = G[i][0] + A [i-1][0];
		}
		printTable("A", A);
		printTable("G", G);
		for (int j = 1; j < m; j ++) {
			A [0][j] = G[0][j] + A [0][j-1];
		}
		for (int i = 1; i < n; i ++) {
			for (int j = 1; j < m; j++) {
				A [i] [j] = Math.min (A[i-1][j], A [i][j-1]) + G [i][j];
			}
		}
		printTable("final A", A);
		printTable("final G", G);
		System.out.println(A[n-1][m-1]);
	}

	static void printTable(String name, int[][] t) {
		System.out.println("Table " + name + "\n------------------");
		for (int j=0; j < t[0].length; j++) {
			for (int i=0; i < t.length; i++) {
				System.out.print(t[i][j] + " ");
			}
			System.out.println();
		}
	}
}
