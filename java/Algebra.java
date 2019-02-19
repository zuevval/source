
public class Algebra {
	public static void main(String[] args) {
		double beg = -3;
		/*for (int i = 0; i < 100; i++) {
			beg = 1 + 6/beg;
			System.out.println(beg);
		}*/
		beg = -0.53846;
		for (int i = 0; i < 100; i++) {
			beg = (1/2)/beg+ 1/2;
			System.out.println(beg);
		}

	}
}
