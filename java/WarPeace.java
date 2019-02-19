import java.io.File;
import java.io.FileNotFoundException;
import java.util.Scanner;

import javax.swing.Spring;

public class WarPeace<Java> {
	public static final String W = "C://Users//Valera//workspace//Java Project//src//input.txt";
	static final int M = 1000000000;

	public static void main(String[] args) {
		Scanner sc = new Scanner(System.in);
		try {
			new Scanner(new File("W"));
		} catch (FileNotFoundException e) {
			e.printStackTrace();
			System.out.println("Файл не найден");
		}
		String S = null, m = null;

		if (W != null) {
			S = W;
			m = sc.next();
		}
		int mHash = hash(m, 0, m.length());
		int SHash = hash(S, 0, m.length());
		int num = 0;
		for (int i = 0; i <= S.length() - m.length(); i++) {
			if (mHash == SHash)
				num = num + 1;
			if (i > 0)
			SHash = (int) (SHash - S.charAt(i - 1) * Math.pow(997, m.length()) + S
					.charAt(i)) % M;
			else
				SHash = (int) (SHash + S.charAt(i)) % M;
		}
		System.out.println(num);

	}

	public static int hash(String s, int f, int l) {
		int res = 0;
		for (int i = f; i < l; i++) {
			res = (int) (res + s.charAt(i) * Math.pow(997, l - i - 1)) % M;
		}
		return res;
	}
}
