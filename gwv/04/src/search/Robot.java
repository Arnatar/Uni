package search;

import java.io.IOException;
import java.util.ArrayList;

public class Robot {
	// private static final String _file_path = "fields/blatt3_environment.txt";
	private static final String _file_path = "fields/blatt4_environment_a.txt";

	// private static final String _file_path =
	// "fields/blatt4_environment_b2.txt";

	public static void main(String[] args) throws IOException {
		Field field = new Field(_file_path);
		System.out.println("Field:");
		field.print_field();
		System.out.println();
		System.out.println("Starte A*:");
		State astar_goal = astar(field);
		if (astar_goal == null) {
			System.out.println("Kein Pfad auffindbar");
		} else {
			System.out.println("Pfad gefunden:");
			System.out.println(astar_goal.path_to_start_as_string());
			field.print_path(astar_goal.path_to_start_as_list());
		}
	}

	private static State astar(Field field) {
		return null;
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
			field.get_entry(x, y).setPredecessor(current_position);
			field.get_entry(x, y).setDirection_to_start(Direction.NORTH);
			return field.get_entry(x, y);
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
			field.get_entry(x, y).setPredecessor(current_position);
			field.get_entry(x, y).setDirection_to_start(Direction.WEST);
			return field.get_entry(x, y);
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
		if(field.is_passable(x, y)) {
			field.get_entry(x, y).setPredecessor(current_position);
			field.get_entry(x, y).setDirection_to_start(Direction.EAST);
			return field.get_entry(x, y);
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
		if(field.is_passable(x, y)) {
			field.get_entry(x, y).setPredecessor(current_position);
			field.get_entry(x, y).setDirection_to_start(Direction.SOUTH);
			return field.get_entry(x, y);
		} else {
			return null;
		}
	}

}
