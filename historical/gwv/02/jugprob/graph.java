package jugprob;

import java.util.*;

/**
 * Simple graph class works with an adjacent matrix and a list of all nodes both
 * use the same indice for the same node
 */
class graph {
	private boolean[][]			_adj_matrix;
	private ArrayList<node>	_nodes;

	graph(ArrayList<node> nodes) {
		int graphsize = nodes.size();
		_nodes = nodes;
		_adj_matrix = new boolean[graphsize][graphsize];
		for (int y = 0; y < graphsize; y++) {
			for (int x = 0; x < graphsize; x++) {
				_adj_matrix[y][x] = false;
			}
		}
	}

	/**
	 * adds monodirectional connection
	 */
	void add_connection_mon(node source, node target) {
		int source_ind = find_index(source);
		int target_ind = find_index(target);
		_adj_matrix[source_ind][target_ind] = true;
	}

	/**
	 * bfs-search for the target
	 */
	ArrayList<node> run_bfs(node source, node target) {
		// needed vars & stuff
		int dist = 0;
		int current_index = -1;
		boolean target_found = false;
		int graphsize = _nodes.size();
		LinkedList<node> queue = new LinkedList<node>();
		queue.add(source);
		triple[] states = new triple[graphsize];
		for (int i = 0; i < graphsize; i++) {
			states[i] = new triple(_nodes.get(i), false, Integer.MAX_VALUE);
		}
		states[_nodes.indexOf(source)].set_dist(dist);
		states[_nodes.indexOf(source)].set_visited();
		// bfs
		outerloop: while (!queue.isEmpty()) {
			dist++;
			for (int i = 0; i < graphsize; i++) {
				if (get_connection(queue.element(), states[i].get_node())
						&& !states[i].get_visited()) {
					queue.add(states[i].get_node());
					states[i].set_visited();
					states[i].set_dist(dist);
					if (states[i].get_node().equals(target)) {
						target_found = true;
						current_index = i;
						break outerloop;
					}
				}
			}
			queue.remove();
		}

		// construct output:
		ArrayList<node> state_sequence = new ArrayList<node>();
		if (target_found) {
			node current = target;
			state_sequence.add(current);
			while (!current.equals(source)) {
				for (int i = 0; i < graphsize; i++) {
					if (states[i].get_visited()
							&& get_connection(states[i].get_node(), current)
							&& states[i].get_dist() < states[current_index].get_dist()) {
						current = states[i].get_node();
						current_index = i;
						state_sequence.add(current);
					}
				}
			}
		}
		ArrayList<node> temp = new ArrayList<node>();
		for (int i = state_sequence.size() - 1; i >= 0; i--) {
			temp.add(state_sequence.get(i));
		}
		state_sequence = temp;
		return state_sequence;
	}

	/**
	 * prints adjacent matrix
	 */
	void print_adj_matrix() {
		int graphsize = _nodes.size();
		System.out.print("      ");
		for (int n = 0; n < graphsize; n++) {
			_nodes.get(n).print_node();
		}
		System.out.println();
		for (int y = 0; y < graphsize; y++) {
			for (int x = 0; x < graphsize; x++) {
				boolean is_set = _adj_matrix[y][x];
				if (x == 0)
					_nodes.get(y).print_node();
				if (is_set)
					System.out.print("  1  ");
				else
					System.out.print("  0  ");
				System.out.print(" ");
			}
			System.out.println("");
		}
	}

	private int find_index(node searched_node) {
		return _nodes.indexOf(searched_node);
	}

	/**
	 * gives information about connection-status
	 */
	private boolean get_connection(node source, node target) {
		int source_ind = find_index(source);
		int target_ind = find_index(target);
		return _adj_matrix[source_ind][target_ind];
	}
}