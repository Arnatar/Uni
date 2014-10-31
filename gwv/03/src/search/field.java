package search;

import java.io.FileReader;
import java.io.IOException;

class field {
	private boolean[][] _game_field;

	field(String file_path) throws IOException {
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
						robot.get_goal().set_x_position(x);
						robot.get_goal().set_y_position(y);
					}
					if (c == (int) 's') {
						robot.get_start().set_x_position(x);
						robot.get_start().set_y_position(y);
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
	boolean is_passable(coords coords) {
		if (this.is_in_field(coords)) {
			return _game_field[coords.get_y_position()][coords.get_x_position()];
		}
		return false;
	}
	/**
	 * Prüft ob coords innerhalb des Feldes liegt.
	 * @param coords Koordinaten, die zu prüfen sind	  
	 */
	private boolean is_in_field(coords coords){
		if (coords.get_x_position() < _game_field[0].length
				&& 0 <= coords.get_x_position()
				&& coords.get_y_position() < _game_field.length
				&& 0 <= coords.get_y_position()){
			return true;
			}
		else{
			return false;
		}
	}

	/**
	 * prints field to console. 4 debug atm
	 */
	void print_field() {
		if (_game_field == null) {
			System.out.println("Schade");
		} else {
			for (int y = 0; y < _game_field.length; y++) {
				for (int x = 0; x < _game_field[y].length; x++) {
					if (_game_field[y][x])
						System.out.print(" ");
					else
						System.out.print("x");
				}
				System.out.println("");
			}
		}
	}

}
