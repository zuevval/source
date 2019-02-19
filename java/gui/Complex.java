import java.awt.*;
import java.awt.event.*;

import javax.swing.Box;
import javax.swing.JButton;
import javax.swing.JFrame;
import javax.swing.JPanel;
import javax.swing.JScrollBar;

public class Complex {
	static JFrame Fr;
	static JScrollBar scb;
	static Box box;
	static double a;
	static double b;
	static double x;
	static double y;
	static double xl = 1;
	static double yl = 1.5;
	static int res;
	static JPanel p;

	public static void main(String[] args) {
		a = 1;
		b = 1;
		x = a;
		y = b;
		res = 0;
		Fr = new JFrame();
		Fr.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		Fr.setSize(400, 400);
		scb = new JScrollBar(JScrollBar.HORIZONTAL);
		scb.setSize(100, 100);
		box = Box.createHorizontalBox();
		box.add(scb);
		Fr.add(box, BorderLayout.SOUTH);
		p = new JPanel() {

			@Override
			protected void paintComponent(Graphics g) {
				super.paintComponent(g);
				Graphics2D g2 = (Graphics2D) g;
				for (int i = 0; i < p.WIDTH; i++) {
					for (int j = 0; j < p.HEIGHT; j++) {
						int color = getColor(convertX(i), convertY(j), x * x
								+ y * y);
						g2.setColor(Color.getHSBColor(
								(float) (color % 256 / 256.0), (float) 1.0,
								(float) 1.0));
						g2.drawRect(i, j, 1, 1);
					}
				}
			}
		};
		Fr.getContentPane().add(p, BorderLayout.CENTER);
		Fr.setVisible(true);
	}

	static int getColor(double x, double y, double r) {
		while (res < 300 && r < 4) {
			double xPow2 = x * x;
			double yPow2 = y * y;
			double xy = x * y;
			x = xPow2 - yPow2 + a;
			y = 2 * xy + b;
			r = xPow2 + yPow2;
			res++;
		}

		return res;
	}

	static double convertX(int i) {
		return x = (i / p.getWidth()) * 2 * xl + a - xl;
	}

	static double convertY(int j) {
		return y = (j / p.getWidth()) * 2 * yl + b - yl;
	}
}
