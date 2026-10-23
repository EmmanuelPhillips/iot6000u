package ui;

import java.awt.Color;

import javax.swing.BorderFactory;
import javax.swing.JLabel;

public class Grid extends JLabel {
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	Index position;	
	
	public Grid(Index position) {
		super();
		
		this.position = position;
		this.setBorder(BorderFactory.createCompoundBorder(
				BorderFactory.createLineBorder(Color.GRAY), 
				BorderFactory.createLoweredBevelBorder()));
	}
}
