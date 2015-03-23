package jugprob;

import java.util.*;

public class start {
	private static ArrayList<node>	_nodes;
	private static graph						_search_graph;
	private static final int				_target_amount		= 2;
	private static final boolean		_long_output			= true;
	private static final boolean		_print_adj_matrix	= false;
	private static final boolean		_wasting_allowed	= true;

	public static void main(String[] args) {
		// Graph construction
		_nodes = new ArrayList<node>();
		buildt_nodes();
		_search_graph = new graph(_nodes);
		buildt_connections();

		// show adjacent matrix
		if (_print_adj_matrix) {
			_search_graph.print_adj_matrix();
			System.out.println("\n");
		}

		// evaluate result path
		node source = new node(0, 0);
		ArrayList<ArrayList<node>> set = new ArrayList<ArrayList<node>>();
		// built a set over possible solutions
		for (int n = 0; n <= node.get_smaller_max(); n++) {
			node target = new node(_target_amount, n);
			ArrayList<node> state_sequence = _search_graph.run_bfs(source, target);
			if (!state_sequence.isEmpty()) {
				set.add(state_sequence);
			}
		}

		if (!set.isEmpty()) {
			// find one of the shortest ones
			int shortest_index = 0;
			for (int i = 0; i < set.size(); i++) {
				if (set.get(i).size() <= set.get(shortest_index).size()) {
					shortest_index = i;
				}
			}

			// delete the rest
			for (int i = 0; i < set.size(); i++) {
				if (set.get(shortest_index).size() < set.get(i).size()) {
					set.remove(i);
				}
			}

			// print the shortest one(s)
			if (!_long_output) {
				System.out.println("states between source and target: ");
				for (int n = 0; n < set.size(); n++) {
					for (int i = 0; i < set.get(n).size(); i++) {
						set.get(n).get(i).print_node();
					}
					System.out.println();
				}
			} else {
				System.out
						.println("states and transitions between source and target: ");
				for (int n = 0; n < set.size(); n++) {
					for (int i = 0; i < set.get(n).size() - 1; i++) {
						set.get(n).get(i).print_node();
						print_transition(set.get(n).get(i), set.get(n).get(i + 1));
					}
					set.get(n).get(set.get(n).size() - 1).print_node();
					System.out.println();
				}
			}
		} else {
			System.out
					.println("no connection found between source and target => impossible to solve");
		}
	}

	private static void print_transition(node node1, node node2) {
		String result = "";
		int b1 = node1.get_bigger_jug();
		int s1 = node1.get_smaller_jug();
		int b2 = node2.get_bigger_jug();
		int s2 = node2.get_smaller_jug();
		// to do nothing is possible
		if (b1 == b2 && s1 == s2)
			result = result + "nothing";
		// fill one jug from pump
		if (b2 == node.get_bigger_max() && s1 == s2)
			result = "fill bigger from pump";
		if (s2 == node.get_smaller_max() && b1 == b2)
			result = "fill smaller from pump";
		// empty one jug
		if (b1 != 0 && b2 == 0 && s1 == s2)
			result = "empty bigger";
		if (s1 != 0 && s2 == 0 && b1 == b2)
			result = "empty smaller";
		// smaller to bigger jug
		int four_capacity = node.get_bigger_max() - b1;
		if (four_capacity <= s1) {
			if (b2 == node.get_bigger_max() && s2 == s1 - four_capacity)
				result = "fill smaller to bigger";
		} else if ((b2 == b1 + s1) && s2 == 0)
			result = "fill smaller to bigger";
		// bigger to smaller jug
		int three_capacity = node.get_smaller_max() - s1;
		if (three_capacity <= b1) {
			if (s2 == node.get_smaller_max() && b2 == b1 - three_capacity)
				result = "fill bigger to smaller";
		} else if ((s2 == s1 + b1) && b2 == 0)
			result = "fill bigger to smaller";
		System.out.print("-> " + result + " -> ");
	}

	/**
	 * add all nodes in the node-list
	 */
	private static void buildt_nodes() {
		for (int f = 0; f <= node.get_bigger_max(); f++) {
			for (int t = 0; t <= node.get_smaller_max(); t++) {
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
		int b1 = node1.get_bigger_jug();
		int s1 = node1.get_smaller_jug();
		int b2 = node2.get_bigger_jug();
		int s2 = node2.get_smaller_jug();
		// to do nothing is possible
		if (b1 == b2 && s1 == s2)
			ret = true;
		// fill one jug from pump
		if (b2 == node.get_bigger_max() && s1 == s2)
			ret = true;
		if (s2 == node.get_smaller_max() && b1 == b2)
			ret = true;
		// empty one jug
		if (_wasting_allowed) {
			if (b1 != 0 && b2 == 0 && s1 == s2)
				ret = true;
			if (s1 != 0 && s2 == 0 && b1 == b2)
				ret = true;
		}
		// smaller to bigger jug
		int four_capacity = node.get_bigger_max() - b1;
		if (four_capacity <= s1) {
			if (b2 == node.get_bigger_max() && s2 == s1 - four_capacity)
				ret = true;
		} else if ((b2 == b1 + s1) && s2 == 0)
			ret = true;
		// bigger to smaller jug
		int three_capacity = node.get_smaller_max() - s1;
		if (three_capacity <= b1) {
			if (s2 == node.get_smaller_max() && b2 == b1 - three_capacity)
				ret = true;
		} else if ((s2 == s1 + b1) && b2 == 0)
			ret = true;
		return ret;
	}

	/**
	 * sets connections in the adjacence matrice if they are possible
	 */
	private static void buildt_connections() {
		node node1 = new node(0, 0);
		node node2 = new node(0, 0);
		for (int f1 = 0; f1 <= node.get_bigger_max(); f1++) {
			for (int t1 = 0; t1 <= node.get_smaller_max(); t1++) {
				node1.change_val(f1, t1);
				for (int f2 = 0; f2 <= node.get_bigger_max(); f2++) {
					for (int t2 = 0; t2 <= node.get_smaller_max(); t2++) {
						node2.change_val(f2, t2);
						if (test_connection(node1, node2)) {
							_search_graph.add_connection_mon(node1, node2);
						}
					}
				}
			}
		}
	}
}
