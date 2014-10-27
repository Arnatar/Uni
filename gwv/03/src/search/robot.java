package search;

import java.io.IOException;

public class robot {
	// operands
	private static coords _goal = new coords(-1, -1);
	private static coords _start = new coords(-1, -1);
	// options
	private static final String _file_path = "fields/blatt3_environment.txt";

	public static void main(String args[]) throws IOException {
		field field = new field(_file_path);
		field.print_field();
	}

	private static void bfs(field field) {

	}

	private static void dfs(field field) {

	}

	static coords get_goal() {
		return _goal;
	}

	static coords get_start() {
		return _start;
	}
}
