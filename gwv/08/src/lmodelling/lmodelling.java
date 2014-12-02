package lmodelling;

import java.io.IOException;

public class lmodelling {
	
	private static final String _file_path = "data/text.txt";
	//private static final String _file_path = "data/heiseticker-text.txt";
	
	public static void main(String[] args) throws IOException {
		markov chains = new markov(_file_path);
		chains.print_base();
	}
	
}
