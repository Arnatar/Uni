import java.util.*;


public class Main {

	/**
	 * Main-Methode mithilfe der man das Jugs-Riddle loest. 
	 * TODO: Ini File parsen. In der sollte dann die Spezifikation des Problems (goal, capacities, spill-allowed..) mit Properties + spill option einbauen.
	 */
	public static void main(String[] args) {
	        Properties p = new Properties();
		HashSet<State> goals = new HashSet<>();
		goals.add(new State(0,2,3,4,null,Arc.FILL_JUG_ONE));
		Riddle_Solver riddle  = new  Riddle_Solver(3, 4,goals , true, true);
		System.out.print(riddle.solve());
		
	}

}
