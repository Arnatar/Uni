import java.util.HashMap;
import java.util.Map.Entry;
public class PosTag {
        // Tagname
	String tagname = null;
        // Übergangswahrscheinlichkeitsmap 
	HashMap<PosTag, Double> transitions_probs = new HashMap<PosTag, Double>();
        // Emissionswahrscheinlichkeitsmap
	HashMap<String, Double> word_probs = new HashMap<String, Double>();
        // Counter dienen dann als Divisor um die relativen Häufigkeiten zu berechnen
	int number_words = 0;
	int number_transitions  = 0;

	public PosTag(String tagstring) {
		this.tagname = tagstring;
	}

	// Inkrement count for Tag
	void inc_count_transition(PosTag tag){
		number_transitions++;
		// System.out.println("In count for tag: "+ this.toString() + " Number_t: " + this.number_transitions);
		if (transitions_probs.containsKey(tag)){
			Double count =transitions_probs.get(tag);
			count = count + (Double)1.0;
			transitions_probs.put(tag,count);
		}
		else {
			transitions_probs.put(tag,(Double)(1.0));
		}
		
	}
	
	void inc_count_words(String word){
		number_words++;
		if (word_probs.containsKey(word)){
			Double count = word_probs.get(word);
			count = count + (double)1;
			word_probs.put(word,count);
		}
		else {
			word_probs.put(word,(double)(1));
		}
		
	}
	
	String getTagname(){
		return this.tagname;
	}
	// Normalizes the probabilities for the given tags, i.e. prob of next tag and emission prob for word.  
	void normalize_probabilities(){
		// next tag probs
		for (Entry<PosTag, Double> entry : transitions_probs.entrySet()){
			Double prob  = entry.getValue() / this.number_transitions; 
			transitions_probs.put(entry.getKey(), prob); 
		}
		// emissioned word probs
		for (Entry<String, Double> entry : word_probs.entrySet()){
			Double prob  = entry.getValue() / this.number_words; 
			word_probs.put(entry.getKey(), prob); 
		}
		// Nur zur Ausgabe der berechneten Wahrscheinlichkeiten und ob diese Sinn machen (Hätte man auch gleich in der obigen Schleife berechnen können) 
		double test = 0; 
		for (Entry<String, Double> entry : word_probs.entrySet()){
			double prob  = entry.getValue(); 
			word_probs.put(entry.getKey(), prob);
			test = test + word_probs.get(entry.getKey()); 
		}
		System.out.println("For Tag " + this.toString() + " Testvalue: " + test);
//		System.out.println(this.number_words);
//		System.out.println(this.toString() + " Probs " + this.word_probs);
		
		
	}

	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + ((tagname == null) ? 0 : tagname.hashCode());
		return result;
	}

	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		PosTag other = (PosTag) obj;
		if (tagname == null) {
			if (other.tagname != null)
				return false;
		} else if (!tagname.equals(other.tagname))
			return false;
		return true;
	}

	@Override
	public String toString() {
		return "PosTag:" + tagname;
	}
	
	
}
