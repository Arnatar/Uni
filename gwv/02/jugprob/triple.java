
public class triple {
	private final node _node;
	private boolean _visisted;
	private int _dist;
	
	public triple(node node, boolean visited, int dist) {
		_node = node;
		_visisted = visited;
		_dist = dist;
	}
	
	public node get_node() {
		return _node;
	}
	
	public boolean get_visited() {
		return _visisted;
	}
	
	public void set_visited() {
		_visisted = true;
	}
	
	public void set_dist(int dist) {
		_dist = dist;
	}
	
	public int get_dist() {
		return _dist;
	}
}
