package search;

import java.util.LinkedList;

public class State {

	private State predecessor;
	private Direction direction_to_start;
	private int x_position;
	private int y_position;
	private int represented_char;
	private State portal_target;

	/**
	 * tuple of coordinates in the maze
	 */
	State(int x, int y, int c) {
		this.x_position = x;
		this.y_position = y;
		this.direction_to_start = Direction.NONE;
		this.predecessor = null;
		this.represented_char = c;
		this.portal_target = null;
	}

	State(int x, int y, char c, Direction to_root, State pred) {
		this.x_position = x;
		this.y_position = y;
		this.direction_to_start = to_root;
		this.predecessor = pred;
		this.represented_char = c;
		this.portal_target = null;
	}

	public State get_predecessor() {
		return this.predecessor;
	}

	public Direction get_direction_to_start() {
		return this.direction_to_start;
	}

	public int getRepresented_char() {
		return represented_char;
	}

	public int get_x_position() {
		return x_position;
	}

	public int get_y_position() {
		return y_position;
	}
	
	public State getPortal_target() {
		return portal_target;
	}
	
	public void setPortal_target(State portal_target) {
		this.portal_target = portal_target;
	}
	
	public void setRepresented_char(char represented_char) {
		this.represented_char = represented_char;
	}

	public void set_x_position(int x) {
		x_position = x;
	}

	public void set_y_position(int y) {
		y_position = y;
	}
	
	public void setDirection_to_start(Direction direction_to_start) {
		this.direction_to_start = direction_to_start;
	}
	
	public void setPredecessor(State predecessor) {
		this.predecessor = predecessor;
	}

	public LinkedList<State> path_to_start_as_list() {
		LinkedList<State> temp = new LinkedList<State>();
		return path_to_start_as_list(temp);
	}

	private LinkedList<State> path_to_start_as_list(LinkedList<State> result) {
		Direction direction = this.get_direction_to_start();
		if (direction.equals(Direction.NONE)) {
			result.add(this);
		} else {
			result.addFirst(this);
			result = this.get_predecessor().path_to_start_as_list(result);
		}
		return result;
	}

	public String path_to_start_as_string() {
		Direction direction = this.get_direction_to_start();
		if (direction.equals(Direction.NONE)) {
			return "The path: START";
		} else {
			return this.get_predecessor().path_to_start_as_string() + " "
					+ direction.toString();
		}
	}

	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + x_position;
		result = prime * result + y_position;
		return result;
	}

	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		State other = (State) obj;
		if (x_position != other.x_position)
			return false;
		if (y_position != other.y_position)
			return false;
		if (represented_char != other.represented_char)
			return false;
		return true;
	}

	@Override
	public String toString() {
		return "x_position=" + x_position + ", y_position=" + y_position;
	}

}
