import java.util.Scanner;
public class ex207 {
	public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        int n = sc.nextInt();
        long[] a = new long[n+1];
        long[] b = new long[n+1];
        a[1] = 1;
        b[1] = 1;
        if (n >= 2) {
            for (int i = 2; i <= n; i++) {
                a[i] = a[i-1] + b[i-1];
                b[i] = a[i-1];
            }
        }
        System.out.println(a[n] + b[n]);
    }
}