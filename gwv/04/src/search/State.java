package search;

import java.util.LinkedList;

public class State {

	private State predecessor;
	private Direction direction_to_start;
	private int x_position;
	private int y_position;
	private int represented_char;
	private State portal_target;
	private int start_distance;
	private int est_goal_distance;
	private int f_val;

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
		if (c == (int) 's') {
			this.start_distance = 0;
		} else {
			this.start_distance = Integer.MAX_VALUE / 2;
		}
		if (c == (int) 'g') {
			this.est_goal_distance = 0;
		} else {
			this.est_goal_distance = Integer.MAX_VALUE / 2;
		}
		this.f_val = this.start_distance + this.est_goal_distance;
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

	public int getEst_goal_distance() {
		return est_goal_distance;
	}

	public int getF_val() {
		return f_val;
	}

	public int getStart_distance() {
		return start_distance;
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

	public void setEst_goal_distance(int est_goal_distance) {
		this.est_goal_distance = est_goal_distance;
		this.f_val = this.est_goal_distance + this.start_distance;
	}

	public void setStart_distance(int start_distance) {
		this.start_distance = start_distance;
		this.f_val = this.est_goal_distance + this.start_distance;
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
		temp = path_to_start_as_list(temp);
		return temp;
	}

	private LinkedList<State> path_to_start_as_list(LinkedList<State> result) {
		if (this.get_predecessor() == null) {
			result.addFirst(this);
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
