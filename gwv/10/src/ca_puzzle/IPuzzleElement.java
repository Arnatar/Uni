package ca_puzzle;

import java.util.Set;

public interface IPuzzleElement {

	
	public Set<Integer> getDomain();

	public void setDomain(Set<Integer> domain);
	
	char getRepresentation();
	
	
}
