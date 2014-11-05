package search;

import java.io.FileReader;
import java.io.IOException;
import java.util.LinkedList;

public class Field {
	private State[][] _game_field;

	public Field(String file_path) throws IOException {
		_game_field = buildt_field_from_file(file_path);
	}

	/**
	 * reads a maze from a file in the fields directory & makes a field from it.
	 * sets also start & goal coords.
	 */
	private State[][] buildt_field_from_file(String file_path) throws IOException {
		int x = 0;
		int y = 0;
		FileReader inStream = null;
		State[][] result = null;

		try {
			inStream = new FileReader(file_path);
			int c = 0;
			boolean first_line = true;

			while ((c = inStream.read()) != -1) {
				if (c != (int) '\n' && first_line) {
					x++;
				} else if (c == (int) '\n') {
					first_line = false;
					y++;
				}
			}
		} finally {
			if (inStream != null) {
				inStream.close();
			}
		}

		inStream = null;
		result = new State[y][x];
		x = 0;
		y = 0;
		try {
			inStream = new FileReader(file_path);
			int c = 0;
			while ((c = inStream.read()) != -1) {
				if (c == (int) 'x') {
					result[y][x] = null;
					x++;
				} else if (c == (int) '\n') {
					y++;
					x = 0;
				} else {
					// TODO
					if (c == (int) 'g') {
						// Robot.get_goal().set_x_position(x);
						// Robot.get_goal().set_y_position(y);
					}
					if (c == (int) 's') {
						// Robot.get_start().set_x_position(x);
						// Robot.get_start().set_y_position(y);
					}
					result[y][x] = new State(x, y, c);
					x++;
				}
			}
		} finally {
			if (inStream != null) {
				inStream.close();
			}
		}
		return result;
	}

	/**
	 * analyzes if the entry corresponding to the coords is passable
	 */
	public boolean is_passable(int x, int y) {
		return _game_field[y][x] != null && is_in_field(x, y);
	}

	/**
	 * checks if coords can be addressed in this field
	 */
	private boolean is_in_field(int x, int y) {
		if (x < _game_field[0].length && 0 <= x && y < _game_field.length && 0 <= y) {
			return true;
		} else {
			return false;
		}
	}

	/**
	 * prints the field with the path to console
	 */
	public void print_path(LinkedList<State> path) {
		if (_game_field == null) {
			System.out.println("Field empty");
		} else {
			for (int y = 0; y < _game_field.length; y++) {
				for (int x = 0; x < _game_field[y].length; x++) {
					if (is_passable(x, y)) {
						for (State e : path) {
							if (e.get_x_position() == x
									&& e.get_y_position() == y) {
								if (e.equals(Robot.get_start())) {
									System.out.print("s");
									break;
								} else if (e.get_coords().equals(Robot.get_goal())) {
									System.out.print("g");
									break;
								} else {
									System.out.print("p");
									break;
								}
							} else if (e.equals(path.peekLast())) {
								System.out.print(" ");
							}
						}

					} else {
						System.out.print("x");
					}
				}
				System.out.println("");
			}
		}
	}

	/**
	 * prints field to console. 4 debug atm
	 */
	public void print_field() {
		if (_game_field == null) {
			System.out.println("Schade");
		} else {
			for (int y = 0; y < _game_field.length; y++) {
				for (int x = 0; x < _game_field[y].length; x++) {
					if (_game_field[y][x]) {
						if (Robot.get_start().get_x_position() == x
								&& Robot.get_start().get_y_position() == y) {
							System.out.print("s");
						} else if (Robot.get_goal().get_x_position() == x
								&& Robot.get_goal().get_y_position() == y) {
							System.out.print("g");
						} else {
							System.out.print(" ");
						}
					} else {
						System.out.print("x");
					}
				}
				System.out.println("");
			}
		}
	}

}
