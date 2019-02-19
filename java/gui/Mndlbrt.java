//written by Anton Gorox
//reduced by Valery Zuev
import java.awt.BasicStroke;
import java.awt.BorderLayout;
import java.awt.Color;
import java.awt.Graphics;
import java.awt.Graphics2D;
import java.awt.Scrollbar;
import java.awt.Stroke;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.MouseEvent;
import java.awt.event.MouseListener;
import java.awt.event.MouseWheelEvent;
import java.awt.event.MouseWheelListener;

import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.Timer;

public class Mndlbrt {

	static int N, M, color, mx, my, direct;
	static double x0, y0, xl, yl, alp, bet;
	static JPanel p;
	static JFrame myW;
	static JLabel lbl;
	static Scrollbar br1, br2;

	public static double convertX(int i) {
		double conx = (i * (2 * xl) / p.getWidth()) + x0 - xl;
		return conx;
	}

	public static double convertY(int j) {
		double cony = (j * (2 * yl) / p.getHeight()) + y0 - yl;
		return cony;
	}

	public static int getcolor(double a, double b) {
		double x = a;
		double y = b;
		double r = a * a + b * b;
		int res = 0;
		double x2;
		double y2;
		double xy;
		while ((res < 300) && (r < 4)) {
			x2 = x * x;
			y2 = y * y;
			xy = x * y;
			x = x2 - y2 + a;
			y = 2 * xy + b;
			r = x * x + y * y;
			res++;
		}
		return res;
	}

	public static int getcolorJL(double a, double b) {
		double x = a;
		double y = b;
		double r = a * a + b * b;
		int res = 0;
		double x2;
		double y2;
		double xy;
		while ((res < 300) && (r < 4)) {
			x2 = x * x;
			y2 = y * y;
			xy = x * y;
			x = x2 - y2 + alp;
			y = 2 * xy + bet;
			r = x * x + y * y;
			res++;
		}
		return res;
	}

	public static void main(String[] args) {
		int N = 1500;
		int M = 1000;
		x0 = 0;
		y0 = 0;
		xl = 1.5;
		yl = 1.0;
		// alp = 0.50134;
		// bet = 0.2126;
		alp = 0;
		bet = 0;

		myW = new JFrame("Mndlbrt");
		myW.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		myW.setSize(N, M);

		br1 = new Scrollbar();
		br2 = new Scrollbar();

		myW.getContentPane().add(br1, BorderLayout.WEST);
		myW.getContentPane().add(br2, BorderLayout.EAST);

		p = new JPanel() {

			@Override
			protected void paintComponent(Graphics g) {
				super.paintComponent(g);
				Graphics2D g2 = (Graphics2D) g;

				int gap = 1;

				for (int i = 0; i < p.getWidth(); i = i + gap) {
					for (int j = 0; j < p.getHeight(); j = j + gap) {
						color = getcolorJL(convertX(i), convertY(j));
						g2.setColor(Color.getHSBColor(
								(float) (color % 256 / 256.0), (float) 1.0,
								(float) 1.0));

						// new Color(0, color % 256, 0));
						g2.drawRect(i, j, 1, 1);
					}
				}
			}
		};

		Timer t1 = new Timer(3000, new ActionListener() {

			@Override
			public void actionPerformed(ActionEvent e) {
				alp = br1.getValue() / 90.0;
				bet = br2.getValue() / 90.0;
				p.repaint();
			}
		});
		t1.start();

		myW.getContentPane().add(p);
		myW.setVisible(true);

	}

}