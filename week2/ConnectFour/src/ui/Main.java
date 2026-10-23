package ui;

import java.awt.BorderLayout;
import java.awt.Color;
import java.awt.Font;
import java.awt.GridLayout;

import javax.swing.BorderFactory;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.SwingUtilities;
import javax.swing.UIManager;
import javax.swing.UnsupportedLookAndFeelException;
import javax.swing.UIManager.LookAndFeelInfo;

public class Main {
	public static void main(String[] args) {
		try {
			for (LookAndFeelInfo info : UIManager.getInstalledLookAndFeels()) {
				if ("Nimbus".equals(info.getName())) {
					UIManager.setLookAndFeel(info.getClassName());
					break;
				}
			}
		} catch (ClassNotFoundException e) {
			try {
				UIManager.setLookAndFeel(UIManager
						.getCrossPlatformLookAndFeelClassName());
			} catch (Exception ex) {

			}
		} catch (InstantiationException e) {

		} catch (IllegalAccessException e) {

		} catch (UnsupportedLookAndFeelException e) {
			try {
				UIManager.setLookAndFeel(UIManager
						.getCrossPlatformLookAndFeelClassName());
			} catch (Exception ex) {

			}
		}

		SwingUtilities.invokeLater(new Runnable() {

			@Override
			public void run() {

				JFrame boardFrame = new JFrame();
				boardFrame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
				boardFrame.setSize(650, 462);
				boardFrame.setLocationRelativeTo(null);

				Board board = new Board();
				board.setBackground(Color.DARK_GRAY);
				board.setBorder(BorderFactory.createLineBorder(Color.GRAY, 10));
				// board.setBackground(new Color(61, 0, 60));
				// board.setBorder(BorderFactory.createLineBorder(new Color(113,
				// 1, 113), 10));
				board.setSize(440, 462);
				boardFrame.add(board, BorderLayout.CENTER);

				JPanel scoreBoard = new JPanel();
				scoreBoard.setBorder(BorderFactory.createEmptyBorder(10, 10,
						10, 10));
				scoreBoard.setSize(200, 462);
				scoreBoard.setLayout(new GridLayout(3, 1, 10, 10));
				// scoreBoard.setBackground(new Color(193, 246, 164));
				scoreBoard.setBackground(new Color(240, 146, 100));

				PlayerInfoContainer human = new PlayerInfoContainer(
						board.human, "Human");
				human.setBorder(BorderFactory.createLineBorder(Color.GRAY));
				human.setBackground(new Color(222, 168, 222));
				// human.setBackground(Color.LIGHT_GRAY);
				PlayerInfoContainer computer = new PlayerInfoContainer(
						board.computer, "Computer");
				computer.setBorder(BorderFactory.createLineBorder(Color.GRAY));
				computer.setBackground(new Color(222, 168, 222));
				// computer.setBackground(Color.LIGHT_GRAY);

				scoreBoard.add(human);
				scoreBoard.add(computer);

				JPanel ruleSet = new JPanel(new GridLayout(1, 1));
				// ruleSet.setBackground(new Color(193, 246, 164));
				ruleSet.setBackground(new Color(240, 146, 100));

				JLabel rule = new JLabel(
						"<html><body>Click on any row of<br> a column to drop the<br> bead on that column.</body></html>");
				rule.setBorder(BorderFactory.createEmptyBorder(0, 10, 0, 10));
				rule.setFont(new Font("", Font.ITALIC, 12));
				ruleSet.add(rule);

				scoreBoard.add(ruleSet);

				boardFrame.add(scoreBoard, BorderLayout.EAST);

				boardFrame.setVisible(true);
			}
		});
	}
}
