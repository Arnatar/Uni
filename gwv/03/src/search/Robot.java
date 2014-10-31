package search;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Deque;
import java.util.HashSet;
import java.util.LinkedList;
import java.util.Queue;

public class Robot {
	// operands
	private static Coords _goal_coords = new Coords(-1, -1);
	private static Coords _start_coords = new Coords(-1, -1);
	// options
	private static final String _file_path = "fields/blatt3_environment.txt"; // "fields/simple.txt";

	public static void main(String args[]) throws IOException {
		Field field = new Field(_file_path);
		System.out.println("Field:");
		field.print_field();
		System.out.println();
		System.out.println("Starting BFS.");
		State bfs_goal = bfs(field);
		if (bfs_goal == null) {
			System.out.println("No goal found with bfs.");
		} else {
			System.out.println(bfs_goal.path_to_start_as_string());
			field.print_path(bfs_goal.path_to_start_as_list());
		}
		System.out.println();
		System.out.println("Starting DFS");
		State dfs_goal = dfs(field);
		if (dfs_goal == null) {
			System.out.println("No goal found with dfs.");
		} else {
			System.out.println(dfs_goal.path_to_start_as_string());
			field.print_path(dfs_goal.path_to_start_as_list());
		}
	}

	/**
	 * Make BFS on field and return goal-state, if found.
	 * You can build the path with methods from the state class. 
	 * Stack instead of queue.
	 */
	private static State bfs(Field field) {
		State result = null;
		State start = new State(get_start(), Direction.NONE, null);
		HashSet<State> visited = new HashSet<State>();
		Queue<State> queue = new LinkedList<State>();
		queue.add(start);
		visited.add(start);
		while (!queue.isEmpty()) {
			State current_state = queue.remove();
			ArrayList<State> targets = compute_targets(current_state, field);
			for (State target : targets) {
				if (!(visited.contains(target)) && !(target == null)) {
					visited.add(target);
					queue.add(target);
					if (is_goal(target)) {
						System.out.println("Goal found!");
						result = target;
						break;
					}
				} else {
					continue;
				}
			}
		}
		return result;
	}

	/**
	 * Make DFS on field and return goal-state, if found.
	 * You can build the path with methods from the state class. 
	 * Stack instead of queue.
	 */
	private static State dfs(Field field) {
		// String path = "No path to Goal found";
		State result = null;
		State start = new State(get_start(), Direction.NONE, null);
		HashSet<State> visited = new HashSet<State>();
		// Deque as stack - Javas stack implementation seems to be deprecated.
		Deque<State> stack = new LinkedList<State>();
		stack.addFirst(start);
		visited.add(start);
		while (!stack.isEmpty()) {
			State current_state = stack.removeFirst();
			ArrayList<State> targets = compute_targets(current_state, field);
			for (State target : targets) {
				if (!(visited.contains(target)) && !(target == null)) {
					visited.add(target);
					stack.addFirst(target);
					if (is_goal(target)) {
						System.out.println("Goal found!");
						result = target;
						break;
					}
				} else {
					continue;
				}
			}
		}
		return result;
	}

	/**
	 * returns coordinates of the goal
	 */
	static Coords get_goal() {
		return _goal_coords;
	}

	/**
	 * returns coordinates of the start
	 */
	static Coords get_start() {
		return _start_coords;
	}

	/**
	 * Check if state is the goal.
	 */
	private static boolean is_goal(State state) {
		if (state.get_coords().equals(_goal_coords)) {
			return true;
		} else {
			return false;
		}
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
		Coords current_coords = current_position.get_coords();
		Coords new_coords = new Coords(current_coords.get_x_position(),
				current_coords.get_y_position() - 1);
		if (field.is_passable(new_coords)) {
			return new State(new_coords, Direction.NORTH, current_position);
		}
		return null;
	}

	/**
	 * evaluates the east-direction for compute_targets
	 */
	private static State go_east(State current_position, Field field) {
		Coords current_coords = current_position.get_coords();
		Coords new_coords = new Coords(current_coords.get_x_position() - 1,
				current_coords.get_y_position());
		if (field.is_passable(new_coords)) {
			return new State(new_coords, Direction.WEST, current_position);
		}
		return null;
	}

	/**
	 * evaluates the west-direction for compute_targets
	 */
	private static State go_west(State current_position, Field field) {
		Coords current_coords = current_position.get_coords();
		Coords new_coords = new Coords(current_coords.get_x_position() + 1,
				current_coords.get_y_position());
		if (field.is_passable(new_coords)) {
			return new State(new_coords, Direction.EAST, current_position);
		}
		return null;
	}

	/**
	 * evaluates the north-direction for compute_targets
	 */
	private static State go_north(State current_position, Field field) {
		Coords current_coords = current_position.get_coords();
		Coords new_coords = new Coords(current_coords.get_x_position(),
				current_coords.get_y_position() + 1);
		if (field.is_passable(new_coords)) {
			return new State(new_coords, Direction.SOUTH, current_position);
		}
		return null;
	}
}
