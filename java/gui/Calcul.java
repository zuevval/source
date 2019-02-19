import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

import javax.swing.*;

public class Calcul {
	static String input;
	static String output;

	public static void main(String[] args) {
		input = new String();
		JFrame Calcul = new JFrame();
		Calcul.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		Calcul.setSize(300, 250);
		JPanel panel = new JPanel();
		JPanel buttons = new JPanel();
		buttons.setLayout(new GridLayout(3, 3, 3, 3));
		JTextField t1 = new JTextField();
		t1.setText(input);
		panel.add(t1);

		Calcul.getContentPane().add(t1, BorderLayout.NORTH);
		JButton b1 = new JButton("1");
		b1.addActionListener(new ActionListener() {
			@Override
			public void actionPerformed(ActionEvent e) {
				input = input + "1";
				t1.setText(input);
			}

		});
		buttons.add(b1);
		JButton b2 = new JButton("2");
		b2.addActionListener(new ActionListener() {
			@Override
			public void actionPerformed(ActionEvent e) {
				input = input + "2";
				t1.setText(input);
			}

		});
		buttons.add(b2);
		JButton b3 = new JButton("3");
		b3.addActionListener(new ActionListener() {
			@Override
			public void actionPerformed(ActionEvent e) {
				input = input + "3";
				t1.setText(input);
			}

		});
		buttons.add(b3);
		JButton b4 = new JButton("4");
		b4.addActionListener(new ActionListener() {
			@Override
			public void actionPerformed(ActionEvent e) {
				input = input + "4";
				t1.setText(input);
			}

		});
		buttons.add(b4);
		JButton b5 = new JButton("5");
		b5.addActionListener(new ActionListener() {
			@Override
			public void actionPerformed(ActionEvent e) {
				input = input + "5";
				t1.setText(input);
			}

		});
		buttons.add(b5);
		JButton b6 = new JButton("6");
		b6.addActionListener(new ActionListener() {
			@Override
			public void actionPerformed(ActionEvent e) {
				input = input + "6";
				t1.setText(input);
			}

		});
		buttons.add(b6);
		JButton b7 = new JButton("7");
		b7.addActionListener(new ActionListener() {
			@Override
			public void actionPerformed(ActionEvent e) {
				input = input + "7";
				t1.setText(input);
				System.out.println(7);
			}

		});
		buttons.add(b7);
		JButton b8 = new JButton("8");
		b8.addActionListener(new ActionListener() {
			@Override
			public void actionPerformed(ActionEvent e) {
				input = input + "8";
				t1.setText(input);
			}

		});
		buttons.add(b8);
		JButton b9 = new JButton("9");
		b9.addActionListener(new ActionListener() {
			@Override
			public void actionPerformed(ActionEvent e) {
				input = input + "9";
				t1.setText(input);
			}

		});
		buttons.add(b9);

		JButton mult = new JButton("*");
		mult.addActionListener(new ActionListener() {
			@Override
			public void actionPerformed(ActionEvent e) {
				input = input + "*";
				t1.setText(input);
			}

		});
		buttons.add(mult);
		JButton div = new JButton("/");
		div.addActionListener(new ActionListener() {
			@Override
			public void actionPerformed(ActionEvent e) {
				input = input + "/";
				t1.setText(input);
			}

		});
		buttons.add(div);
		JButton plus = new JButton("+");
		plus.addActionListener(new ActionListener() {
			@Override
			public void actionPerformed(ActionEvent e) {
				input = input + "+";
				t1.setText(input);
			}

		});
		buttons.add(plus);
		JButton minus = new JButton("-");
		minus.addActionListener(new ActionListener() {
			@Override
			public void actionPerformed(ActionEvent e) {
				input = input + "-";
				t1.setText(input);
			}

		});
		buttons.add(minus);
		JButton dot = new JButton(".");
		dot.addActionListener(new ActionListener() {
			@Override
			public void actionPerformed(ActionEvent e) {
				input = input + ",";
				t1.setText(input);
			}

		});
		buttons.add(dot);
		JButton equal = new JButton("=");
		equal.setBackground(Color.LIGHT_GRAY);
		buttons.add(equal);

		Calcul.getContentPane().add(buttons, BorderLayout.CENTER);
		Calcul.setVisible(true);
	}

}
