import java.io.IOException;


public class Main {

	public static void main(String[] args) {
		//String _filepath = "data/simple-taged-text.txt";
		String _filepath = "data/hdt-1-10000-train.tags";
		HMM_Model model =  null;
		try {
			model =new HMM_Model(_filepath);
		} catch (IOException e) {
			e.printStackTrace();
		}
		model.analyize_file();
	}

}
