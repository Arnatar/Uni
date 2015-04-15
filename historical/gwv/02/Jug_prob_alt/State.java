import java.util.ArrayList;


public class State {
	
	final int jug_1_filling;
	final int jug_2_filling;
	boolean is_goal;
	int jug_1_capacity;
	int jug_2_capacity;
	// Noch den Vorgänger zum Startknoten und den Kantennamen zum Vorgänger
	State predecessor_to_root;
	Arc arc_to_predecessor;
	
	public State(int cap_1, int cap_2){
		this.jug_1_filling = 0;
		this.jug_2_filling = 0;
		this.jug_1_capacity = cap_1;
		this.jug_2_capacity = cap_2;
		this.predecessor_to_root = null;
		this.arc_to_predecessor = Arc.NONE;
	}
	
	public State(int fill_1, int fill_2, int cap_1, int cap_2, State to_root, Arc arc) {	
		this.jug_1_filling = fill_1;
		this.jug_2_filling = fill_2;
		this.jug_1_capacity = cap_1;
		this.jug_2_capacity = cap_2;
		this.predecessor_to_root = to_root;
		this.arc_to_predecessor = arc;
	}
	
	// Hier dann die moeglichen Transitionen
	// Refactor
	public State fill(int jugnumber){
		if (jugnumber == 1){
			int filling_1 = this.jug_1_capacity; 
			return new State(filling_1,this.jug_2_filling, this.jug_1_capacity,  this.jug_2_capacity, this, Arc.FILL_JUG_ONE) ;
		}
		else{
			int filling_two = this.jug_2_capacity; 
			return new State(this.jug_1_filling,filling_two,this.jug_1_capacity, this.jug_2_capacity, this, Arc.FILL_JUG_TWO); 
		}		
	}
	
	public State spill(int jugnumber){
		if (jugnumber == 1){
			return new State(0, this.jug_2_filling, this.jug_1_capacity,this.jug_2_capacity, this, Arc.SPILL_JUG_ONE) ;
		}
		else{
			return new State(this.jug_1_filling, 0,this.jug_1_capacity, this.jug_2_capacity, this, Arc.SPILL_JUG_TWO) ;
		}
	}
	// Refactor mit nur einer Methode
	public State decant(int from, int to){
		// Eins in zwei umfüllen
		if (from == 1 && to == 2){
			// 2 zu voll
			if (this.jug_1_filling + this.jug_2_filling > this.jug_2_capacity){
				int filling2 = this.jug_2_capacity;
				int filling1 = this.jug_1_filling - (this.jug_2_capacity - this.jug_2_filling);
				return new State(filling1,filling2,this.jug_1_capacity,this.jug_2_capacity,this,Arc.FILL_TWO_WITH_ONE);
			}
			else{
				int filling1 = 0;
				int filling2 = this.jug_1_filling + this.jug_2_filling;
				return new State(filling1,filling2,this.jug_1_capacity,this.jug_2_capacity,this,Arc.FILL_TWO_WITH_ONE);
			}
		}
		// Zwei in Eins
		if (from == 2 && to == 1){
			// 2 zu voll
			if (this.jug_1_filling + this.jug_2_filling > this.jug_1_capacity){
				int filling1 = this.jug_1_capacity;
				int filling2 = this.jug_2_filling - (this.jug_1_capacity - this.jug_1_filling);
				return new State(filling1,filling2,this.jug_1_capacity,this.jug_2_capacity,this,Arc.FILL_ONE_WITH_TWO);
			}
			else{
				int filling2 = 0;
				int filling1 = this.jug_1_filling + this.jug_2_filling;
				return new State(filling1,filling2,this.jug_1_capacity,this.jug_2_capacity,this,Arc.FILL_ONE_WITH_TWO);
			}
		}
		System.out.print("Fehler in decant. Invalid arguments.");
		return null;
	}
	
	
// Hier die Nachbarn implementierten 
	public ArrayList<State> explore_neighbours() {
		ArrayList<State> neighbours = new ArrayList<State>();
		// Spezialfall ohne spill
		neighbours.add(this.spill(1));
		neighbours.add(this.spill(2));
		neighbours.add(this.fill(1));
		neighbours.add(this.fill(2));
		neighbours.add(this.decant(1, 2));
		neighbours.add(this.decant(2,1));	
		return neighbours;
	}

	public Arc get_Arc_to_root(){
		return this.arc_to_predecessor;
	}
	// solution mit Rekursion
	public String get_solution_as_string() {
		Arc arc = this.get_Arc_to_root();
		if (arc.equals(Arc.NONE)){
			return ""; 
		}
		else {
			return this.predecessor_to_root.get_solution_as_string() + " " + arc.toString() ;
		}
		
		
		
		
		//if (this.get_Arc_to_root().equals(Arc.NONE)){
		//	return "Start";
		//}
		//else {
		//	return to_return += this.predecessor_to_root.get_Arc_to_root().toString();
		//}
		
	}
	

	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + jug_1_capacity;
		result = prime * result + jug_1_filling;
		result = prime * result + jug_2_capacity;
		result = prime * result + jug_2_filling;
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
		if (jug_1_capacity != other.jug_1_capacity)
			return false;
		if (jug_1_filling != other.jug_1_filling)
			return false;
		if (jug_2_capacity != other.jug_2_capacity)
			return false;
		if (jug_2_filling != other.jug_2_filling)
			return false;
		return true;
	}

	@Override
	public String toString() {
		return "State [jug_1_filling=" + jug_1_filling + ", jug_2_filling="
				+ jug_2_filling + ", is_goal=" + is_goal + ", jug_1_capacity="
				+ jug_1_capacity + ", jug_2_capacity=" + jug_2_capacity
				+ ", predecessor_to_root=" + predecessor_to_root
				+ ", arc_to_predecessor=" + arc_to_predecessor + "]";
	}
	

}
