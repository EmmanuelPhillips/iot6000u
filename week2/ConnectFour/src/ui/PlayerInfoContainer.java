package ui;


import java.awt.Font;
import java.awt.GridBagConstraints;
import java.awt.GridBagLayout;

import javax.swing.JLabel;
import javax.swing.JPanel;

import algorithm.Player;

public class PlayerInfoContainer extends JPanel{
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	JLabel icon;
	JLabel playerType;
	
	public PlayerInfoContainer(Player player, String playerType) {		
		setLayout(new GridBagLayout());
		GridBagConstraints c = new GridBagConstraints();
		c.fill = GridBagConstraints.HORIZONTAL;
		c.ipadx = 5;
		c.ipady = 5;
		
		this.playerType = new JLabel(playerType);
		this.playerType.setFont(new Font("", Font.BOLD, 14));
		this.playerType.setHorizontalTextPosition(JLabel.CENTER);
		c.gridx = 0;
		c.gridy = 0;
		
		add(this.playerType,c);
		
		icon = new JLabel(player.beadIcon);
		c.gridx = 0;
		c.gridy = 1;
		c.gridwidth = 1;
		c.gridheight = 2;
		
		add(icon, c);
	}
}
