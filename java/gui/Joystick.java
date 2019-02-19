import java.awt.*;
import java.awt.event.*;

import javax.swing.JButton;
import javax.swing.JFrame;

public class Joystick {
	static JFrame Jstic;

	public static void main(String[] args) {
		Jstic = new JFrame();
		Jstic.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		Jstic.setSize(200, 200);
		JButton Left = new JButton("<");
		Left.addMouseMotionListener(new MouseMotionListener() {
			@Override
			public void mouseMoved(MouseEvent e) {
				Jstic.setLocation(Jstic.getLocation().x - 10,
						Jstic.getLocation().y);
			}

			@Override
			public void mouseDragged(MouseEvent e) {

			}
		});
		JButton Right = new JButton(">");
		Right.addMouseMotionListener(new MouseMotionListener() {
			@Override
			public void mouseMoved(MouseEvent e) {
				Jstic.setLocation(Jstic.getLocation().x + 10,
						Jstic.getLocation().y);
			}

			@Override
			public void mouseDragged(MouseEvent e) {

			}
		});
		JButton Up = new JButton("Up");
		Up.addMouseMotionListener(new MouseMotionListener() {
			@Override
			public void mouseMoved(MouseEvent e) {
				Jstic.setLocation(Jstic.getLocation().x,
						Jstic.getLocation().y - 10);
			}

			@Override
			public void mouseDragged(MouseEvent e) {

			}
		});
		JButton Down = new JButton("Down");
		Down.addMouseMotionListener(new MouseMotionListener() {
			@Override
			public void mouseMoved(MouseEvent e) {
				Jstic.setLocation(Jstic.getLocation().x,
						Jstic.getLocation().y + 10);
			}

			@Override
			public void mouseDragged(MouseEvent e) {

			}
		});
		JButton Center = new JButton("Fire");
		Center.addActionListener(new ActionListener() {
			@Override
			public void actionPerformed(ActionEvent e) {
				Jstic.setLocation(550, 450);
			}
		});
		Center.setSize(5, 5);
		Center.setBackground(Color.yellow);
		Jstic.getContentPane().add(Left, BorderLayout.WEST);
		Jstic.getContentPane().add(Right, BorderLayout.EAST);
		Jstic.getContentPane().add(Down, BorderLayout.SOUTH);
		Jstic.getContentPane().add(Up, BorderLayout.NORTH);
		Jstic.getContentPane().add(Center, BorderLayout.CENTER);
		// Calcul.getContentPane().add(Left, BorderLayout.WEST);
		// Calcul.getContentPane().add(Three);
		Jstic.setVisible(true);
	}
}
