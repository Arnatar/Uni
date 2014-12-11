import java.util.HashMap;
import java.util.Map.Entry;
public class PosTag {

	String tagname = null;
	HashMap<PosTag, Float> transitions_probs = new HashMap<PosTag, Float>();
	HashMap<String, Float> word_probs = new HashMap<String, Float>();
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
			float count =transitions_probs.get(tag);
			// System.out.println("Before " + count);
			count = count + (float)1.0;
			// System.out.println("After " + count);
			transitions_probs.put(tag,count);
		}
		else {
			transitions_probs.put(tag,(float)(1.0));
		}
		
	}
	
	void inc_count_words(String word){
		number_words++;
		// System.out.println("In count for tag: "+ this.toString() + " Number_w: " + this.number_words);
		if (word_probs.containsKey(word)){
			float count = word_probs.get(word);
			count = count + (float)1;
			word_probs.put(word,count);
		}
		else {
			word_probs.put(word,(float)(1));
		}
		
	}
	
	String getTagname(){
		return this.tagname;
	}
	// Normalizes the probabilities for the given tags, i.e. prob of next tag and emission prob for word.  
	
	void normalize_probabilities(){
		// next tag probs
		for (Entry<PosTag, Float> entry : transitions_probs.entrySet()){
			float prob  = entry.getValue() / this.number_transitions; 
			transitions_probs.put(entry.getKey(), prob); 
		}
		// emissioned word probs
		for (Entry<String, Float> entry : word_probs.entrySet()){
			float prob  = entry.getValue() / this.number_words; 
			word_probs.put(entry.getKey(), prob); 
			// System.out.println("Prob für " + key + " " +prob );
		}
		float test = 0; 
		for (Entry<String, Float> entry : word_probs.entrySet()){
			float prob  =entry.getValue(); 
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
