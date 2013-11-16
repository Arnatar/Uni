%:- dynamic      % ermoeglicht dynamische Veraenderung
%:- multifile   % ermoeglicht verteilte Definition in mehreren Files

%Abgabe 03 Arne Struck, Jan Esdonk
%Präsentationbereitschaft:


%---------Aufgabe 1-----------
/*
!!!!Funtional hinzufügen!!!!!!!!!!!

Keine der Relationen hat eine Eigenschaft ohne
Definition/Implementierung, wir gehen daher davon aus,
dass wünschenswerte, realitätsnahe Eigenschaften
gemeint sind.

A ist mutter von B:
Nicht symmetrisch, da B nicht die Mutter von A sein kann, wenn das
Gegenteil gilt.
Nicht reflexiv, da eine Person nicht ihre eigene Mutter sein kann.
Nicht transitiv, da eine Person keine 2 biologischen Muetter hat.
funktional: ?

A ist nachbarland von B:
Symmetrisch, da wenn A das Nachbarland von B ist, auch B das Nachbarland
von A sein muss.
Nicht reflexiv, da man nicht in Nachbarschaft zur Identität steht.
NIcht Transitiv, da Deutschland kein Nachbarstaat von Spanien ist.
funktional:

A ist Vorfahre von B:
Nicht symmetrisch, da man nicht der Vorfahre des eigenen Nachfahren
sein kann.
Nicht reflexiv, da man ncih/t sein eigener Vorfahre ist.
Transitiv, da der Vorfahre C von A auch der Vorfahre von B ist, wenn
das Praedikat funktioniert.
funktional:

A ist groesser gleich B:
Nicht symmetrisch, da aus A groesser B nicht B groesser A folgt.
Reflexiv, da A groesser gleich A immer gilt.
Transitiv, da aus A groesser B und B groesser C A groesser C folgt.
funktional:

Wir gehen davon aus, dass wirklich der gleiche Film gemeint ist.
A und B spielen Rolle im gleichen Film:
Symmetrisch, da wenn A und B ... auch B und A gelten muss.
Reflexiv, da die Identitaet immer mit sich selber im gleichen Film
spielt.
Nicht reflexiv, da wenn A und B und B und C im gleichen Film spielen,
dann folgt nicht, dass A und C im gleichen Film spielen.
funktional:

A ist gleich B:
Symmetrisch, da aus A gleich B B gleich A folgt.
Die Identität ist immer gleich sich selber.
Transitiv, da gilt: aus A = B B = C folgt A = C.
funktional:

*/




%---------Aufgabe 2----------
%
%[medien2].
%
%1.:
%Da sowohl die direkten parents, als auch die derer parents ausgegeben
%werden sollen, muessen alle berechnet werden.
%ueberkat(?UId,?Kategorie,?Total)
ueberkat(UId,Kategorie,Ergebnis):-
	kategorie(_,Kategorie,UId),
	kategorie(UId,Ergebnis,_).

%2.:
%
path(1,buch,[buch]).
path(2,ebuch,[ebuch]).
path(3,hoerbuch,[hoerbuch]).
path(ID,Kategorie,Total):-
	kategorie(ID,Kategorie,UId),
	kategorie(UId,Kategorie2,_),
	path(UId,Kategorie2,List),
	Total = [Kategorie|List].


%3.:
%
find_prod(Id,Ergebnis):-
	kategorie(UId,_,Id),
	find_prodH(UId,Sup),
	Ergebnis = Sup.

find_prodH(Id,Ergebnis):-
	.

%
%4.:
%
%5.:
%
%6.:
%
%---------Aufgabe 3-----------
%
%
%---------Aufgabe 4-----------





