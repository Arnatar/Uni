package search;

public class State {
	private int _x_position;
	private int _y_position;
	private State _predecessor;
	
	/**
	 * tuple of coordinates in the maze the predecessor is not known and therefor null
	 */
	State(int x, int y) {
		_x_position = x;
		_y_position = y;
		_predecessor = null;
	}
	
	/**
	 * tuple of coordinates in the maze + information of its predecessor
	 */
	State(int x, int y, State pred) {
		_x_position = x;
		_y_position = y;
		_predecessor = pred;
	}
	
	void set_x_position(int x) {
		_x_position = x;
	}
	
	void set_y_position(int y) {
		_y_position = y;
	}
	
	void set_predecessor(State predecessor) {
		_predecessor = predecessor;
	}
	
	int get_x_position() {
		return _x_position;
	}
	
	int get_y_position() {
		return _y_position;
	}
	
	State get_predecessor() {
		return _predecessor;
	}
	
	void print_coords() {
		System.out.print("(" + _x_position + " " + _y_position + ")");
	}
	
	public State clone() {
		return new State(this._x_position, this._y_position, this._predecessor);
	}
	
	public boolean equals(Object o) {
		boolean test = false;
		if (o == null)
			return test;
		if (!(o instanceof State))
			return test;
		State other = (State) o;
		if (this.get_x_position() == other.get_x_position() 
			&& this.get_y_position() == other.get_y_position()) {
			test = true;
		}
		return test;
	}
}
