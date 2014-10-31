package search;

class State {
	private State predecessor;
	private Direction direction_to_start; 
	private coords coordinates;
	
	State (coords c, Direction to_root, State pred) {
		this.coordinates = c;
		this.direction_to_start = to_root;
		this.predecessor = pred;
	}
		
	public coords get_coords(){
		return this.coordinates;
	}
	
	public State get_predecessor(){
		return this.predecessor;
	}
	
	public Direction get_direction_to_start(){
		return this.direction_to_start;
	}
	
	/*
	 * A String which represents the path to start position by a Sequence of Directions.
	 */
	public String path_to_start_as_string() {
		Direction direction = this.get_direction_to_start();
		if (direction.equals(Direction.NONE)){
			return "The path: START"; 
		}
		else {
			return this.get_predecessor().path_to_start_as_string()+ " " + direction.toString()  ;
		}	
	}
	
	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result
				+ ((coordinates == null) ? 0 : coordinates.hashCode());
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
		if (coordinates == null) {
			if (other.coordinates != null)
				return false;
		} else if (!coordinates.equals(other.coordinates))
			return false;
		return true;
	}
}
