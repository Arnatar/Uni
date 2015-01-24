package ca_puzzle;

import java.util.List;

public interface InterfaceUnique {
	
	public char getRepresentation();

	public List<Object> getDomain();
	
	public boolean SetValue(int val);
	
	public int GetValue();
	
	public List<Object> getPossibles();
	
	public void resetPossibles();
	
	public void removeDomainElement(Object obj);

}
