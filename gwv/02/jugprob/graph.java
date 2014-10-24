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
	 * gives information about connection-status
	 */
	public boolean get_connection(node source, node target) {
		int source_ind = find_index(source);
		int target_ind = find_index(target);
		return _adj_list[source_ind][target_ind];
	}

	/**
	 * prints adjacent matrix
	 */
	public void print_adj_matrix() {
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

	public void run_bfs(node source, node target) {
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
		
		// buildt return statement
		if (target_found) {
			node current = target;
			ArrayList<node> state_sequenz = new ArrayList<node>();
			state_sequenz.add(current);
			while (!current.equals(source)) {
				for (int i = 0; i < graphsize; i++) {
					if (states[i].get_visited()
							&& get_connection(states[i].get_node(), current)
							&& states[i].get_dist() < states[current_index].get_dist()) {
						current = states[i].get_node();
						current_index = i;
						state_sequenz.add(current);
					}
				}
			}
			System.out.print("\n\n" + "Ergebnisreihenfolge: ");
			for (int i = state_sequenz.size() - 1; i >= 0; i--) {
				System.out.print("(" + state_sequenz.get(i).get_fourLitre() + " "
						+ state_sequenz.get(i).get_threeLitre() + ") ");
			}
		} else
			System.out.println("\n" + "Konnte das Ziel keiner Verbindung zuordnen");
	}
}