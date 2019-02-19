import java.util.Scanner;

public class Satellite {

	static int x, y, z; // �������
	static int x0, y0, z0; // ��������� ��������
	static int a, b, c; // ������ ������� � �������� ��������
	static double ws; // ������� �������� ��������

	static int xn, yn, zn; // �����������
	static int r; // �������� ������-������� ����. �� ��������� Oxy
	static double fi0; // ��������� ���� �����������

	final static int R = 6400; // ������ �����
	final static double wEarth = 6.2832 / (3600 * 24); // ������� �������� �����
	static long t; // �����
	static int dt = 2; // ��� �������
	static int N = (int) 3600 * 72 / dt; // ����� ������� �������� ������
	static int[][] M = new int[N][5]; // ������ ��� �������� ������

	public static void main(String[] args) {
		Scanner sc = new Scanner(System.in);
		System.out.println("Enter ws");
		ws = sc.nextDouble();
		System.out.println("Enter xn < 6400");
		xn = sc.nextInt();
		if (xn > R) {
			System.out.println("Spectator is not on Earth surface!");
		}
		System.out.println("Enter yn < 6400");
		yn = sc.nextInt();
		if (yn > Math.sqrt(R * R - xn * xn)) {
			System.out.println("Spectator is not on Earth surface!");
		}
		r = (int) (Math.sqrt(xn * xn + yn * yn));
		zn = (int) Math.sqrt(R * R - r * r);
		if (yn != 0)
			fi0 = Math.atan(xn / yn);
		else if (xn > 0)
			fi0 = 3.1416 / 2;
		else
			fi0 = -3.1416 / 2;
		x0 = 0;
		System.out.println("Enter y0");
		y0 = sc.nextInt(); // ����� ���� �������� ������ �� z0=0
		System.out.println("Enter z0");
		z0 = sc.nextInt();
		sc.close();
		double k1, k2, k3, l;
		k1 = Math.pow(y0 / z0 - b, 2) + Math.pow(y0 / z0, 2);
		for (int i = 0; i < N; i++) {
			l = Math.cos(ws * t) * (y0 * y0 + z0 * z0);
			k2 = 2 * (b - y0 / z0) * (c + 1 / z0) * l / z0;
			k3 = Math.pow(c * l / z0, 2) - (y0 * y0 + z0 * z0);
			y = (int) ((Math.sqrt(k2 * k2 - 4 * k1 * k3) - k2) / (2 * k1));
			z = (int) ((l - y * y0) / z0);
			x = (int) (y * (y0 / z0 - b) - c * l / z0);
			xn = (int) (r * Math.sin(ws * t));
			yn = (int) (r * Math.cos(ws * t));
			t = t + dt;
			M[i][0] = x;
			M[i][1] = y;
			M[i][2] = z;
			M[i][3] = xn;
			M[i][4] = yn;

			//�������� �� �������������� ��������� �������� ����� � ��� �� ����� (�� ��������)
			boolean check = false;
			if (Math.abs((x * x + y * y + z * z) - (y0 * y0 + z0 * z0))<20)
				check = true;
			System.out.println(check);
		}
	}

}
