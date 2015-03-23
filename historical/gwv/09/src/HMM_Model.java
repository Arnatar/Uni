import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.util.HashMap;
/*
 * Für das PoS-Tagger System:
 *  Hidden States: Tags
 *  Observed States: Words
 * Wobei die Wahrscheinlichkeit vom i-tem Wort von der der Wahrscheinlichkeit von dem i-tem
 * Tag, welches allein von dem i-1-tem Tag abhängt. 
 * Wir benötigen also die Übergangswahrscheinlichkeiten für die Tags P(Ti|Ti-1)
 * Außerdem benötigen wir die Emissionswahrscheinlichkeiten (Wi|Ti)
 * Beides wird in dem PosTag-gespeichert.
 */

public class HMM_Model {
	final  File file;
        // Mapping zwischen String im File und PosTag Objekt 
	HashMap<String,PosTag> tags =  new HashMap<String, PosTag>();
   
	public HMM_Model(String filepath) throws IOException{
		this.file = new File(filepath);
		
	}
        // Aus den Trainingsdaten die Wahrscheinlichkeiten berechenen
	public void analyize_file(){
		 BufferedReader br;
		try {
			br = new BufferedReader(new FileReader(file));
			String line;
			PosTag previous_tag = null;
	        while((line = br.readLine()) != null) {
	            String splitted[] = line.split("\\t");
	            // ggf. Leerzeilen übersrpingen
	            if (splitted.length >= 2){
	            	// Splitte an TAB
	            	String word  = splitted[0];
	            	String tag =  splitted[1];
	            	PosTag current_tag = tags.get(tag);
	            	
	            	if (current_tag == null){
	            		// Tag zur Map hinzufügen, fall das erste mal aufgetaucht.
	            		current_tag = new PosTag(tag);
	            		tags.put(tag, current_tag);
	            	}
			// Für die Berechnung der Emissionswahrscheinlichkeiten
	            	current_tag.inc_count_words(word);
	            	//  Spezialfall erste Zeile kein previous_tag beachten
	            	if (previous_tag != null){
			        // Für die Übergangswahrscheinlichkeiten 
	            		previous_tag.inc_count_transition(current_tag);
	            	}
	            	previous_tag = current_tag;
	            }
	        }
		//  Wahrscheinlichkeiten anhand der relativen Häufigkeit berechnen 
	        normalize_probs();
	        
	    } 
		catch ( IOException e) {
			e.printStackTrace();
			}
		}
        // Für alle Tags die Wahrscheinlichkeiten berechnen	
	public void normalize_probs(){
		for (PosTag tag : tags.values()){
			tag.normalize_probabilities();
			// System.out.println(tag.toString() + tag.word_probs);
		}
		
	}
}
