package ui;


import java.awt.GridLayout;
import java.awt.event.MouseEvent;
import java.awt.event.MouseListener;

import javax.swing.JOptionPane;
import javax.swing.JPanel;

import algorithm.HumanPlayer;
import algorithm.MinMaxPlayer;
import algorithm.Player;
import algorithm.State;

public class Board extends JPanel implements MouseListener {
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	Grid[][] grids;
	MoveController moveController;
	Player human;
	Player computer;

	State state;

	public Board() {
		setLayout(new GridLayout(6, 7, 5, 5));
		loadGrids();

		moveController = new MoveController(this);
		human = new HumanPlayer();
		computer = new MinMaxPlayer();
	}

	private void loadGrids() {
		removeAll();
		state = new State(true);
		grids = new Grid[6][7];

		for (int i = 0; i < 6; i++) {
			for (int j = 0; j < 7; j++) {
				grids[i][j] = new Grid(new Index(i, j));
				grids[i][j].addMouseListener(this);

				add(grids[i][j]);
			}
		}

	}

	@Override
	public void mouseClicked(MouseEvent e) {
		Grid clickedGrid = (Grid) e.getSource();

		if (moveController.move(clickedGrid.position.column, human)) {
			state.move(clickedGrid.position.column);

			if (state.gameOver()) {
				int playAgain = JOptionPane.showConfirmDialog(this,
						"Human wins!\nDo you want to play again", "Restart",
						JOptionPane.YES_NO_OPTION);
				if (playAgain == JOptionPane.YES_OPTION) {
					loadGrids();
				} else {
					System.exit(0);
				}
			}
			
			int computersMove = computer.go(state);

			moveController.move(computersMove, computer);
			if (state.gameOver()) {
				int playAgain = JOptionPane.showConfirmDialog(this,
						"AI wins!\nDo you want to play again", "Restart",
						JOptionPane.YES_NO_OPTION);
				if (playAgain == JOptionPane.YES_OPTION) {
					loadGrids();
				} else {
					System.exit(0);
				}
			}
							
				 if (state.matchDrawn()){
					 
					 int playAgain = JOptionPane.showConfirmDialog(this,
								"Match Drawn!\nDo you want to play again", "Restart",
								JOptionPane.YES_NO_OPTION);
						if (playAgain == JOptionPane.YES_OPTION) {
							loadGrids();
						} else {
							System.exit(0);
						}
				 }
			
			
			
			updateUI();
		}
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
}
