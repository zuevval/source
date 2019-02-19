import java.awt.*;

import javax.swing.JFrame;
import javax.swing.JPanel;

public class helix {
	static JFrame Fr;
	static JPanel p;
	static int lx = 600;
	static int ly = 750;
	final static int d = 10;
	final static int x0 = 100;
	final static int y0 = 100;
	static int x1 = 40;
	static int y1 = 40;
	static int x2 = 560;
	static int y2 = 760;
	static int flag = -1;

	public static void main(String[] args) {
		Fr = new JFrame();
		Fr.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		Fr.setSize(600, 800);
		p = new JPanel() {

			@Override
			protected void paintComponent(Graphics g) {
				super.paintComponent(g);
				Graphics2D g2 = (Graphics2D) g;
				g2.setColor(Color.BLACK);
				while (Math.abs(x1 - x2) > 10) {
					flag++;
					x1 = x1 + d;
					y1 = y1 + d;
					x2 = x2 - d;
					y2 = y2 - d;
					g2.drawLine(x1, y1, x2, y1);
					g2.drawLine(x2, y1, x2, y2);
					g2.drawLine(x2, y2, x1 - d, y2);
					g2.drawLine(x1 - d, y2, x1 - d, y1 - d);
				}

			}
		};
		Fr.getContentPane().add(p, BorderLayout.CENTER);
		Fr.setVisible(true);
	}

}