import java.util.Scanner;
public class ex2963 {
	public static int oper(int a){
		if (a % 3 == 0) {
			a = a / 3;
			return a;
		}
		if (a%2 == 0) {
			a = a /2;
			return a;
		}
		return a-1;
	}
	
	public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        int n = sc.nextInt();
        int flag = 0;
        while (n != 1) {
        	n = oper(n);
        	System.out.println(n);
        	flag = flag+1;
        }
        System.out.println(flag);
    }
}