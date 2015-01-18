package ca_puzzle;

import java.util.ArrayList;

public class Crypt {

	Unique[][] model;
	ArrayList<Unique> uniques;

	public Crypt(String input) {
		// building better input
		input = input.toUpperCase();
		input = input.replaceAll("\\s", "");
		uniques = new ArrayList<Unique>();
		init(input);
	}

	private void init(String input) {
		// split input at + and =
		String[] splited = input.split("\\+|=");
		// find max
		int maxlength = 0;
		for (String e : splited) {
			if (e.length() > maxlength) {
				maxlength = e.length();
			}
		}

		model = new Unique[splited.length][maxlength];
		// fill model + uniques
		for (int n = 0; n < splited.length; n++) {
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
