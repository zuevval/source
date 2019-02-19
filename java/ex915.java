import java.util.Scanner;
public class ex915 {
	public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        int n = sc.nextInt();
        int[] g = new int[n];
        for (int i = 0; i < n; i++) {
        	g[i] = sc.nextInt();
        }
        int[] a = new int[n];
        a[0] = g[0];
        if (n >= 2) {
        	a[1] = g[1];
            for (int i = 2; i < n; i++) {
                a[i] = Math.min(a[i-1], a[i-2])+ g[i];
            }
        }
        System.out.println(a[n-1]);
    }
}
