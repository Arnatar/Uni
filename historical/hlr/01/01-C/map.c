#include <stdio.h>

// ein enum cardd
typedef enum cardd {
	N = 1,
	E = 1 << 1,
	S = 1 << 2,
	W = 1 << 3,
} cardd;

// ein 3x3-Array namens map, das Werte vom Typ cardd enthält
cardd map[3][3] = {};

int val_dir (cardd dir);

// Die Funktion set_dir setzt an Position x, y den Wert dir in das Array map
// x und y werden überprüft um mögliche Arrayüberläufe zu verhindern
// das vorgeschlagene dir wird in val_dir auf seine Gründlichkeit geprüft
void set_dir (int x, int y, cardd dir)
{	
	if (x >= 0 && x <= 2 && y >= 0 && y <= 2 && val_dir(dir)) {
		map[x][y] = dir;
	}
}

// Wir gehen davon aus, dass die Himmelsrichtungen nicht durch dir Prädeterminiert werden. 
// Ansonsten wäre es witzlos die dir's einzeln setzen zu können. 
// Allerdings lässt diese Methode aber noch falsch gesetzte, valide Himmelsrichtungen zu.
int val_dir (cardd dir) {
	cardd dirs[8] = {N, E, S, W, N|E, N|W, S|E, S|W};
	for (int n = 0; n < 8; n++) {
		if (dirs[n] == dir){
			return 1;
		}
	}
	return 0;
}

// show_map gibt das Array in Form einer 3x3-Matrix aus
void show_map (void)
{
	char* repr;
	for (int x = 0; x < 3; x++) {
		for (int y = 0; y < 3; y++) {
			// hardcoding ist zwar eigentlich ein bischen blöd, aber naja
			switch (map[x][y]) {
				case N|W: repr = "NW"; break;
				case N  : repr = "N" ; break;
				case N|E: repr = "NE"; break;
				case E  : repr = "E" ; break;
				case W  : repr = "W" ; break;
				case S|E: repr = "SE"; break;
				case S  : repr = "S" ; break;
				case S|W: repr = "SW"; break;
				default : repr = "0" ;
			}
			// same here
			if (x == 1) {
				printf(y < 2 ? "%s   " : "%s\n", repr);
			} else {
				printf(y < 2 ? "%s  " : "%s\n", repr);
			}
		}
	}
}

int main (void)
{
	// In dieser Funktion darf nichts verändert werden!
	set_dir(0, 1, N);
	set_dir(1, 0, W);
	set_dir(1, 4, W);
	set_dir(1, 2, E);
	set_dir(2, 1, S);

	set_dir(0, 0, N|W);
	set_dir(0, 2, N|E);
	set_dir(0, 2, N|S);
	set_dir(2, 0, S|W);
	set_dir(2, 2, S|E);
	set_dir(2, 2, E|W);

	show_map();

	return 0;
}

// wurde es auch nicht