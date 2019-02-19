import java.util.Scanner;

public class ex2968 {

	public static void main(String[] args) {
		Scanner sc = new Scanner(System.in);
		int n = sc.nextInt();
		int[] A = new int[n + 1];
		int[] B = new int[n + 1];
		int[] C = new int[n + 1];
		A[1] = 0;
		B[1] = 0;
		int x, y = 0, z = 0;
		for (int i = 2; i <= n; i++) {
			x = n;
			y = n;
			z = n;
			if (i % 3 == 0) {
				x = A[i / 3];
			}
			if (i % 2 == 0) {
				y = A[i / 2];
			}
			z = A[i - 1];
			
			A[i] = Math.min(Math.min(x, y), Math.min(x, z)) + 1;
			//System.out.println("A" + i + ": " + A[i]);
			if (x == A[i] - 1) {
				B[i] = i / 3;
			}  if (y == A[i] - 1) {
				B[i] = i / 2;
			}  if (z == A[i] - 1) {
				B[i] = i - 1;
			}
			//System.out.println("B" + i + ": " + B[i]);
		}
		int flag = n;
		while (flag != 1) {
			if (B[flag] == flag/3) {
				C[flag] = 3;
			} else if (B[flag] == flag/2) {
				C[flag] = 2;
			} else C[flag] = 1;
			flag = B[flag];
		}
		for (int i = 0; i < C.length; i++) {
			if(C[i] != 0) {
				System.out.print(C[i]);
			}
		}
		//System.out.println(A[n]);
	}
}
