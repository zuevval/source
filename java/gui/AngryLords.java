import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.MouseEvent;
import java.awt.event.MouseListener;

import javax.swing.*;

public class AngryLords {
	static int bx = 50;
	static int by = 440;
	static int br = 50;
	static int vx = 3;
	static int vy = 4;
	static int px = 400; // расст. по иску до зелЄного пр€моуг
	static int py = 100; // расст. по игреку до зелЄного пр€моуг
	static int mx; // икс мыши
	static int my; // игрек мыши
	static int R; // рассто€ние между м€чом и мышью
	static double ay = 0.06;
	static int flag = 2; // это к ускорению своб.падени€
	static JScrollBar scb;
	static int force = 4;
	static Box box;
	static Timer t;
	static JLabel l;
	static int points = 1000;

	public static void main(String[] args) {
		JFrame f = new JFrame("picture 1");
		f.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		f.setSize(600, 900);
		f.setLayout(null);
		l = new JLabel();
		l.setText("очки " + points);
		l.setLocation(250, 650);
		l.setSize(100, 15);
		f.getContentPane().add(l);

		final JPanel p = new JPanel() {

			@Override
			protected void paintComponent(Graphics g) {
				super.paintComponent(g);
				Graphics2D g2 = (Graphics2D) g;
				g2.setColor(Color.green);
				g2.fillRect(px, py, 60, 60);
				g2.setColor(Color.black);
				g2.drawOval(bx + 1, by + 2, br, br);
				g2.fillOval(bx, by, br, br);
				g2.drawRect(40, 40, 500, 500);
			}

		};
		p.setSize(600, 600);
		f.getContentPane().add(p);
		t = new Timer(10, new ActionListener() {
			@Override
			public void actionPerformed(ActionEvent e) {
				points = points - 2;
				if (flag < 2000) {
					flag = flag + 1;
				}
				if ((Math.abs(bx - px) <= 20) && (Math.abs(by - py) <= 20)) {
					if (Math.abs(600 - bx) < 510 && Math.abs(600 - by) < 510) {
						px = Math.abs(600 - bx);
						py = Math.abs(600 - by);
					} else {
						px = 320;
						py = 320;
					}
					points = points + 1000;
				}
				if (bx <= 40) {
					vx = Math.abs(vx);
				}

				if (bx >= 540 - br)
					vx = -1 * Math.abs(vx);

				if (by <= 40) {
					vy = Math.abs(vy);
					flag = Math.abs(flag);
				}
				if (by >= 540 - br) {
					vy = -1 * Math.abs(vy);
					flag = Math.abs(flag) * (-1);
				}

				bx = bx + vx;
				by = (int) (by + vy + flag * ay);
				l.setText("очки " + points);
				if (points >= 10000) {
					JOptionPane.showMessageDialog(null, "you win");
					end();
				}
				if (points <= 0) {
					JOptionPane.showMessageDialog(null, "you lose");
					f.setVisible(false);
					end();
				}
				p.repaint();
			}
		});

		scb = new JScrollBar(JScrollBar.HORIZONTAL);
		scb.setSize(100, 100);
		box = Box.createHorizontalBox();
		box.add(scb);
		box.setLocation(100, 700);
		box.setSize(300, 100);
		f.add(box);
		f.addMouseListener(new MouseListener() {

			@Override
			public void mouseClicked(MouseEvent arg0) {
				mx = p.getMousePosition().x;
				my = p.getMousePosition().y;
				force = scb.getValue();
				R = (int) Math.sqrt(Math.pow((by - my), 2) + Math.pow((bx - mx), 2));
				vx = (int) (0.1 * force * (mx - bx) / R);
				vy = (int) (0.1 * force * (my - by) / R);
				t.start();
			}

			@Override
			public void mouseEntered(MouseEvent e) {
			}

			@Override
			public void mouseExited(MouseEvent e) {
			}

			@Override
			public void mousePressed(MouseEvent e) {
			}

			@Override
			public void mouseReleased(MouseEvent e) {
			}
		});
		f.setVisible(true);
	}

	public static void end() {
		t.stop();
	}
}
