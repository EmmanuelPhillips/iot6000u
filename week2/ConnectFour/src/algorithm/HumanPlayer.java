package algorithm;


public class HumanPlayer extends Player {
	private int movedColumn = -1;
	
	public HumanPlayer() {
		super("images/red");
	}

	public void setMove(int column) {
		movedColumn = column;
	}

	public int getType() {
		return 0;
	}

	public int go(State state) {
		state.move(movedColumn);
		
		return movedColumn;
	}
}
