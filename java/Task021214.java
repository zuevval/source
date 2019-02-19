
public class Task021214 {
	public static void main(String[] args) {
        for (int n = 0; n < 27; n++) {System.out.print((n+1) + "\t" );
            for (int i = 0; i < 27; i++) {
                if (i < n) {
                    if (n < 15) {
                        System.out.print("*");
                    }
                } else {
                    if (n >= 15) {
                        System.out.print("*");
                    } else {
                        if (i - n + 1 <= 27) {
                            System.out.print("*");
                        } else {
                            System.out.print(".");
                        }
                    }
                }
            }
            System.out.println();
        }
    }
}