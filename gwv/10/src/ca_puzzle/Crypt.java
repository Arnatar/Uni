package ca_puzzle;

import java.util.ArrayList;
import java.util.HashSet;

public class Crypt {

	IPuzzleElement[][] model;
	ArrayList<Unique> uniques;
	int puzzle_height;
	int puzzle_length;
	int longest_summand_length;

	public Crypt(String input) {
		// building better input
		input = input.toUpperCase();
		input = input.replaceAll("\\s", "");
		uniques = new ArrayList<Unique>();
		init(input);
		preprocess();
	}

	private void init(String input) {
		// split input at + and =
		String[] splited = input.split("\\+|=");
		// länge des längste Summandenwortes ermitteln 
		compute_longest_summand(splited);
		// find max kg: Kann man nicht einfach die länge des Ergebniswort betrachten?
		int maxlength = 0;
		for (String e : splited) {
			if (e.length() > maxlength) {
				maxlength = e.length();
			}
		}
		String result = splited [splited.length -1];
		// length +1 um überträge in der letzten Zeile Speichern zu können.
		model = new IPuzzleElement[splited.length +1][maxlength];
		puzzle_length = maxlength;
		puzzle_height = splited.length +1;
		// fill model + uniques
		// Summanden
		for (int n = 0; n < splited.length-1; n++) {
			char[] tempArray = splited[n].toCharArray();
			for (int i = tempArray.length - 1; i >= 0; i--) {
				Unique testcase = new Unique(tempArray[i]);
				if (uniques.contains(testcase)) {
					model[n][maxlength - tempArray.length + i] = uniques.get(uniques
							.indexOf(testcase));
				} else {
					uniques.add(testcase);
					model[n][maxlength - tempArray.length + i] = uniques.get(uniques
							.indexOf(testcase));
				}
			}
		}
		// Uebertraege eintragen
		int carryID = 0;
		for (int j = model[0].length - 2; j > -1; j--) {
			model[splited.length-1 ][j] = new Carry(carryID); 
			carryID++;
		}
	
		// Ergebnis Wort eintragen
		char[] ergebnisArray = result.toCharArray();
		int lastRow = splited.length;
		for (int c = 0 ; c < ergebnisArray.length;c++){
			Unique testcase = new Unique(ergebnisArray[c]);
			if (uniques.contains(testcase)) {
				model[lastRow][c] = uniques.get(uniques
						.indexOf(testcase));
			} else {
				uniques.add(testcase);
				model[lastRow][c] = uniques.get(uniques
						.indexOf(testcase));
			
			}
		}
	}
	private void compute_longest_summand(String[] splited) {
		int r = 0;
		for (int i =0; i < splited.length-1; i++){
			r = Math.max(r,splited[i].length());
		}
		longest_summand_length = r;
		return;
	}

	/*
	 * Do some preprocessing like:
	 *  -  restricting the domains of the carries 
	 *  -  restricting the domain of first char of result if its longer than the others
	 * 
	 */
	public void preprocess(){
		// Uebertraege, sind gleich Hoehe - 3, wegen Uebertragzeile, Ergebniszeile und maximalem Ergebis der Addition  
		int max_carry = puzzle_height - 3;
		HashSet<Integer> domain = build_domain(max_carry);
		set_max_carry_domain(domain);
		// Wenn dass ergebniswort länger, als andere, dann hat das auch die gleiche Domain
		if (longest_summand_length < puzzle_length){
			System.out.println("Ya");
			model[puzzle_height-1][0].setDomain(domain);
			System.out.println(model[puzzle_height-1][0].getRepresentation());
		}
	}
	
	public void set_max_carry_domain(HashSet<Integer> domain){
		for(int i = 0; i < puzzle_length;i++){
			IPuzzleElement e = model[puzzle_height -2][i];
			if (e ==  null){
				continue;
			}
			else {
				e.setDomain(domain);
			}
		}
	}
	
	private HashSet<Integer> build_domain(int max) {
		HashSet<Integer> result =  new HashSet<Integer>();
		for (int i = 0; i <=max; i++){
			result.add(i);
		}
		return result;
		
	}

	public void printDebug() {
		System.out.println("Uniques:");
		for (Unique e : uniques) {
			System.out.print("" + e.getRepresentation() + ", ");
		}
		System.out.println("\n");
		System.out.println("Model:");
		for (int n = 0; n < model.length - 1; n++) {
			if(n != model.length - 2) {
				System.out.print("  ");
			} else {
				System.out.print("+ ");
			}
			for (int i = 0; i < model[0].length; i++) {
				if (model[n][i] == null) {
					System.out.print(" ");
				} else {
					System.out.print(model[n][i].getRepresentation());
				}
			}
			System.out.println();
		}
		for(int i = 0; i < model[0].length + 2; i++) {
			System.out.print("-");
		}
		System.out.println();
		System.out.print("  ");
		for(int i = 0; i < model[0].length; i++) {
			if (model[model.length - 1][i] == null) {
				System.out.print(" ");
			} else {
				System.out.print(model[model.length - 1][i].getRepresentation());
			}
		}
		System.out.println("\n");
	}

}
