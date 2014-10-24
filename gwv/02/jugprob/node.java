public class node {
	private int								_fourLitre;
	private int								_threeLitre;
	private static final int	_threeMax	= 3;
	private static final int	_fourMax	= 4;

	public node(int fourLitre, int threeLitre) {
		_fourLitre = fourLitre;
		_threeLitre = threeLitre;
	}

	public int get_fourLitre() {
		return _fourLitre;
	}

	public int get_threeLitre() {
		return _threeLitre;
	}

	public void change_val(int fourLitre, int threeLitre) {
		_fourLitre = fourLitre;
		_threeLitre = threeLitre;
	}

	public static int get_threeMax() {
		return _threeMax;
	}

	public static int get_fourMax() {
		return _fourMax;
	}

	public boolean equals(Object o) {
		boolean test = false;
		if (o == null)
			test = false;
		if (!(o instanceof node))
			test = false;
		node other = (node) o;
		if (this.get_fourLitre() == other.get_fourLitre()
				&& this.get_threeLitre() == other.get_threeLitre()) {
			test = true;
		}
		return test;
	}
}
