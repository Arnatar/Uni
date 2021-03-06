package lmodelling;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;

public class lmodelling {

	private static final int maxLength = 15;
	private static final int minLength = 5;
	static final boolean showProgress = true;
	private static final boolean showBase = false;

	// private static final String _file_path = "data/text.txt";
	private static final String _file_path = "data/heiseticker-text.txt";

	public static void main(String[] args) throws IOException {
		// load file
		long startTime = System.currentTimeMillis();
		if(!showProgress) {
			System.out.println("Loading in Progress.");
		}
		markov chains = new markov(_file_path);
		if (showBase) {
			chains.print_base();
		}
		
		long endtime = System.currentTimeMillis();
		double time = ((double) (endtime - startTime)) / 1000;
		System.out.println("Loading in " + time + "s done \n");

		// user-interaction, exit finishes prog
		String input = "";
		BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
		while (!input.equals("exit")) {
			System.out.println("Enter String:");
			input = br.readLine();
			if (input.equals("exit")) {
				break;
			}
			System.out.println();
			int length = (int) (Math.random() * (maxLength - minLength)) + minLength;
			if (chains.contains(input)) {
				System.out.println("Kette mit Startwort " + input + " und Länge "
						+ length + ":");
				chains.print_chain(length, input);
			} else {
				System.out.println("Unbekannter Input.");
			}
		}
	}

}
