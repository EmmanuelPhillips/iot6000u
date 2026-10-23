package ui;

import algorithm.Player;

public class MoveController {
	Board board;

	public MoveController(Board board) {
		this.board = board;
	}

	public boolean move(int clickedColumn, Player whoClicked) {
		if (isFull(clickedColumn)) {
			return false;
		}

		for (int i = 5; i >= 0; i--) {
			if (board.grids[i][clickedColumn].getIcon() == null) {
				board.grids[i][clickedColumn].setIcon(whoClicked.bead);
				board.grids[i][clickedColumn].setText("");
				return true;
			}
		}

		return true;
	}

	private boolean isFull(int clickedColumn) {
		return board.grids[0][clickedColumn].getIcon() != null;
	}
}
