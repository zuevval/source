import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

import javax.swing.*;

public class BounceBall {
	static int bx = 50;
	static int by = 50;
	static int br = 100;
	static int vx = 3;
	static int vy = 4;
	static double ay = 0.06;
	static int flag = 2;

	public static void main(String[] args) {
		JFrame f = new JFrame("picture 1");
		f.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		f.setSize(600, 600);

		final JPanel p = new JPanel() {

			@Override
			protected void paintComponent(Graphics g) {
				super.paintComponent(g);
				Graphics2D g2 = (Graphics2D) g;
				g2.setColor(Color.black);
				g2.drawOval(bx + 1, by + 2, br, br);
				g2.fillOval(bx, by, br, br);
				g2.drawRect(40, 40, 500, 500);
			}

		};
		p.setSize(600, 600);
		f.getContentPane().add(p);
		Timer t = new Timer(10, new ActionListener() {
			@Override
			public void actionPerformed(ActionEvent e) {
				flag = flag + 1;
				if (bx >= 540 - br || bx <= 40)
					vx = -1 * vx;

				if (by <= 40) {
					vy = Math.abs(vy);
					flag = Math.abs(flag);
				}
				if (by >= 540 - br) {
					vy = -1 * Math.abs(vy);
					flag = Math.abs(flag)*(-1);
				}

				bx = bx + vx;
				by = (int) (by + vy + flag * ay);
				p.repaint();
			}
		});

		t.start();
		f.setVisible(true);
	}
}
