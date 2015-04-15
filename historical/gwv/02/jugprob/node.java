package jugprob;

class node {
	private int								_bigger_jug;
	private int								_smaller_jug;
	private static final int	_smaller_max	= 3;
	private static final int	_bigger_max		= 4;

	node(int fourLitre, int threeLitre) {
		_bigger_jug = fourLitre;
		_smaller_jug = threeLitre;
	}

	static int get_smaller_max() {
		return _smaller_max;
	}

	static int get_bigger_max() {
		return _bigger_max;
	}

	int get_bigger_jug() {
		return _bigger_jug;
	}

	int get_smaller_jug() {
		return _smaller_jug;
	}

	void change_val(int biggerVal, int smallerVal) {
		_bigger_jug = biggerVal;
		_smaller_jug = smallerVal;
	}

	void print_node() {
		System.out.print("(" + _bigger_jug + " " + _smaller_jug + ") ");
	}

	public boolean equals(Object o) {
		boolean test = false;
		if (o == null)
			test = false;
		if (!(o instanceof node))
			test = false;
		node other = (node) o;
		if (this.get_bigger_jug() == other.get_bigger_jug()
				&& this.get_smaller_jug() == other.get_smaller_jug()) {
			test = true;
		}
		return test;
	}
}
