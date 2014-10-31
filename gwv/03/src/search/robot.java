package search;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Deque;
import java.util.HashSet;
import java.util.LinkedList;
import java.util.Queue;

public class robot {
	// operands
	private static coords _goal = new coords(-1,-1);
	private static coords _start = new coords(-1,-1);
	// options
	private static final String _file_path = "../fields/blatt3_environment.txt";

	public static void main(String args[]) throws IOException {
		field field = new field(_file_path);
		field.print_field();
		System.out.println("Goal: " + get_goal());
		System.out.println("Start " + get_start());
		System.out.println("Starting BFS.");
		System.out.println(bfs(field));
		System.out.println("Starting DFS!");
		System.out.println(dfs(field));	
	}
	
	/*
	 * Make BFS on field and return the path as a String, if found.	
	 */
	private static String bfs(field field) {
		String path = "No path to Goal found";
		State start = new State(get_start(), Direction.NONE, null);
		HashSet<State> seen  = new HashSet<State>();
		Queue <State> frontier = new LinkedList<State>();
		frontier.add(start);
		seen.add(start);
		while (!frontier.isEmpty()){
			State current_state = frontier.remove();
			ArrayList<State> neighbours = compute_neighbours(current_state,field); 
			for (State neighbour : neighbours){
				if (!(seen.contains(neighbour)) && !(neighbour == null)) {
					seen.add(neighbour);
					frontier.add(neighbour);
					if (is_goal(neighbour)){ 
						System.out.println("Goal found!");
						path = neighbour.path_to_start_as_string();
						break;
					}
				}
				else {
					continue;
				}
			}
		}
		return path;
	}
	/*
	 * Make DFS on field and return the path as a String, if found.	
	 * Stack statt Queue.
	 */
	private static String dfs(field field) {		
		
		State start = new State(get_start(), Direction.NONE, null);
		HashSet<State> seen  = new HashSet<State>();
		// Deque as stack - Javas stack implementation seems to be deprecated.
		Deque <State> frontier = new LinkedList<State>();
		frontier.addFirst(start);
		seen.add(start);
		while (!frontier.isEmpty()){
			State current_state = frontier.removeFirst();
			ArrayList<State> neighbours = compute_neighbours(current_state,field); 
			for (State neighbour : neighbours){
				if (!(seen.contains(neighbour)) && !(neighbour == null)) {
					seen.add(neighbour);
					frontier.addFirst(neighbour);
					if (is_goal(neighbour)){ 
						System.out.println("Goal found!");
						return neighbour.path_to_start_as_string();
					}
				}
				else {
					continue;
				}
			}
		}
		return "No path to Goal found";
	}

	

	static coords get_goal() {
		return _goal;
	}

	static coords get_start() {
		return _start;
	}
	
	/*
	 * Check if state is the goal.
	 */
	static boolean is_goal (State state){
		if (state.get_coords().equals(_goal)){
			return true;
		}
		else{
			return false;
		}
	}
	
	private static State go_south(State current_position, field field) {
		coords current_coords = current_position.get_coords();
		coords new_coords = new coords(current_coords.get_x_position(),current_coords.get_y_position()-1);
		if (field.is_passable(new_coords)){
			return new State(new_coords,Direction.NORTH,current_position);
		}
		return null;
	}

	private static State go_east(State current_position, field field) {
		coords current_coords = current_position.get_coords();
		coords new_coords = new coords(current_coords.get_x_position()-1,current_coords.get_y_position());
		if (field.is_passable(new_coords)){
			return new State(new_coords,Direction.WEST,current_position);
		}
		return null;
	}

	private static State go_west(State current_position, field field) {
		coords current_coords = current_position.get_coords();
		coords new_coords = new coords(current_coords.get_x_position()+1,current_coords.get_y_position());
		if (field.is_passable(new_coords)){
			return new State(new_coords,Direction.EAST,current_position);
		}
		return null;
	}

	private static State go_north(State current_position, field field) {
		coords current_coords = current_position.get_coords();
		coords new_coords = new coords(current_coords.get_x_position(),current_coords.get_y_position()+1);
		if (field.is_passable(new_coords)){
			return new State(new_coords,Direction.SOUTH,current_position);
		}
		return null;
	}
	
	public static ArrayList<State> compute_neighbours(State current_position,field field){
		ArrayList<State> neighbours   = new ArrayList<State>();
		neighbours.add(go_north(current_position,field));
		neighbours.add(go_east(current_position,field));
		neighbours.add(go_west(current_position,field ));
		neighbours.add(go_south(current_position,field));
		return neighbours;
	}
}
