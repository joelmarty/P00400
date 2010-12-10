package org.brookes.fbsh;

import org.brookes.fbsh.ui.MainFrame;

import charvax.swing.JFrame;

public class Main {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
				
		try {
			MainFrame frame = new MainFrame();
			frame.setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);
			frame.setVisible(true);
		} catch (Exception e) {
			e.printStackTrace();
		}

	}

}
