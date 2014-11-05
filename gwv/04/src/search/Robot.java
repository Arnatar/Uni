package search;

import java.io.IOException;

public class Robot {
	private static final String _file_path = "fields/blatt3_environment.txt";

	private static State start = new State(-1, -1, (int) 'g');
	private static State goal = new State(-1, -1, (int) 's');

	// private static final String _file_path = "fields/problem.txt";

	public static void main(String[] args) throws IOException {
		Field field = new Field(_file_path);
		System.out.println("Field:");
		field.print_field();
		System.out.println();
	}
	
	public static State getGoal() {
		return goal;
	}
	
	public static State getStart() {
		return start;
	}
	
	public static void setGoalCoords(int x, int y) {
		Robot.goal.set_x_position(x);
		Robot.goal.set_y_position(y);
	}
	
	public static void setStartCoords(int x, int y) {
		Robot.start.set_x_position(x);
		Robot.start.set_y_position(y);
	}

}
