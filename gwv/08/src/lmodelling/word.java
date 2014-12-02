package lmodelling;

import java.util.ArrayList;

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

	/**
	 * tries to add a word to connected list.
	 * adds a connection if input is not in connection list.
	 * if input is in list, increments counter.
	 */
	public void add_connection(String input) {
		boolean isElement = false;
		for (connected e : _connections) {
			if (input.equals(e.get_word())) {
				e.incr_count();
				isElement = true;
				break;
			}
		}
		if (!isElement) {
			_connections.add(new connected(input));
		}
	}

	/** 
	 * prints connected words with information
	 */
	public void print_connected() {
		int count = 1;
		System.out.println("---" + _word + "---");
		for (connected e : _connections) {
			System.out.println("" + count + ".: " + e.get_word() + " "
					+ e.get_count() + " mal mit " + e.get_prob());
			count++;
		}
	}
	
	/**
	 * set the probability for each connected word
	 */
	public void set_probs() {
		for (connected e : _connections) {
			e.set_prob(_maxCount);
		}
	}

	/**
	 * generates next word from current word
	 */
	public String evalNext() {
		if (_connections.isEmpty()) {
			return ".(Ende)";
		} else {
			boolean toRepeat = true;
			ArrayList<connected> resultList = new ArrayList<connected>();
			while (toRepeat) {
				double prob = Math.random();
				for (connected e : _connections) {
					if (e.get_prob() > prob) {
						resultList.add(e);
						toRepeat = false;
					}
				}
			}
			int index = (int) (Math.random() * (resultList.size()));
			return resultList.get(index).get_word();
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