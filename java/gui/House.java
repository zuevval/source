import java.awt.*;
import java.awt.event.*;

import javax.swing.JFrame;
import javax.swing.JPanel;

public class House {
	static JFrame Fr;
	static JPanel p;
	static int houseX = 300;
	static int houseY = 240;
	static int delta = 1; //for roof
	static int sunX = 100;
	static int sunY = 100;
	static int x1; // for rays of sun
	static int y1;
	static int x2;
	static int y2;

	public static void main(String[] args) {
		Fr = new JFrame();
		Fr.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		Fr.setSize(500, 500);
		p = new JPanel() {

			@Override
			protected void paintComponent(Graphics g) {
				super.paintComponent(g);
				Graphics2D g2 = (Graphics2D) g;
				// Background
				g2.setColor(Color.GREEN);
				g2.fillRect(0, 250, 500, 250);
				g2.setColor(Color.blue);
				g2.fillRect(0, 0, 500, 250);
				// Sun
				g2.setColor(Color.YELLOW);
				g2.fillOval(sunX-20, sunY-20, 40, 40);
				for (int i = 0; i < 10; i++) {
					x1=(int)(30*Math.cos(i*Math.PI/5));
					y1=(int)(30*Math.sin(i*Math.PI/5));
					x2=2*x1;
					y2 = 2*y1;
					g2.drawLine(sunX+x1, sunY+y1, sunX + x2, sunY + y2);
				}
				// House
				g2.setColor(Color.RED);
				g2.fillRect(houseX, houseY, 80, 80);
				g2.setColor(Color.CYAN);
				for (int i = 0; i < 51; i++) {
					g2.drawLine(houseX - 10 + i, houseY, houseX + 40, houseY
							- 50 + i);
					g2.drawLine(houseX + 40, houseY - 50 + i, houseX + 90 - i,
							houseY);
				}
				g2.setColor(Color.YELLOW);
				g2.fillRect(houseX + 20, houseY + 20, 15, 15);
				g2.fillRect(houseX + 20, houseY + 45, 15, 15);
				g2.fillRect(houseX + 45, houseY + 20, 15, 15);
				g2.fillRect(houseX + 45, houseY + 45, 15, 15);

			}
		};
		Fr.getContentPane().add(p, BorderLayout.CENTER);
		Fr.setVisible(true);
	}
}
