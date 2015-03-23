package search;

import java.io.FileReader;
import java.io.IOException;
import java.util.LinkedList;

class Field {
	private boolean[][] _game_field;

	public Field(String file_path) throws IOException {
		_game_field = buildt_field_from_file(file_path);
	}

	/**
	 * reads a maze from a file in the fields directory & makes a field from it.
	 * sets also start & goal coords.
	 */
	private boolean[][] buildt_field_from_file(String file_path)
			throws IOException {
		int x = 0;
		int y = 0;
		FileReader inStream = null;
		boolean[][] result = null;

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
		// hätte mal vorher schauen sollen, ob FileReader reset implementiert,
		// drecks code-duplication, gnarf
		// aber konsequenz heißt auch Holzwege zu ende zu gehen...

		inStream = null;
		result = new boolean[y][x];
		x = 0;
		y = 0;
		try {
			inStream = new FileReader(file_path);
			int c = 0;
			while ((c = inStream.read()) != -1) {
				if (c == (int) 'x') {
					result[y][x] = false;
					x++;
				} else if (c == (int) '\n') {
					y++;
					x = 0;
				} else {
					if (c == (int) 'g') {
						Robot.get_goal().set_x_position(x);
						Robot.get_goal().set_y_position(y);
					}
					if (c == (int) 's') {
						Robot.get_start().set_x_position(x);
						Robot.get_start().set_y_position(y);
					}
					result[y][x] = true;
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
	 * analyzes if the entry corresponting to the coords is passable
	 */
	public boolean is_passable(Coords coords) {
		if (this.is_in_field(coords)) {
			return _game_field[coords.get_y_position()][coords.get_x_position()];
		}
		return false;
	}

	/**
	 * checks if coords can be adressed in this field
	 */
	private boolean is_in_field(Coords coords) {
		if (coords.get_x_position() < _game_field[0].length
				&& 0 <= coords.get_x_position()
				&& coords.get_y_position() < _game_field.length
				&& 0 <= coords.get_y_position()) {
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
					if (_game_field[y][x]) {
						for (State e : path) {
							if (e.get_coords().get_x_position() == x
									&& e.get_coords().get_y_position() == y) {
								if (e.get_coords().equals(Robot.get_start())) {
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
