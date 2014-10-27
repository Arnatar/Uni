package search;

public class coords {
	private int _x_position;
	private int _y_position;
	
	/**
	 * tuple of coordinates in the maze
	 */
	coords(int x, int y) {
		_x_position = x;
		_y_position = y;
	}
	
	void set_x_position(int x) {
		_x_position = x;
	}
	
	void set_y_position(int y) {
		_y_position = y;
	}
	
	int get_x_position() {
		return _x_position;
	}
	
	int get_y_position() {
		return _y_position;
	}
}
