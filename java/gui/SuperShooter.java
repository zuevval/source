import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.MouseEvent;
import java.awt.event.MouseMotionListener;
import java.util.Random;

import javax.swing.JButton;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JOptionPane;
import javax.swing.Timer;

public class SuperShooter {
	static JFrame Fr;
	static JButton Left;
	static JButton Right;
	static JButton Center;
	static JButton Up;
	static JButton Down;
	static JButton Target;
	static int lives;
	static JLabel l;

	public static void main(String[] args) {
		Fr = new JFrame();
		Fr.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		Fr.setSize(500, 500);
		Fr.setLayout(null);
		Left = new JButton("<");
		Left.setSize(50, 50);
		Left.setLocation(0, 50);
		Right = new JButton(">");
		Right.setSize(50, 50);
		Right.setLocation(100, 50);
		Up = new JButton("Up");
		Up.setSize(50, 50);
		Up.setLocation(50, 0);
		Down = new JButton("Down");
		Down.setSize(50, 50);
		Down.setLocation(50, 100);
		Center = new JButton("Fire");
		Center.setSize(50, 50);
		Center.setLocation(50, 50);
		Left.addMouseMotionListener(new MouseMotionListener() {
			@Override
			public void mouseMoved(MouseEvent e) {
				move(-5, 0);
			}

			public void mouseDragged(MouseEvent e) {

			}
		});

		Right.addMouseMotionListener(new MouseMotionListener() {
			@Override
			public void mouseMoved(MouseEvent e) {
				moveOut(5, 0);
			}

			public void mouseDragged(MouseEvent e) {

			}
		});

		Up.addMouseMotionListener(new MouseMotionListener() {
			@Override
			public void mouseMoved(MouseEvent e) {
				move(0, -5);
			}

			public void mouseDragged(MouseEvent e) {

			}
		});

		Down.addMouseMotionListener(new MouseMotionListener() {
			@Override
			public void mouseMoved(MouseEvent e) {
				moveOut(0, 5);
			}

			public void mouseDragged(MouseEvent e) {

			}
		});
		Center.setBackground(Color.yellow);

		
		Fr.getContentPane().add(Left);
		Fr.getContentPane().add(Right);
		Fr.getContentPane().add(Down);
		Fr.getContentPane().add(Up);
		Fr.getContentPane().add(Center);
		Target = new JButton("МОНСТР");
		Target.setSize(60, 60);
		Target.setBackground(Color.PINK);
		Fr.getContentPane().add(Target);
		Timer t = new Timer(100, new ActionListener() {
			@Override
			public void actionPerformed(ActionEvent e) {
				int x = Target.getX();
				int y = Target.getY();
				x = Math.abs(x + 5*lives);
				y = Math.abs(y + 5*lives);
				Target.setLocation(x, y);
			}
		});
		t.start();
		lives = 1;
		l = new JLabel();
		l.setText("уровень " + lives);
		l.setLocation(250, 10);
		l.setSize(100, 15);
		Fr.getContentPane().add(l);
		Timer t2 = new Timer(100, new ActionListener() {
			@Override
			public void actionPerformed(ActionEvent e) {
				if (Target.getY() > 510) {
					Target.setLocation(0, 0);
					if (lives > 1) {
						
						lives = lives - 1;
						l.setText("уровень " + lives);
					} else {
						t.stop();
						JOptionPane.showMessageDialog(null, "you lose");
					}
					if (lives == 0) {
						lives = lives - 1;
						JOptionPane.showMessageDialog(null, "you lose");
					}
				}

			}
		});
		t2.start();
		Fr.setVisible(true);
		Center.addActionListener(new ActionListener() {
			@Override
			public void actionPerformed(ActionEvent e) {
				if (Math.abs(Center.getX() - Target.getX()) <= 25
						&& Math.abs(Center.getY() - Target.getY()) <= 25) {
					if (lives == 5) {
					JOptionPane.showMessageDialog(null, "you win");
					t.stop();
					}
					lives = lives + 1;
					moveOut(-20, -70);
					l.setText("уровень " + lives);
					Target.setLocation(0, 0);
				}
			}
		});
	}

	public static void move(int x1, int y1) {
		if (Up.getLocation().x > 50 && Up.getLocation().y > 0) {
			Up.setLocation(Up.getLocation().x + x1, Up.getLocation().y + y1);
			Down.setLocation(Down.getLocation().x + x1, Down.getLocation().y
					+ y1);
			Left.setLocation(Left.getLocation().x + x1, Left.getLocation().y
					+ y1);
			Right.setLocation(Right.getLocation().x + x1, Right.getLocation().y
					+ y1);
			Center.setLocation(Center.getLocation().x + x1,
					Center.getLocation().y + y1);
		}

	}

	public static void moveOut(int x1, int y1) {
		Up.setLocation(Up.getLocation().x + x1, Up.getLocation().y + y1);
		Down.setLocation(Down.getLocation().x + x1, Down.getLocation().y + y1);
		Left.setLocation(Left.getLocation().x + x1, Left.getLocation().y + y1);
		Right.setLocation(Right.getLocation().x + x1, Right.getLocation().y
				+ y1);
		Center.setLocation(Center.getLocation().x + x1, Center.getLocation().y
				+ y1);
	}
}