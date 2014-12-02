package lmodelling;

public class connected {
	
	private String _word;
	private int _count;
	
	public connected(String word) {
		_word = word;
		_count = 1;
	}
	
	public String get_word() {
		return _word;
	}
	
	public int get_count() {
		return _count;
	}
	
	public void incr_count() {
		this._count++;
	}
	
	@Override
	public int hashCode() {
		return _word.hashCode();
	}
	
}
