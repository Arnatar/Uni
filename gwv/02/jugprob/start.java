import java.util.*;

public class start {
	private static ArrayList<node>	_nodes;
	private static graph						_search_graph;

	/*
	 * warum muss der graph nochmal alle zustände enthalten, sind doch eh nicht
	 * alle verbunden
	 */
	/**
	 * add all nodes in the node-list
	 */
	private static void buildt_nodes() {
		for (int f = 0; f <= node.get_fourMax(); f++) {
			for (int t = 0; t <= node.get_threeMax(); t++) {
				_nodes.add(new node(f, t));
			}
		}
	}

	// not sure if i got all of them
	/**
	 * checks if nodes have a connection
	 */
	private static boolean test_connection(node node1, node node2) {
		boolean ret = false;
		int f1 = node1.get_fourLitre();
		int t1 = node1.get_threeLitre();
		int f2 = node2.get_fourLitre();
		int t2 = node2.get_threeLitre();
		// to do nothing is possible
		if (f1 == f2 && t1 == t2)
			ret = true;
		// fill one jug from pump
		if (f2 == node.get_fourMax() && t1 == t2)
			ret = true;
		if (t2 == node.get_threeMax() && f1 == f2)
			ret = true;
		// empty one jug
		if (f1 != 0 && f2 == 0 && t1 == t2)
			ret = true;
		if (t1 != 0 && t2 == 0 && f1 == f2)
			ret = true;
		// one jug into the other and here is my problem atm
		// three to four jug
		int four_capacity = node.get_fourMax() - f1;
		if (four_capacity <= t1) {
			if (f2 == node.get_fourMax() && t2 == t1 - four_capacity)
				ret = true;
		} else if ((f2 == f1 + t1) && t2 == 0)
			ret = true;
		// four to three jug
		int three_capacity = node.get_threeMax() - t1;
		if(three_capacity <= f1) {
			if(t2 == node.get_threeMax() && f2 == f1 - three_capacity)
				ret = true;
		} else if ((t2 == t1 + f1) && f2 == 0)
			ret = true;
		return ret;
	}

	// gerade keinen Nerv zum optimieren, hier treten doppelte Überprüfungen auf.
	/**
	 * sets connections in the adjacence matrice if they are possible
	 */
	private static void buildt_connections() {
		node node1 = new node(0, 0);
		node node2 = new node(0, 0);
		for (int f1 = 0; f1 <= node.get_fourMax(); f1++) {
			for (int t1 = 0; t1 <= node.get_threeMax(); t1++) {
				node1.change_val(f1, t1);
				for (int f2 = 0; f2 <= node.get_fourMax(); f2++) {
					for (int t2 = 0; t2 <= node.get_threeMax(); t2++) {
						node2.change_val(f2, t2);
						if (test_connection(node1, node2)) {
							_search_graph.add_connection_mon(node1, node2);
						}
					}
				}
			}
		}
	}

	public static void main(String[] args) {
		_nodes = new ArrayList<node>();
		buildt_nodes();
		_search_graph = new graph(_nodes);
		buildt_connections();
		_search_graph.print_adj_list();

	}
}
