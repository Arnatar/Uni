package search;
import java.util.Comparator;
public class StateComperator implements Comparator<State> {
	private final Field field;
	
	public StateComperator(Field field) {
		this.field = field;
		
	}
	
	@Override
	public int compare(State o1, State o2) {
		int o1_mannhattan_distance_to_goal = field.compute_manhattan_distance(o1);  
		int o2_mannhattan_distance_to_goal = field.compute_manhattan_distance(o2);
		int o1_pathlength_to_start = o1.get_path_length_to_goal();
		int o2_pathlength_to_start = o2.get_path_length_to_goal();
		
		int added_value_o1 = o1_mannhattan_distance_to_goal + o1_pathlength_to_start;
		int added_value_o2 = o2_mannhattan_distance_to_goal + o2_pathlength_to_start;
		// Wenn added_value von o2 größer als der von o1 ist, dann ist o1 übergeordnet, da der geschätze Restpfad kürzer ist. 
		return added_value_o2 - added_value_o1;
	}
	
}
