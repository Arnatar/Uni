package search;

import java.io.IOException;
import java.util.ArrayList;
import java.util.LinkedList;

public class Robot {
	// operands
	private static State _goal = new State(-1, -1);
	private static State _start = new State(-1, -1);
	// options
	private static final String _file_path = "fields/blatt3_environment.txt"; // "fields/simple.txt";

	public static void main(String args[]) throws IOException {
		Field Field = new Field(_file_path);
		// Field.print_Field();
		// System.out.println("");
		Field.print_path(bfs(_start, Field));
		
	}
	
	/**
	 * builds a LinkedList over the States of the path to the goal
	 */
	private static LinkedList<State> bfs(State start, Field Field) {
		// vars and stuff
		LinkedList<State> queue = new LinkedList<State>();
		queue.add(start);
		ArrayList<State> visited = new ArrayList<State>();
		visited.add(start);
		LinkedList<State> targets = null;
		State current = null;

		// bfs:
		outerloop: while (!queue.isEmpty()) {
			current = queue.poll();
			targets = give_targets(current, Field);
			for (State target : targets) {
				if (!visited.contains(target)) {
					queue.add(target);
					visited.add(target);
					if (target.equals(_goal)) {
						_goal.set_predecessor(current);
						break outerloop;
					}
				}
			}
		}

		// buildt path
		LinkedList<State> result = new LinkedList<State>();
		result.add(_goal);
		while (!result.peek().equals(_start)) {
			for (State e : visited) {
				if (e.equals(result.peek().get_predecessor())) {
					result.addFirst(e);
				}
			}
		}
		return result;
	}

	private static void dfs(Field Field) {

	}

	/**
	 * returns a queue/list of all possible targets;
	 */
	private static LinkedList<State> give_targets(State current, Field Field) {
		LinkedList<State> result = new LinkedList<State>();
		State temp = current.clone();
		temp.set_x_position(current.get_x_position() - 1);
		temp.set_predecessor(current);
		if (Field.passable(temp)) {
			result.add(temp);
		}
		temp = current.clone();
		temp.set_y_position(current.get_y_position() + 1);
		temp.set_predecessor(current);
		if (Field.passable(temp)) {
			result.add(temp);
		}
		temp = current.clone();
		temp.set_x_position(current.get_x_position() + 1);
		temp.set_predecessor(current);
		if (Field.passable(temp)) {
			result.add(temp);
		}
		temp = current.clone();
		temp.set_y_position(current.get_y_position() - 1);
		temp.set_predecessor(current);
		if (Field.passable(temp)) {
			result.add(temp);
		}
		return result;
	}

	static State get_goal() {
		return _goal;
	}

	static State get_start() {
		return _start;
	}
}
