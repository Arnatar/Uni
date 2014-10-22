import java.util.*;

/**
 * Simple graph class
 */
public class graph {
	private boolean[][]			_adj_list;
	private ArrayList<node>	_nodes;

	public graph(ArrayList<node> nodes) {
		int graphsize = nodes.size();
		_nodes = nodes;
		_adj_list = new boolean[graphsize][graphsize];
		for (int y = 0; y < graphsize; y++) {
			for (int x = 0; x < graphsize; x++) {
				_adj_list[y][x] = false;
			}
		}
	}

	private int find_index(node searched_node) {
		return _nodes.indexOf(searched_node);
	}

	/**
	 * adds monodirectional connection
	 */
	public void add_connection_mon(node source, node target) {
		int source_ind = find_index(source);
		int target_ind = find_index(target);
		_adj_list[source_ind][target_ind] = true;
	}

	/**
	 * adds bidirectional connection
	 */
	public void add_connection_bid(node node1, node node2) {
		int node1_ind = find_index(node1);
		int node2_ind = find_index(node2);
		_adj_list[node1_ind][node2_ind] = true;
		_adj_list[node2_ind][node1_ind] = true;
	}

	/**
	 * gives connection
	 */
	public boolean get_connection(node source, node target) {
		int source_ind = find_index(source);
		int target_ind = find_index(target);
		return _adj_list[source_ind][target_ind];
	}

	/**
	 * prints adjacent martix
	 */
	public void print_adj_list() {
		int graphsize = _nodes.size();
		System.out.print("     ");
		for (int n = 0; n < graphsize; n++) {
			System.out.print("(" + _nodes.get(n).get_fourLitre() + " "
					+ _nodes.get(n).get_threeLitre() + ") ");
		}
		System.out.println();
		for (int y = 0; y < graphsize; y++) {
			for (int x = 0; x < graphsize; x++) {
				boolean is_set = _adj_list[y][x];
				if (x == 0)
					System.out.print("(" + _nodes.get(y).get_fourLitre() + " "
							+ _nodes.get(y).get_threeLitre() + ")");
				if (is_set)
					System.out.print("  1  ");
				else
					System.out.print("  0  ");
				System.out.print(" ");
			}
			System.out.println("");
		}
	}

	public boolean contains(node testnode) {
		return _nodes.contains(testnode);
	}
}