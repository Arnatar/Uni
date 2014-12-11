import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.util.HashMap;
/*
 * Für das PoS-Tagger System:
 * 	Hidden States: Tags
 *  Observed States: Words
 * Wobei die Wahrscheinlichkeit vom i-tem Wort von der der Wahrscheinlichkeit von dem i-tem
 * Tag, welches allein von dem i-1-tem Tag abhängt. 
 * Wir benötigen also die Übergangswahrscheinlichkeiten für die Tags P(Ti|Ti-1)
 * Außerdem benötigen wir die Emissionswahrscheinlichkeiten (Wi|Ti)
 *  
 */

public class HMM_Model {
	final  File file;
	HashMap<String,PosTag> tags =  new HashMap<String, PosTag>();
	
	public HMM_Model(String filepath) throws IOException{
		this.file = new File(filepath);
		
	}
	
	public void analyize_file(){
		 BufferedReader br;
		try {
			br = new BufferedReader(new FileReader(file));
			String line;
			PosTag previous_tag = null;
	        while((line = br.readLine()) != null) {
	            String splitted[] = line.split("\\t");
	            // Leerzeilen übersrpingen
	            if (splitted.length >= 2){
	            	// Splitte an TAB
	            	String word  = splitted[0];
	            	String tag =  splitted[1];
	            	// System.out.println("Word: " + word + " Tag: " + tag ) ;
	            	PosTag current_tag = tags.get(tag);
	            	
	            	if (current_tag == null){
	            		// Tag zur Map hinzufügen, fall das erste mal aufgetaucht.
	            		current_tag = new PosTag(tag);
	            		tags.put(tag, current_tag);
	            		//System.out.println("Neu hinzugefügt: " + current_tag.getTagname());
	            	}
	            	current_tag.inc_count_words(word);
	            	//  Spezialfall erste Zeile kein previous_tag beachten
	            	if (previous_tag != null){
	            		previous_tag.inc_count_transition(current_tag);
	            		//System.out.println("Transitions: " + transitions);
	            	}
	            	// count emission
	            	previous_tag = current_tag;
	            }
	        }
	        normalize_probs();
	        
	    } 
		catch ( IOException e) {
			e.printStackTrace();
			}
		}
		
	public void normalize_probs(){
		for (PosTag tag : tags.values()){
			tag.normalize_probabilities();
			// System.out.println(tag.toString() + tag.word_probs);
		}
		
	}
}
