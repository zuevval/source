public class test{
	public static void main(String [] args){
		byte b1 = 3;
		byte b2 = 1;
		//byte b = b1 + b2; //error
		byte b = (byte)(b1 + b2);
		System.out.println("Hello World");
	}
}