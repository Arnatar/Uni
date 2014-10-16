#include <stdio.h>

// Definieren Sie ein enum cardd
typedef enum {None, N, E, S, W} cardd;

// Wir brauchen 'None', da bei der Array-Initialisierung der map per default alle
// cells auf 0 initialisiert werden, und so per default 'N' gelten würde - das wollen
// wir nicht. Eine alternative Implementation mit nur 4 Elementen waere:
// typedef enum {N=1, E=2, S=3, W=4} cardd;


// Definieren Sie ein 3x3-Array namens map, das Werte vom Typ cardd enthält
static cardd map[3][3];


// Die Funktion set_dir soll an Position x, y den Wert dir in das Array map eintragen
// Überprüfen Sie x und y um mögliche Arrayüberläufe zu verhindern
// Überprüfen Sie außerdem dir auf Gültigkeit
void set_dir (int x, int y, cardd dir)
{
  if (x < 3 && x >= 0 && y < 3 && y >= 0) {
    if (dir >= 0 && dir <= 4) {
      map[x][y] = dir;
    }
  }
}

// Die Funktion show_map soll das Array in Form einer 3x3-Matrix ausgeben
void show_map (void)
{
  char* repr;
  for (int x=0; x<3; x++) {
    for (int y=0; y<3; y++) {
      switch(map[x][y]) {
        case N: repr = "N"; break;
        case E: repr = "E"; break;
        case S: repr = "S"; break;
        case W: repr = "W"; break;
        default: repr = "0";
      }
      printf(y<2 ? "%s   " : "%s\n", repr);
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
