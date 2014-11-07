package search;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.LinkedList;

public class Robot {
	// private static final String _file_path = "fields/blatt3_environment.txt";

	// private static final String _file_path = "fields/blatt4_environment_a.txt";

	private static final String _file_path = "fields/blatt4_environment_b2.txt";

	public static void main(String[] args) throws IOException {
		Field field = new Field(_file_path);
		System.out.println("Field:");
		field.print_field();
		System.out.println();
		System.out.println("Starte A*:");
		State astar_goal = a_star(field);
		if (astar_goal == null) {
			System.out.println("Kein Pfad auffindbar");
		} else {
			System.out.println("Pfad gefunden:");
			// System.out.println(astar_goal.path_to_start_as_string());
			field.print_path(astar_goal.path_to_start_as_list());
			if (field.get_entry(4, 6) != null) {
				System.out.println("Test: " + field.get_entry(4, 4).getF_val());
			} else
				System.out.println("what the fuck");
		}
	}

	/**
	 * A-star Algorithm
	 */
	private static State a_star(Field field) {
		// requirenments
		LinkedList<State> openStates = new LinkedList<State>();
		HashSet<State> closedStates = new HashSet<State>();
		openStates.add(field.get_start());

		// outer loop
		while (!openStates.isEmpty()) {
			State current = eval_current(openStates);
			openStates.remove(current);
			if (current.equals(field.get_goal())) {
				return current;
			}
			closedStates.add(current);
			// expand current
			ArrayList<State> targets = compute_targets(current, field);
			for (State e : targets) {
				if (closedStates.contains(e) || e == null) {
					continue;
				}
				// 1, weil alles gleiche Kosten, ansonsten kosten von current zu
				// successor
				int temp_start_dist = current.getStart_distance() + 1;
				if (openStates.contains(e) && temp_start_dist >= e.getStart_distance()) {
					continue;
				}
				e.setPredecessor(current);
				e.setStart_distance(temp_start_dist);
				if (openStates.contains(e)) {
					openStates.remove(e);
					openStates.add(e);
				} else {
					openStates.add(e);
				}
			}
		}

		return null;
	}

	/**
	 * Bewertungsfunktion der open-queue
	 */
	private static State eval_current(LinkedList<State> openStates) {
		State result = null;
		int result_dist = Integer.MAX_VALUE;
		for (State e : openStates) {
			if (e.getF_val() <= result_dist) {
				result = e;
				result_dist = e.getF_val();
			}
		}
		return result;
	}

	/**
	 * builds an array with all possible targets in the field for the position
	 */
	private static ArrayList<State> compute_targets(State current_position,
			Field field) {
		ArrayList<State> neighbours = new ArrayList<State>();
		neighbours.add(go_north(current_position, field));
		neighbours.add(go_east(current_position, field));
		neighbours.add(go_west(current_position, field));
		neighbours.add(go_south(current_position, field));
		return neighbours;
	}

	/**
	 * evaluates the south-direction for compute_targets
	 */
	private static State go_south(State current_position, Field field) {
		int x = current_position.get_x_position();
		int y = current_position.get_y_position() - 1;
		if (field.is_passable(x, y)) {
			return field.portalcheck(field.get_entry(x, y));
		} else {
			return null;
		}
	}

	/**
	 * evaluates the east-direction for compute_targets
	 */
	private static State go_east(State current_position, Field field) {
		int x = current_position.get_x_position() + 1;
		int y = current_position.get_y_position();
		if (field.is_passable(x, y)) {
			return field.portalcheck(field.get_entry(x, y));
		} else {
			return null;
		}
	}

	/**
	 * evaluates the west-direction for compute_targets
	 */
	private static State go_west(State current_position, Field field) {
		int x = current_position.get_x_position() - 1;
		int y = current_position.get_y_position();
		if (field.is_passable(x, y)) {
			return field.portalcheck(field.get_entry(x, y));
		} else {
			return null;
		}
	}

	/**
	 * evaluates the north-direction for compute_targets
	 */
	private static State go_north(State current_position, Field field) {
		int x = current_position.get_x_position();
		int y = current_position.get_y_position() + 1;
		if (field.is_passable(x, y)) {
			return field.portalcheck(field.get_entry(x, y));
		} else {
			return null;
		}
	}

}
