package ca_puzzle;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;

public class Ca_puzzle {

	public static void main(String[] args) throws IOException {
		
		Crypt solver; 
		String input = "send+more=money";
		BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
		System.out.println("Enter String in Format word1+word2=word3:");
		//input = br.readLine();
		solver = new Crypt(input);
		solver.solve();
		solver.printResult();
		//solver.printDebug();
		
		/*
		while (!input.equals("exit")) {
			System.out.println("Enter String in Format word1+word2=word3:");
			input = br.readLine();
			if (input.equals("exit")) {
				break;
			}
			solver = new Crypt(input);
			solver.printDebug();
		} */
	}

}
