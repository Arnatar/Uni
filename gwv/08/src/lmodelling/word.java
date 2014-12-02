package lmodelling;

import java.util.ArrayList;
import java.util.Hashtable;

public class word {
	
	private String _word;
	private int _maxCount;
	private ArrayList<connected> _connections;
	
	public word(String word) {
		_word = word;
		_maxCount = 1;
		_connections = new ArrayList<connected>();
	}
	
	public void incr_maxCount() {
		this._maxCount++;
	}
	
	public int get_maxCount() {
		return _maxCount;
	}
	
	public String get_word() {
		return _word;
	}
	
	public void add_connection(String input) {
		boolean isElement = false;
		for (connected e : _connections) {
			if(input.equals(e.get_word())) {
				e.incr_count();
				isElement = true;
				break;
			}
		}
		if(!isElement) {
			_connections.add(new connected(input));
		}
	}
	
	public void print_connected() {
		int count = 1;
		System.out.println("---" + _word + "---");
		for (connected e : _connections) {
			System.out.println("" + count + ".: " + e.get_word() + " " + e.get_count() + " mal");
			count++;
		}
	}
	
	@Override
	public int hashCode() {
		return _word.hashCode();
	}
	
	@Override
	public boolean equals(Object obj) {
		return _word.equals(obj);
	}
	
}