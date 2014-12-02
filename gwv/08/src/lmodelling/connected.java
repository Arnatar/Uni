package lmodelling;

public class connected {
	
	private String _word;
	private int _count;
	private double _prob;
	
	public connected(String word) {
		_word = word;
		_count = 1;
		_prob = 0;
	}
	
	public String get_word() {
		return _word;
	}
	
	public int get_count() {
		return _count;
	}
	
	public double get_prob() {
		return _prob;
	}
	
	public void set_prob(int divisor) {
		this._prob = (double) _count / (double) divisor;
	}
	
	public void incr_count() {
		this._count++;
	}
	
	@Override
	public int hashCode() {
		return _word.hashCode();
	}
	
}
