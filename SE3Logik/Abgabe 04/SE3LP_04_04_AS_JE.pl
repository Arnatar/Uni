%:- dynamic      % ermoeglicht dynamische Veraenderung
%:- multifile   % ermoeglicht verteilte Definition in mehreren Files

%Abgabe 03 Arne Struck, Jan Esdonk
%Pr�sentationbereitschaft:


%---------Aufgabe 1-----------
/*
!!!!Funtional hinzuf�gen!!!!!!!!!!!

Keine der Relationen hat eine Eigenschaft ohne
Definition/Implementierung, wir gehen daher davon aus,
dass w�nschenswerte, realit�tsnahe Eigenschaften
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
Nicht reflexiv, da man nicht in Nachbarschaft zur Identit�t steht.
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
Reflexiv, die Identit�t ist immer gleich sich selber.
Transitiv, da gilt: aus A = B B = C folgt A = C.
funktional:

*/




%---------Aufgabe 2----------
%
%[medien2].ue
%
%1.:
%Da sowohl die direkten parents, als auch die derer parents ausgegeben
%werden sollen, muessen alle berechnet werden.
%ueberkat(?UId,?Kategorie,?Total)
ueberkat(UId,Kategorie,Ergebnis):-
	kategorie(UId,Kategorie,Id),
	kategorie(Id,Ergebnis,_).

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

% Workaround
find_unterkategorie_pfade(21, []).
find_unterkategorie_pfade(20, []).
find_unterkategorie_pfade(19, []).	
find_unterkategorie_pfade(18, []).	
find_unterkategorie_pfade(17, []).	
find_unterkategorie_pfade(16, []).	
find_unterkategorie_pfade(15, []).	
find_unterkategorie_pfade(14, []).
find_unterkategorie_pfade(12, []).	
find_unterkategorie_pfade(11, []).	
find_unterkategorie_pfade(10, []).	
find_unterkategorie_pfade(9, []).	
find_unterkategorie_pfade(8, []).
find_unterkategorie_pfade(7, []).	
find_unterkategorie_pfade(6, []).	
find_unterkategorie_pfade(5, []).			


find_unterkategorie_pfade(KId, Total):-
	kategorie(UId,_,KId),
	find_unterkategorie_pfade(UId, List),
	Total = [UId|List].	

	
find_unter_produkte(KId, PId):-
	find_unterkategorie_pfade(KId, KIdListe),
	member(UId, KIdListe),
	produkt(PId,UId,_,_,_,_,_).	

%4.:
%

produktanzahl(KId, Anzahl):-
	findall(PId, find_unter_produkte(KId, PId), Liste),
	length(Liste, Anzahl).
	
	
%5.:
%

verkaufsanzahl(KId, Jahr, Anzahl):-
	findall(Verkauf,verkaufsanzahl_helper(KId,Jahr,Verkauf),Liste),
	sum_list(Liste, Anzahl).

verkaufsanzahl_helper(KId, Jahr, Anzahl):-
	find_unter_produkte(KId, PId),
	verkauft(PId,Jahr,_,Anzahl).
	
%6.:
%

zyklenfrei:-
	\+ (
	kategorie(KId,_,UId),
	kategorie(UId,_,KId)
	).
	
%---------Aufgabe 3-----------
%
unmittelbar_rechts_von(punkt1,punkt2).
unmittelbar_rechts_von(punkt2,punkt3).
unmittelbar_unterhalb_von(punkt2,punkt4).


liegt_rechts_von(Rechts,Links):-
	unmittelbar_rechts_von(Rechts,Links);
	unmittelbar_rechts_von(Ebene,Links),
	liegt_rechts_von(Rechts,Ebene).
	
liegt_links_von(A,B):-
	unmittelbar_rechts_von(B,A);
	unmittelbar_rechts_von(Ebene,A),
	liegt_links_von(A,Ebene).
	
liegt_unterhalb_von(A,B):-
	unmittelbar_unterhalb_von(A,B);
	unmittelbar_unnterhalb_von(Ebene,B),
	liegt_unterhalb_von(A,Ebene).
	
liegt_oberhalb_von(A,B):-
	unmittelbar_unterhalb_von(B,A);
	unmittelbar_unnterhalb_von(Ebene,A),
	liegt_oberhalb_von(A,Ebene).
	
ist_unmittelbar_benachbart_mit(A,B):-
	unmittelbar_rechts_von(A,B);
	unmittelbar_unterhalb_von(A,B);
	unmittelbar_rechts_von(B,A);
	unmittelbar_unterhalb_von(A,B).

%
%---------Aufgabe 4-----------





