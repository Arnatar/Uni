package ca_puzzle;

import java.util.HashSet;
import java.util.Set;

public class Carry implements IPuzzleElement {

		Set<Integer> domain;
		//  Identifies the Carry by its index 
		int id;
		
		
		Carry(int id) {
			this.id = id;
		}
		
		public void add_to_domain(int to_add){
			domain.add(to_add);

		}

		public Set<Integer> getDomain() {
			return domain;
		}

		public void setDomain(Set<Integer> domain) {
			this.domain = domain;
		}

		public int getId() {
			return id;
		}
		
		// Nicht so toll, dadurch nur 0-9 vernünftig darstellbar. Also keine langen Wörterrätsel :)
		public char getRepresentation(){
			return Integer.toString(id).charAt(0); 
			
		}
	
}
