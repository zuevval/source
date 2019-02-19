import java.awt.*;

import javax.swing.JButton;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.JTextArea;
import javax.swing.JTextField;

public class Graph {
	static JFrame Fr;
	static JPanel p;
	static JTextArea horMinus;
	static JTextArea horPlus;
	static JTextArea vertMinus;
	static JTextArea vertPlus;
	static double x;
	static double y;
	static double x2;
	static double y2;

	public static void main(String[] args) {
		Fr = new JFrame();
		Fr.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		Fr.setSize(800, 800);
		Fr.setLayout(null);
		p = new JPanel() {

			@Override
			protected void paintComponent(Graphics g) {
				super.paintComponent(g);
				Graphics2D g2 = (Graphics2D) g;
				g2.setColor(Color.BLACK);
				// abscissa axis
				g2.drawLine(400, 50, 400, 750);
				g2.drawLine(401, 50, 401, 750);
				g2.drawLine(400, 50, 390, 70);
				g2.drawLine(401, 50, 391, 70);
				g2.drawLine(400, 50, 390, 70);
				g2.drawLine(401, 50, 391, 70);
				g2.drawLine(400, 50, 410, 70);
				g2.drawLine(399, 50, 409, 70);
				g2.drawLine(400, 50, 390, 70);
				g2.drawLine(401, 50, 391, 70);
				// axis of ordinates
				g2.drawLine(50, 400, 750, 400);
				g2.drawLine(50, 401, 750, 401);
				g2.drawLine(750, 400, 730, 390);
				g2.drawLine(750, 401, 730, 391);
				g2.drawLine(750, 400, 730, 410);
				g2.drawLine(750, 401, 730, 411);
				// scale
				for (int i = 51; i < 749; i++) {
					if (i % 10 == 0) {
						g2.drawLine(395, i, 405, i);
						g2.drawLine(i, 395, i, 405);
					}
					if (i % 100 == 0) {
						g2.drawLine(395, i + 1, 405, i + 1);
						g2.drawLine(i + 1, 395, i + 1, 405);
					}
				}
				// graph
				for (int i = -400; i < 801; i++) {
					double flag = i;
					x = flag / 10;
					y = x * x + 8 * x + Math.cos(x);
					flag = flag + 1;
					x2 = flag / 10;
					y2 = x2 * x2 + 8 * x2 + Math.cos(x2);
					g2.drawLine(i + 400, (int) (-10 * y) + 400, i + 401,
							(int) (-10 * y2) + 400);
				}
			}
		};
		Fr.getContentPane().add(p);
		p.setLocation(0, 0);
		p.setSize(800, 800);
		horMinus = new JTextArea();
		horPlus = new JTextArea();
		vertMinus = new JTextArea();
		vertPlus = new JTextArea();
		vertPlus.setLocation(402, 350);
		vertPlus.setSize(30, 40);
		Fr.getContentPane().add(vertPlus);
		horMinus.setText("-10");
		horPlus.setText("10");
		vertMinus.setText("-10");
		vertPlus.setText("10");
		horMinus.setLocation(350, 370);
		horMinus.setSize(30, 40);
		Fr.getContentPane().add(horMinus);
		
		Fr.setVisible(true);
	}

}
