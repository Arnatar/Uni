import java.util.ArrayList;
import java.util.Collection;
import java.util.HashSet;
import java.util.LinkedList;
import java.util.Queue;
import java.util.Set;


public class Riddle_Solver {
	boolean spill;
	boolean best_solution; 
	Collection <State> states;
	private State start_state;
	private Set<State> goal_states;
	private State goal_reached = null;
	
	public Riddle_Solver(){
		
	}
	public Riddle_Solver(int jugcapacity_1, int jugcapacity_2, Set<State> goals, boolean spill_stuff, boolean best){
		this.spill = spill_stuff;
		this.goal_reached = null;
		this.goal_states = goals;
		this.start_state = new State(jugcapacity_1, jugcapacity_2);
		this.best_solution = best;
		this.states = this.compute_all_possible_states(this.start_state);
 	}
	public Set <State> compute_all_possible_states(State start){
		Set<State> states  = new HashSet<>();
		Queue <State> to_explore = new LinkedList<State>();
		states.add(start);
		to_explore.add(start);
		boolean debug =true;
		/*
		 * Neue in die Queue. Dann exploren, und nur die States in die Queue, die noch nicht bereits explored worden sind.
		 * Wenn die Queue leer ist, dann sind alle explored.  
		 */
		while (!to_explore.isEmpty()){
			State current_state = to_explore.remove();
			ArrayList<State> neighbours = current_state.explore_neighbours(); 
			for (State neighbour : neighbours){
				if (!states.contains(neighbour)) {
					states.add(neighbour);
					to_explore.add(neighbour);
					if (this.goal_states.contains(neighbour)){
						this.goal_reached =neighbour; 
						break;
					}
					
				}
				else {
					continue;
				}
			}
		}
		return states;
	}
	
	public String solve() {
		if (this.goal_reached == null){
			return "No solution possible";
		}
		
		else {
			//return this.goal_reached.arc_to_predecessor.toString();
			return this.goal_reached.get_solution_as_string();
		}	
	}
}

