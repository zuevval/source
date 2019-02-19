import java.awt.*;
import java.awt.event.*;
import java.util.Random;

import javax.swing.*;

public class BullsAndCows {
	static JFrame F1;
	static String in;

	public static void main(String[] args) {
		Random r = new Random();
		int N = r.nextInt(8999) + 1000;
		F1 = new JFrame();
		F1.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		F1.setSize(200, 200);
		JTextField t1 = new JTextField();
		JButton enter = new JButton("ВВЕСТИ");
		JLabel l = new JLabel();
		l.setText("<html>" + "Число........Быки........Коровы" + "</html>");
		F1.getContentPane().add(l, BorderLayout.CENTER);
		enter.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				in = t1.getText();
				in = out(in, N);
				t1.setText(null);
				l.setText(l.getText() + "<br>" + in + "so try another number");
			}
		});
		Box box = Box.createHorizontalBox();
		box.add(t1);
		box.add(Box.createHorizontalGlue());
		box.add(enter);
		F1.getContentPane().add(box, BorderLayout.NORTH);

		F1.setVisible(true);
	}

	public static String out(String in, int N) {
		if (in.length() != 4) {
			JOptionPane
					.showMessageDialog(
							null,
							"Введите четырёхзначное число без пробелов и специальных символов",
							"Ошибка", JOptionPane.ERROR_MESSAGE);
			return null;
		}
		String num;
		int[] check = new int[10];
		int bulls = 0;
		int cows = 0;
		num = N + "";
		for (int i = 0; i < 4; i++) {
			if (in.charAt(i) == num.charAt(i)) {
				bulls = bulls + 1;
			}
			for (int j = 0; j < 4; j++) {
				if (in.charAt(i) == num.charAt(j)) {
					// к такому номеру массива добавить один
				}
			}
		}
		if (bulls == 4)
			JOptionPane.showMessageDialog(null,
					"Вы угадали задуманное компьютером число - " + in, "УРА",
					JOptionPane.PLAIN_MESSAGE);
		for (int i = 0; i < 10; i++) {
			if (check[i] != 0) {
				cows = cows + 1;
			}
			cows = cows - bulls;
		}
		in = N + "....." + bulls + "....." + cows;
		return in;
	}

	public static String outImproved(String in, int N) {
		if (in.length() != 4) {
			JOptionPane
					.showMessageDialog(
							null,
							"Введите четырёхзначное число без пробелов и специальных символов",
							"Ошибка", JOptionPane.ERROR_MESSAGE);
			return null;
		}
		String comp = "" + N;
		int bulls = 0;
		int cows = 0;
		for (int i = 0; i < 4; i++) {
			if (in.charAt(i) == comp.charAt(i)) {
				bulls = bulls + 1;
			}
		}
		return in;

	}

	public static String compress(String a) {
		int num = 0;
		for (int i = 0; i < a.length(); i++) {
			for (int j = i + 1; j < a.length(); j++) {
				if (a.charAt(i) == a.charAt(j)) {
					a.charAt(j) = a.charAt(a.length() - num);
					num = num + 1;
				}
			}
			a.length() = a.length()-num;
		}
		return a;

	}

}
