
public class Queue {
	public static void main(String[] args) {
		IQueue qu1 = new ArrayQueue();
        IQueue qu2 = new ArrayQueue();
        for (int i = 0; i < 10; i++) {
                qu1.push(i);
                qu2.push(i*i);
        }
        for (int i = 0; i < 10; i++) {
                System.out.println(qu1.pop());
        }
        for (int i = 0; i < 10; i++) {
                System.out.println(qu2.pop());
        }
}

}
