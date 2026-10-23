package algorithm;

import javax.swing.ImageIcon;

public abstract class Player {
	public ImageIcon bead;
	public ImageIcon beadIcon; 


	public Player(String beadIconPath) {
		bead = new ImageIcon(beadIconPath + "-sphere.resized.png");
		beadIcon = new ImageIcon(beadIconPath + "-sphere.png");
	}

	public abstract int go(State b);

	public abstract void setMove(int col);

	public abstract int getType();
}
