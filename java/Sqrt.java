
public class Sqrt {
	

	public static void main(String[] args) {
		int a=-1, b=-4, c=-4;
		if (a==0) {
			System.out.println("������, ��������� �� ����������");
		} else 
			if (a < 0) { 
				if ((b*b-4*a*c) < 0) {
					System.out.println("������, ������������� ������������");
				} else {
					double d = Math.sqrt(b*b-4*a*c);
					System.out.println("x1=" + (d+b)/(-2*a));
					if (d != 0) {
						System.out.println("x2=" + (-(d-b)/(-2*a)));
					} else {
						System.out.println("������ ����");
					}
			}
			}else{
			if ((b*b-4*a*c) < 0) {
			System.out.println("������, ������������� ������������");
		} else {
			double d = Math.sqrt(b*b-4*a*c);
			System.out.println("x1=" + (d-b)/(2*a));
			if (d != 0) {
				System.out.println("x2=" + (-(d+b)/(2*a)));
			} else {
				System.out.println("������ ����");
			}
		}			
	}
}
}