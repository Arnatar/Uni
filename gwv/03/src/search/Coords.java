package search;

public class Coords {
	private int _x_position;
	private int _y_position;
	
	/**
	 * tuple of coordinates in the maze
	 */
	Coords(int x, int y) {
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

	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + _x_position;
		result = prime * result + _y_position;
		return result;
	}

	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		Coords other = (Coords) obj;
		if (_x_position != other._x_position)
			return false;
		if (_y_position != other._y_position)
			return false;
		return true;
	}

	@Override
	public String toString() {
		return "_x_position=" + _x_position + ", _y_position="
				+ _y_position;
	}
	
}
