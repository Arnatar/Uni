package search;

import java.io.FileReader;
import java.io.IOException;
import java.util.LinkedList;

public class Field {
	private State[][] _game_field;
	private boolean portal_found = false;
	private State _goal = new State(-1, -1, 'g');
	private State _start = new State(-1, -1, 's');

	public Field(String file_path) throws IOException {
		_game_field = buildt_field_from_file(file_path);
		build_portals();
		build_distances();
		if (portal_found) {
			build_portal_distances();
		}
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
					if (c == (int) 's') {
						_start.set_x_position(x);
						_start.set_y_position(y);
					}
					if (c == (int) 'g') {
						_goal.set_x_position(x);
						_goal.set_y_position(y);
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
	 * builds portal-connections between all non-key-symbols and duplicates of it
	 * (problem: 3 or more symbols)
	 */
	private void build_portals() {
		for (int y = 0; y < _game_field.length; y++) {
			for (int x = 0; x < _game_field[y].length; x++) {
				if (is_passable(x, y)
						&& _game_field[y][x].getRepresented_char() != (int) 'g'
						&& _game_field[y][x].getRepresented_char() != (int) 's'
						&& _game_field[y][x].getRepresented_char() != (int) ' ') {
					for (int b = 0; b < _game_field.length; b++) {
						for (int a = 0; a < _game_field[b].length; a++) {
							if (is_passable(a, b)) {
								if (_game_field[y][x].getRepresented_char() == _game_field[b][a]
										.getRepresented_char()
										&& !_game_field[y][x].equals(_game_field[b][a])) {
									_game_field[y][x].setPortal_target(_game_field[b][a]);
									portal_found = true;
								}
							}
						}
					}
				}
			}
		}
	}

	/**
	 * Sets estimated goal-distances for the States based on the manhattan
	 * distance to the goal If field has a goal-target, the 2 distances are
	 * calculated (for some parts again) but with the portal target as manhattan
	 * source and vice versa.
	 */
	private void build_distances() {
		for (int y = 0; y < _game_field.length; y++) {
			for (int x = 0; x < _game_field[y].length; x++) {
				if (is_passable(x, y)) {
					if (_game_field[y][x].getPortal_target() != null) {
						_game_field[y][x].getPortal_target().setEst_goal_distance(
								manhattan_dist(_game_field[y][x], _goal));
						_game_field[y][x].setEst_goal_distance(manhattan_dist(
								_game_field[y][x].getPortal_target(), _goal));
					} else {
						_game_field[y][x].setEst_goal_distance(manhattan_dist(
								_game_field[y][x], _goal));
					}
				}
			}
		}
	}

	/*
	 * Gedanken: wenn manhattan(mir, goal) > nextportal.goalDist + manhattan()
	 */
	private void build_portal_distances() {
		LinkedList<State> portals = getPortals();
		for (int y = 0; y < _game_field.length; y++) {
			for (int x = 0; x < _game_field[y].length; x++) {
				if (is_passable(x, y)) {
					for (State e : portals) {
						if (!portals.contains(_game_field[y][x])) {
							int tempdist = manhattan_dist(_game_field[y][x], e)
									+ e.getEst_goal_distance();
							if (_game_field[y][x].getEst_goal_distance() > tempdist) {
								_game_field[y][x].setEst_goal_distance(tempdist);
							}
						}
					}
				}
			}
		}
	}

	private LinkedList<State> getPortals() {
		LinkedList<State> result = new LinkedList<State>();
		for (int y = 0; y < _game_field.length; y++) {
			for (int x = 0; x < _game_field[y].length; x++) {
				if (is_passable(x, y)) {
					if (_game_field[y][x].getPortal_target() != null) {
						result.add(_game_field[y][x]);
					}
				}
			}
		}
		return result;
	}

	/**
	 * Manhattan distance
	 */
	private int manhattan_dist(State source, State target) {
		return Math.abs(source.get_x_position() - target.get_x_position())
				+ Math.abs(source.get_y_position() - target.get_y_position());
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
		return x < _game_field[0].length && 0 <= x && y < _game_field.length
				&& 0 <= y;
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
							if (e.equals(_game_field[y][x])) {
								if ((char) e.getRepresented_char() == 'g') {
									System.out.print("g");
									break;
								} else if ((char) e.getRepresented_char() == 's') {
									System.out.print("s");
									break;
								} else if ((char) e.getRepresented_char() == ' ') {
									System.out.print("p");
									break;
								}
							} else if (e.equals(path.peekLast())) {
								System.out.print(""
										+ (char) _game_field[y][x].getRepresented_char());
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
	 * prints field to console
	 */
	public void print_field() {
		if (_game_field == null) {
			System.out.println("Schade");
		} else {
			for (int y = 0; y < _game_field.length; y++) {
				for (int x = 0; x < _game_field[y].length; x++) {
					if (_game_field[y][x] != null) {
						System.out.print(""
								+ (char) _game_field[y][x].getRepresented_char());
					} else {
						System.out.print("x");
					}
				}
				System.out.println("");
			}
		}
	}

	public void reset_predecessors() {
		for (int y = 0; y < _game_field.length; y++) {
			for (int x = 0; x < _game_field[y].length; x++) {
				_game_field[y][x].setPredecessor(null);
			}
		}
	}

	public void reset_predecessor(int x, int y) {
		if (is_passable(x, y)) {
			_game_field[y][x].setPredecessor(null);
		}
	}

	public State get_entry(int x, int y) {
		if (is_in_field(x, y))
			return _game_field[y][x];
		else
			return null;
	}

	public State portalcheck(State current) {
		if (current.getPortal_target() == null) {
			return current;
		} else {
			return current.getPortal_target();
		}
	}

	public State get_start() {
		return _start;
	}

	public State get_goal() {
		return _goal;
	}

}
