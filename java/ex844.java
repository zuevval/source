import java.util.Scanner;

public class ex844 {
	public static void main(String[] args) {
		Scanner sc = new Scanner(System.in);
		int n = sc.nextInt();
		int[] arr = new int[n + 6];
		arr[0] = 1;
		arr[1] = 1;
		if (n >= 2) {
			arr[2] = 2;
			for (int i = 1; i <= n / 2 + 1; i++) {
				arr[2 * i] = 1 + arr[i];
				arr[2 * i - 1] = arr[2 * i] + arr[i - 1];
			}

			System.out.println(arr[n]);
		}
	}
}
