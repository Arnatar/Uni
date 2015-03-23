package ca_puzzle;

import java.util.ArrayList;
import java.util.List;

public class Unique implements InterfaceUnique {

	List<Object> domain;
	List<Object> possibles;
	final char representation;
	int value;

	public Unique(char c) {
		representation = c;
		domain = new ArrayList<>();
		for (int i = 0; i < 10; i++) {
			domain.add(i);
		}
		possibles = new ArrayList<>();
		possibles.addAll(domain);
		value = -1;
	}

	@Override
	public void removeDomainElement(Object obj) {
		domain.remove(obj);
		possibles.clear();
		possibles.addAll(domain);
	}
	
	@Override
	public List<Object> getPossibles() {
		return possibles;
	}
	
	@Override
	public void resetPossibles() {
		possibles.clear();
		possibles.addAll(domain);
	}
	
	@Override
	public boolean SetValue(int val) {
		if (domain.contains(val) || val == -1) {
			value = val;
			return true;
		}
		return false;
	}

	@Override
	public int GetValue() {
		return value;
	}

	@Override
	public char getRepresentation() {
		return representation;
	}

	@Override
	public List<Object> getDomain() {
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
