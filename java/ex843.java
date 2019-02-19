import java.util.Scanner;
public class ex843 {
	public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        int n = sc.nextInt();
        int[] arr = new int[n + 3];
        arr[0] = 1;
        arr[1] = 1;
        if (n >= 2) {
            arr[2] = 2;
            for (int i = 1; i <= n/2; i++) {
                arr[2*i] = arr[i - 1] + arr[i];
                arr[2*i + 1] = -arr[i - 1] + arr[i];
            }
        }
        System.out.println(arr[n]);
    }
}
