package search;

import java.io.IOException;
import java.util.LinkedList;

public class robot {
	// operands
	private static coords _goal = new coords(-1, -1);
	private static coords _start = new coords(-1, -1);
	// options
	private static final String _file_path = "fields/blatt3_environment.txt";

	public static void main(String args[]) throws IOException {
		field field = new field(_file_path);
		//field.print_field();
		//System.out.println("");
		bfs(_start, field);
	}

	private static void bfs(coords current ,field field) {
		LinkedList<coords> queue = new LinkedList<coords>();
		queue.add(current);
		LinkedList<coords> targets = give_targets(current, field);
	}

	private static void dfs(field field) {
		
	}
	
	/**
	 * returns a queue/list of all possible targets;
	 */
	private static LinkedList<coords> give_targets(coords current, field field) {
		LinkedList<coords> result = new LinkedList<coords>();
		coords temp = current.clone();
		temp.set_x_position(current.get_x_position() - 1);
		if(field.passable(temp)) {
			result.add(temp);
		}
		temp = current.clone();
		temp.set_y_position(current.get_y_position() + 1);
		if(field.passable(temp)) {
			result.add(temp);
		}
		temp = current.clone();
		temp.set_x_position(current.get_x_position() + 1);
		if(field.passable(temp)) {
			result.add(temp);
		}
		temp = current.clone();
		temp.set_y_position(current.get_y_position() - 1);
		if(field.passable(temp)) {
			result.add(temp);
		}
		return result;
	}
	
	static coords get_goal() {
		return _goal;
	}

	static coords get_start() {
		return _start;
	}
}
