package ca_puzzle;

import java.util.HashSet;
import java.util.Set;

public class Unique {
	
	Set<Object> domain;
	final char representation;
	
	
	public Unique (char c) {
		representation = c;
		domain = new HashSet<>();
		domain.add(0);
		domain.add(1);
		domain.add(2);
		domain.add(3);
		domain.add(4);
		domain.add(5);
		domain.add(6);
		domain.add(7);
		domain.add(8);
		domain.add(9);
	}
	
	public char getRepresentation() {
		return representation;
	}
	
	public Set<Object> getDomain() {
		return domain;
	}
	
	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		Unique other = (Unique) obj;
		if (representation != other.getRepresentation())
			return false;
		return true;
	}
}
