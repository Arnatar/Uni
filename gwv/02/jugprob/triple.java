package jugprob;

class triple {
	private final node	_node;
	private boolean			_visisted;
	private int					_dist;

	triple(node node, boolean visited, int dist) {
		_node = node;
		_visisted = visited;
		_dist = dist;
	}

	node get_node() {
		return _node;
	}

	boolean get_visited() {
		return _visisted;
	}

	void set_visited() {
		_visisted = true;
	}

	void set_dist(int dist) {
		_dist = dist;
	}

	int get_dist() {
		return _dist;
	}
}
