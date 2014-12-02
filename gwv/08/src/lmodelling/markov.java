package lmodelling;

import java.io.FileReader;
import java.io.IOException;
import java.util.Enumeration;
import java.util.Hashtable;

public class markov {

	private Hashtable<String, word> _modell;

	public markov(String file_path) throws IOException {
		_modell = buildt_markov_chain(file_path);
		buildt_probs();
	}

	private Hashtable<String, word> buildt_markov_chain(String file_path)
			throws IOException {
		FileReader inStream = null;
		Hashtable<String, word> result = new Hashtable<String, word>();

		try {
			inStream = new FileReader(file_path);
			int c = 0;
			int count = 0;
			String wordBuff = "";
			String pred = "";

			while ((c = inStream.read()) != -1) {
				if (c != (int) '\n') {
					wordBuff = wordBuff + (char) c;
				} else {
					boolean contains = false;
					word e = result.get(wordBuff);
					if (e != null && !wordBuff.equals("")) {
							e.incr_maxCount();
							contains = true;
					}
					if(result.get(pred) != null) {
						result.get(pred).add_connection(wordBuff);
					}
					if (!contains) {
						result.put(wordBuff, new word(wordBuff));
					}
					if (count % 1000 == 0 && lmodelling.showProgress) {
						System.out.println("" + count + " done");
					}
					pred = wordBuff;
					wordBuff = "";
					count++;
				}
			}
		} finally {
			if (inStream != null) {
				inStream.close();
			}
		}

		return result;
	}
	
	private void buildt_probs() {
		for(Enumeration<word> e = _modell.elements(); e.hasMoreElements();) {
			word el = e.nextElement();
			el.set_probs();
		}
	}
	
	public void print_chain(int length, String input) {
		if(length > 0) {
			length--;
			System.out.print(input + " ");
			String nextInput = _modell.get(input).evalNext();
			print_chain(length, nextInput);
		} else {
			System.out.println("\n");
		}
	}

	public void print_base() {
		for(Enumeration<word> e = _modell.elements(); e.hasMoreElements();) {
			e.nextElement().print_connected();
		}
	}

	public boolean contains(String input) {
		return _modell.containsKey(input);
	}

}
