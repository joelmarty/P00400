package org.brookes.fbsh.ui;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.brookes.fbsh.service.FacebookService;

import charva.awt.BorderLayout;
import charva.awt.Color;
import charva.awt.Container;
import charva.awt.Dimension;
import charva.awt.Toolkit;
import charva.awt.event.ActionEvent;
import charva.awt.event.ActionListener;
import charvax.swing.BorderFactory;
import charvax.swing.BoxLayout;
import charvax.swing.JButton;
import charvax.swing.JDialog;
import charvax.swing.JFrame;
import charvax.swing.JMenu;
import charvax.swing.JMenuBar;
import charvax.swing.JMenuItem;
import charvax.swing.JOptionPane;
import charvax.swing.JPanel;
import charvax.swing.JScrollPane;
import charvax.swing.JTable;
import charvax.swing.JTextArea;
import charvax.swing.ListSelectionModel;
import charvax.swing.event.ListSelectionEvent;
import charvax.swing.event.ListSelectionListener;

import com.restfb.FacebookException;
import com.restfb.FacebookJsonMappingException;
import com.restfb.types.Post;

public class MainFrame extends JFrame {
	
	private Container mainPanel;
	
	// menu items
	private JMenuBar menuBar;
	private JMenu shareMenu;
	private JMenu toolMenu;
	private JMenuItem postItem;
	private JMenuItem updateItem;
	private JMenuItem exitItem;
	
	// feed panel
	private JPanel feedPanel;
	private JTable feedTable;
	private PostTableModel feedModel;	
	private JScrollPane messageScroller;
	
	// message panel
	private JPanel messagePanel;
	private JScrollPane msgScroller;
	private JButton likeButton;
	private JTextArea postText;
	
	// publish panel & dialog
	JOptionPane messagePublisher;

	private static final Log LOG = LogFactory.getLog(MainFrame.class);
	
	private Dimension size = null;
	
	public MainFrame() {
		
		mainPanel = getContentPane();
		mainPanel.setForeground(Color.blue);
		mainPanel.setLayout(new BoxLayout(null, BoxLayout.X_AXIS));
		
		size = Toolkit.getDefaultToolkit().getScreenSize();
		LOG.debug("terminal size is: " + size.height + " h x " + size.width + "w");
		
	// creating menu
		menuBar = new JMenuBar();
		shareMenu = new JMenu("Share");
		shareMenu.setMnemonic('S');
		toolMenu = new JMenu("Tools");
		toolMenu.setMnemonic('T');
		
		// share menu
		postItem = new JMenuItem("Post");
		postItem.setMnemonic('P');
		postItem.addActionListener(new ActionListener() {	
			@Override
			public void actionPerformed(ActionEvent ae_) {
				// invoke share window
				PublishPost();
			}
		});
		updateItem = new JMenuItem("Update");
		updateItem.setMnemonic('U');
		updateItem.addActionListener(new ActionListener() {
			
			@Override
			public void actionPerformed(ActionEvent ae_) {
				UpdateThread thread = new UpdateThread();
				if(!thread.update)
					thread.update = true;
				thread.run();
			}
		});
		
		// tool menu
		exitItem = new JMenuItem("Exit");
		exitItem.setMnemonic('x');
		exitItem.addActionListener(new ActionListener() {	
			@Override
			public void actionPerformed(ActionEvent ae_) {
				// quit application
				terminate(0);
			}
		});
		
		shareMenu.add(postItem);
		shareMenu.add(updateItem);
		toolMenu.add(exitItem);
		menuBar.add(shareMenu);
		menuBar.add(toolMenu);
		menuBar.setForeground(Color.blue);
		
	// creating left-panel table
		feedPanel = new JPanel();
		feedPanel.setBorder(BorderFactory.createTitledBorder("Feed"));
		feedPanel.setLayout(new BorderLayout());
		
		LOG.info("content panel size is " + feedPanel.getHeight() + "h x " + feedPanel.getWidth() + "w");
		
		feedTable = new JTable();
		
		feedTable.setColumnSelectionAllowed(false);
		feedTable.setRowSelectionAllowed(true);
		feedTable.setSelectionMode(ListSelectionModel.SINGLE_SELECTION);
		feedTable.setPreferredScrollableViewportSize(new Dimension(size.width/2 - 2, size.height-7));
		feedTable.getSelectionModel().addListSelectionListener(new ListSelectionListener() {
			
			@Override
			public void valueChanged(ListSelectionEvent evt) {
				try {
					updatePost(feedModel.getModelAt(evt.getFirstIndex()));
				} catch (Exception e) {
					LOG.error("Error:" + e.getMessage());
				}
				
			}
		});
		
		msgScroller = new JScrollPane(feedTable);
		msgScroller.setViewportBorder(BorderFactory.createLineBorder(Color.blue));
		feedPanel.add(msgScroller, BorderLayout.CENTER);
	
	// creating right-panel
		messagePanel = new JPanel();
		
		messagePanel.setLayout(new BoxLayout(null, BoxLayout.Y_AXIS));
		messagePanel.setVisible(false);
		
		// message text control
		postText = new JTextArea();
		postText.setEditable(false);
		postText.setLineWrap(true);
		postText.setWrapStyleWord(true);
		messageScroller = new JScrollPane(postText);
		
		// like button
		likeButton = new JButton("Like!");
		likeButton.addActionListener(new ActionListener() {
			@Override
			public void actionPerformed(ActionEvent event) {
				LikeThread lThread = new LikeThread();
				lThread.post = feedModel.getModelAt(feedTable.getSelectionModel().getMaxSelectionIndex());
				
				lThread.start();
			}
		});
		
		messagePanel.add(messageScroller);
		messagePanel.add(likeButton);
		
	// create publish dialog with JOptionPane
		messagePublisher = new JOptionPane("");
		messagePublisher.setWantsInput(true);
		messagePublisher.setInitialSelectionValue("");
		String[] options = {"Publish","Cancel"};
		messagePublisher.setOptions(options);
		messagePublisher.setInitialValue("Publish");
		
	// set main panel structure
		// registering menubar
		setJMenuBar(menuBar);
		
		// adding content panel
		mainPanel.add(feedPanel);
		mainPanel.add(messagePanel);
		
		// configure
		setLocation(0, 0);
		setSize(size);
		validate();
		
		try {
			UpdateThread thread = new UpdateThread();
			thread.start();
		} catch (Exception e) {
			LOG.error(null, e);
		}
	}

	private void updatePost(Post p) {
		
		LOG.debug("Post is: " + p);
		
		messagePanel.setBorder(BorderFactory.createTitledBorder(p.getFrom().getName()));
		
		String message = p.getMessage();
		
		if(message == null)
			postText.setDocument("");
		else
			postText.setDocument(message);
		
		postText.setColumns( (int) (((double) size.width)/100L * 45L));
		postText.setRows( (int) (((double) size.height)/100L * 30L));

		msgScroller.minimumSize();
		messagePanel.minimumSize();
		messagePanel.setVisible(true);
		validate();
	}
	
	public void terminate(int status) {
		System.exit(status);
	}
	
	private void PublishPost() {
		messagePublisher.setInputValue("");
		JDialog publishDialog = messagePublisher.createDialog(this, "Publish a message");
		
		publishDialog.show();
		
        Object selectedValue = messagePublisher.getValue();
		
		if(messagePublisher.getOptions() != null) {
			String selectedOption = (String) selectedValue;
			LOG.debug("selected publish option is: " + selectedOption);
			if(selectedOption.equals("Publish")) {
				PublishThread pThread = new PublishThread();
		        pThread.message = (String) messagePublisher.getInputValue();
		        pThread.start();
			}	
		}        
        
        publishDialog.hide();
	}

private class PublishThread extends Thread {
		
		public String message = null;

		@Override
		public void run() {
			try {
				FacebookService.publishPost(message);
			} catch (FacebookJsonMappingException e) {
				LOG.error("Error publishing message: ", e);
			} catch (FacebookException e) {
				LOG.error("Error publishing message", e);
			}
			
			validate();
		}
	}

	
	private class LikeThread extends Thread {
		
		//TODO only fetch post from last update
		public Post post = null;

		@Override
		public void run() {
			try {
				int selectedPost = feedTable.getSelectionModel().getMaxSelectionIndex();
				LOG.debug("selected post to like:" + selectedPost);

				String response = FacebookService.likePost(post);
				
				if(!response.equals("true")) {
					LOG.error("post was not liked:" + response);
				} else {
					LOG.info("post was liked with response:" + response);
					likeButton.setText("You Like");
					validate();
				}
				
				validate();
			} catch (FacebookException e) {
				LOG.error("error while liking post: " + e.getMessage());
			}
		}
	}

	
	
	private class UpdateThread extends Thread {
		
		//TODO only fetch post from last update
		public boolean update = false;

		@Override
		public void run() {
			try {
				feedModel = new PostTableModel(FacebookService.getFeed(false));
				feedTable.setModel(feedModel);
				
				validate();
			} catch (FacebookException e) {
				LOG.error("Can't fetch data", e);
			}
		}
	}
}
