import java.util.Scanner;

public class ex3571 {

	public static double f(double a, double b, double c, double d, double end) {
		//System.out.println(end * end * end + b * end * end + c * end + d);
		return a * end * end * end + b * end * end + c * end + d;
	}

	public static void main(String[] args) {
		final double dif = 10e-7;
		double beg = -1000;
		double end = 1000;
		Scanner sc = new Scanner (System.in);
		double A = sc.nextDouble();
		double B = sc.nextDouble();
		double C = sc.nextDouble();
		double D = sc.nextDouble();
		double x = (end + beg)/2;
		while (( f(A,B,C,D,end) - f(A,B,C,D,beg)) > dif) {
			if (f(A,B,C,D,end) == 0) {
				x = end;
				break;
			}
			if (Math.abs(f(A,B,C,D,x)) < dif) {
				break;
			}
			if (f(A,B,C,D,beg) == 0) {
				x = beg;
				break;
			}
			if (f(A,B,C,D,end) < 0) {
				end = (end + beg)/2;
				x = (end + beg)/2;
			}
			if (f(A,B,C,D,beg) > 0) {
				beg = (end + beg)/2;
				x = (end + beg)/2;
			}
		}
		System.out.println(x);
	}

}
