package ca_puzzle;

import java.util.ArrayList;
import java.util.List;

public class Crypt {

	InterfaceUnique[][] model;
	ArrayList<Unique> uniques;

	public Crypt(String input) {
		// building better input
		input = input.toUpperCase();
		input = input.replaceAll("\\s", "");
		uniques = new ArrayList<Unique>();
		init(input);
		prune();
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

		model = new InterfaceUnique[splited.length + 1][maxlength];
		// fill model + uniques
		for (int n = 0; n < splited.length; n++) {
			char[] tempArray = splited[n].toCharArray();
			for (int i = tempArray.length - 1; i >= 0; i--) {
				Unique testcase = new Unique(tempArray[i]);
				if (!uniques.contains(testcase)) {
					uniques.add(testcase);
				}
				model[n][maxlength - tempArray.length + i] = uniques.get(uniques
						.indexOf(testcase));
			}
		}

		// building carries
		int cId = model[0].length - 1;
		for (int i = 1; i < model[0].length; i++) {
			int maxCarry = 0;
			for (int n = 0; n < model.length - 2; n++) {
				if (model[n][i] != null) {
					maxCarry++;
				}
			}
			int maxSum = 0;
			for (int n = 0; n < maxCarry; n++) {
				maxSum += 9 - n;
			}
			maxCarry = maxSum / 10;
			model[model.length - 1][i - 1] = new Carry(cId, maxCarry);
			cId--;
		}
		model[model.length - 1][model[0].length - 1] = new Carry(0, 0);
		model[model.length - 1][model[0].length - 1].SetValue(0);
	}

	// a stub, TODO enlarge pruning
	private void prune() {
		int firstColumnCount = 0;
		for (int n = 0; n < model.length - 2; n++) {
			if (model[n][0] != null) {
				firstColumnCount++;
			}
		}
		if (firstColumnCount == 0) {
			model[model.length - 2][0].removeDomainElement(0);
		}
	}

	// Wrapper for solve-function
	public void solve() {
		if (solve(model[0].length - 1, 0))
			System.out.println("yeah");
		else
			System.out.println("oh no");
	}

	private boolean solve(int column, int row) {
		if (column < 0 || row > model.length - 1) {
			return false;
		} else {
			if (model[model.length - 2][0].GetValue() != -1) {
				return true;
			} else {
				while (solutionCheck()) {
					if (model[row][column] != null) {
						for (Object value : model[row][column].getDomain()) {
							if (!model[row][column].getPossibles().contains(value))
								continue;
							if (setValue((int) value, model[row][column])) {
								if (row < model.length - 2) {
									if (solve(column, ++row)) {
										return true;
									} else {
										if (model[row][column].getPossibles().size() > 1) {
											resetValue((int) value, model[row][column]);
										} else {
											return false;
										}
									}
								} else {
									if (constraintCheck(column)) {
										int sum = 0;
										for (int n = 0; n < model.length - 2; n++) {
											if (model[n][column] != null) {
												sum += model[n][column].GetValue();
											}
										}
										model[model.length - 1][column - 1].SetValue((int) Math
												.floor(sum / 10.0));
										if (solve(--column, 0)) {
											return true;
										} else {
											if (model[row][column].getPossibles().size() > 1) {
												resetValue((int) value, model[row][column]);
											} else {
												return false;
											}
										}
									} 
									
								}
							}
						}
						return false;
					} else {
						if (row < model.length - 2) {
							solve(column, ++row);
						} else {
							solve(--column, 0);
						}
					}
				}
				return false;
			}
		}
	}

	private boolean constraintCheck(int column) {
		boolean result = false;
		int sum = 0;
		for (int n = 0; n < model.length - 2; n++) {
			if (model[n][column] != null) {
				sum += model[n][column].GetValue();
			}
		}
		sum += model[model.length - 1][column].GetValue();
		int res = model[model.length - 2][column].GetValue();
		if (res == sum % 10) {
			result = true;
		}
		return result;
	}

	private boolean setValue(int value, InterfaceUnique self) {
		if (self.GetValue() == -1 && self.SetValue(value)) {
			for (Unique unique : uniques) {
				if (!unique.equals(self)) {
					unique.getPossibles().remove((Object) value);
				}
			}
			return true;
		}
		return false;
	}

	private void resetValue(int value, InterfaceUnique self) {
		self.SetValue(value);
		for (Unique unique : uniques) {
			if (unique.equals(self)) {
				unique.getPossibles().add((Object) value);
			}
		}
	}

	private boolean solutionCheck() {
		boolean result = false;
		for (Unique unique : uniques) {
			if (unique.getPossibles().size() > 1)
				result = true;
		}
		return result;
	}

	public void printResult() {
		for (int n = 0; n < model.length - 2; n++) {
			System.out.print("  ");
			for (int i = 0; i < model[0].length; i++) {
				if (model[n][i] == null) {
					System.out.print(" ");
				} else {
					System.out.print(model[n][i].GetValue());
				}
			}
			System.out.println();
		}
		System.out.print("+ ");
		for (int i = 0; i < model[0].length; i++) {
			if (model[model.length - 1][i] == null) {
				System.out.print(" ");
			} else {
				System.out.print(model[model.length - 1][i].GetValue());
			}
		}
		System.out.println();

		for (int i = 0; i < model[0].length + 2; i++) {
			System.out.print("-");
		}
		System.out.println();
		System.out.print("  ");
		for (int i = 0; i < model[0].length; i++) {
			if (model[model.length - 2][i] == null) {
				System.out.print(" ");
			} else {
				System.out.print(model[model.length - 2][i].GetValue());
			}
		}
		System.out.println("\n");
	}

	public void printDebug() {
		System.out.println("Uniques:");
		for (Unique e : uniques) {
			System.out.print("" + e.getRepresentation() + ", ");
		}
		System.out.println("\n");
		System.out.println("Model:");
		for (int n = 0; n < model.length - 2; n++) {
			System.out.print("  ");
			for (int i = 0; i < model[0].length; i++) {
				if (model[n][i] == null) {
					System.out.print(" ");
				} else {
					System.out.print(model[n][i].getRepresentation());
				}
			}
			System.out.println();
		}
		System.out.print("+ ");
		for (int i = 0; i < model[0].length; i++) {
			if (model[model.length - 1][i] == null) {
				System.out.print(" ");
			} else {
				System.out.print(model[model.length - 1][i].getRepresentation());
			}
		}
		System.out.println();

		for (int i = 0; i < model[0].length + 2; i++) {
			System.out.print("-");
		}
		System.out.println();
		System.out.print("  ");
		for (int i = 0; i < model[0].length; i++) {
			if (model[model.length - 2][i] == null) {
				System.out.print(" ");
			} else {
				System.out.print(model[model.length - 2][i].getRepresentation());
			}
		}
		System.out.println("\n");
	}

}
