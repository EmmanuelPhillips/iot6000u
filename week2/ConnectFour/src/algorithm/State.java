package algorithm;

import java.util.Vector;

public class State {
	public int[][] locations;
	public int nextPlayer;
	public int[] cols;
	public int moveX = 0;
	public int moveY = 0;
	public int winner = 0;
	public String movelist;
	public int value = -1;
	public int depth = 0;
	public int action = 0;
	public boolean out = false;
	public Vector<State> successors = new Vector<State>();

	public State(boolean out) {
		nextPlayer = 1;
		locations = new int[6][7];
		cols = new int[7];
		winner = 0;

		action = -1;
		value = 0;
		depth = 0;

		clear();
		movelist = "";
		this.out = out;
		successors = new Vector<State>();
	}

	public void parseMove(String moveList) {
		for (int i = 0; i < moveList.length(); i++) {
			int tm = Integer.parseInt((new Character(moveList.charAt(i)))
					.toString());
			move(tm);
		}
	}

	public void move(int pos) {
		if ((cols[pos] == 6) && out) {
			System.out.println("Column full");
		} else {
			moveY = pos;
			movelist += pos;
			moveX = 5 - cols[pos];
			cols[pos]++;
			locations[moveX][moveY] = nextPlayer;
			nextPlayer = 3 - nextPlayer;
		}
	}

	public void clear() {
		for (int i = 0; i < 6; i++)
			for (int j = 0; j < 7; j++) {
				locations[i][j] = 0;
			}
		for (int j = 0; j < 7; j++)
			cols[j] = 0;
	}

	public boolean gameOver() {
		String line_x = "";
		String line_y = "";
		String line_ld = (new Integer(locations[moveX][moveY])).toString();
		String line_rd = (new Integer(locations[moveX][moveY])).toString();
		String s = (new Integer(3 - nextPlayer)).toString();
		String sub = s + s + s + s;
		String match = "[012]*" + sub + "[012]*";
		for (int i = 0; i < 7; i++) {
			int cell = locations[moveX][i];
			line_x += (new Integer(cell)).toString();
		}
		for (int i = 0; i < 6; i++) {
			int cell = locations[i][moveY];
			line_y += (new Integer(cell)).toString();
		}

		int tempx = moveX;
		int tempy = moveY;
		while ((tempx > 0) && (tempy > 0)) {
			tempx--;
			tempy--;
			line_ld = (new Integer(locations[tempx][tempy])).toString()
					+ line_ld;
		}

		tempx = moveX;
		tempy = moveY;
		while ((tempx < 5) && (tempy < 6)) {
			tempx++;
			tempy++;
			line_ld = line_ld
					+ (new Integer(locations[tempx][tempy])).toString();
		}

		tempx = moveX;
		tempy = moveY;
		while ((tempx > 0) && (tempy < 6)) {
			tempx--;
			tempy++;
			line_rd = (new Integer(locations[tempx][tempy])).toString()
					+ line_rd;
		}

		tempx = moveX;
		tempy = moveY;
		while ((tempx < 5) && (tempy > 0)) {
			tempx++;
			tempy--;
			line_rd = line_rd
					+ (new Integer(locations[tempx][tempy])).toString();
		}

		/*
		 * System.out.println(line_x); System.out.println(line_y);
		 * System.out.println(line_ld); System.out.println(line_rd);
		 * System.out.println(sub);
		 */

		if ((line_x.matches(match)) || (line_y.matches(match))
				|| (line_ld.matches(match)) || (line_rd.matches(match))) {
			winner = 3 - nextPlayer;
			/*
			 * if (out){ System.out.print("\nPlayer "); System.out.print(new
			 * Integer(winner)); System.out.println(" won!");}
			 */

			return true;
		}


		return false;
	}
	
	public boolean matchDrawn(){
		
		int z = 0;
		for (int i = 0; i < 6; i++)
			for (int j = 0; j < 7; j++)
				if (locations[i][j] == 0){
					z = 1;
					break;}

		if (z == 0) {
			
			 if (out) return true;
		}
		return false;
	}

	public String toString() {
		String ret = "   0 1 2 3 4 5 6\n";
		for (int i = 0; i < 6; i++) {
			ret += (new Integer(i)).toString() + ": ";
			for (int j = 0; j < 7; j++) {
				ret += (new Integer(locations[i][j])).toString();
				ret += " ";
			}
			ret += "\n";
		}
		return ret;
	}
}
