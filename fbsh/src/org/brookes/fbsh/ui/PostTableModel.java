package org.brookes.fbsh.ui;

import java.util.List;

import charvax.swing.table.AbstractTableModel;
import com.restfb.types.Post;

public class PostTableModel extends AbstractTableModel {

	private List<Post> model;
	
	public List<Post> getModel() {
		return model;
	}
	
	public Post getModelAt(int pos) {
		return model.get(pos);
	}
	
	public PostTableModel(List<Post> posts) {
		this.model = posts;
	}
	
	@Override
	public String getColumnName(int column) {
		String value = "";
		
		switch (column) {
		case 0:
			value = "Name";
			break;
		case 1:
			value = "Message";
			break;
		default:
			break;
		}
		
		return value;
	}
	
	@Override
	public int getColumnCount() {
		return 2;
	}

	@Override
	public Object getValueAt(int row, int column) throws IndexOutOfBoundsException {
		Post p = model.get(row);
		switch (column) {
		case 0:
			return p.getFrom().getName();
		case 1:
			return p.getMessage();
		default:
			throw new IndexOutOfBoundsException("Not implemented yet");
		}
	}

	@Override
	public int getRowCount() {
		return model.size();
	}

}
