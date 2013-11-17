%:- dynamic      % ermoeglicht dynamische Veraenderung
%:- multifile   % ermoeglicht verteilte Definition in mehreren Files

%Abgabe 03 Arne Struck, Jan Esdonk
%Praesentationbereitschaft:


%---------Aufgabe 1-----------
/*
Keine der Relationen hat eine Eigenschaft ohne
Definition/Implementierung, wir gehen daher davon aus,
dass wuenschenswerte, realitaetsnahe Eigenschaften
gemeint sind.

A ist mutter von B:
Nicht symmetrisch, da B nicht die Mutter von A sein kann, wenn das
Gegenteil gilt.
Nicht reflexiv, da eine Person nicht ihre eigene Mutter sein kann.
Nicht transitiv, da eine Person keine 2 biologischen Muetter hat.
Ist funktional, da eine Mutter n Kinder (1:n) haben kann.

A ist nachbarland von B:
Symmetrisch, da wenn A das Nachbarland von B ist, auch B das Nachbarland
von A sein muss.
Nicht reflexiv, da man nicht in Nachbarschaft zur Identit�t steht.
NIcht Transitiv, da Deutschland kein Nachbarstaat von Spanien ist.
Funktional, da es eine 1:1-Beziehung ist (Spezialfall von 1:n).

A ist Vorfahre von B:
Nicht symmetrisch, da man nicht der Vorfahre des eigenen Nachfahren
sein kann.
Nicht reflexiv, da man nicht sein eigener Vorfahre ist.
Transitiv, da der Vorfahre C von A auch der Vorfahre von B ist, wenn
das Praedikat funktioniert.
Nicht funktional, da es sich um eine m:1 beziehung handelt.

A ist groesser gleich B:
Nicht symmetrisch, da aus A groesser B nicht B groesser A folgt.
Reflexiv, da A groesser gleich A immer gilt.
Transitiv, da aus A groesser B und B groesser C A groesser C folgt.
Nicht funktional, da keine Werte aufeinander abgebildet werden.

Wir gehen davon aus, dass wirklich der gleiche Film gemeint ist.
A und B spielen Rolle im gleichen Film:
Symmetrisch, da wenn A und B ... auch B und A gelten muss.
Reflexiv, da die Identitaet immer mit sich selber im gleichen Film
spielt.
Nicht transitiv, da wenn A und B und B und C im gleichen Film spielen,
dann folgt nicht, dass A und C im gleichen Film spielen.
Funktional, es handelt sich um 2 1:1 Beziehungen.

A ist gleich B:
Symmetrisch, da aus A gleich B B gleich A folgt.
Reflexiv, die Identitaet ist immer gleich sich selber.
Transitiv, da gilt: aus A = B B = C folgt A = C.
Funktional, es werden 2 Werte aufeinander abgebildet.

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
%Abbruch
path(1,buch,[buch]).
path(2,ebuch,[ebuch]).
path(3,hoerbuch,[hoerbuch]).

%
path(ID,Kategorie,Total):-
	kategorie(ID,Kategorie,UId),
	kategorie(UId,Kategorie2,_),
	path(UId,Kategorie2,List),
	Total = [Kategorie|List].


%3.:
%
%Sollte das gleiche tun, wie workaround
find_unterkategorie_pfade(Id,List):-
	\+ (kategorie(_,_,Id)),
	List = [].


find_unterkategorie_pfade(KId, Total):-
	kategorie(UId,_,KId),
	find_unterkategorie_pfade(UId, List),
	Total = [UId|List].


find_unter_produkte(KId, PId):-
	find_unterkategorie_pfade(KId, KIdListe),
	member(UId, KIdListe),
	produkt(PId,UId,_,_,_,_,_).

find_produkte(KId, Ergebnis):-
	findall(PIds,find_unter_produkte(KId,PIds),SubList),
	sort(SubList,List),
	(\+ \+ produkt(PId,KId,_,_,_,_,_) ->
	Ergebnis = [PId|List]; Ergebnis = List).

%4.:
%

produktanzahl(KId, Anzahl):-
	find_produkte(KId,List),
	length(List, Anzahl).


%5.:
%

verkaufsanzahl(KId, Jahr, Anzahl):-
	findall(Verkauf,verkaufsanzahl_helper(KId,Jahr,Verkauf),Liste),
	produkt(PIdn,KId,_,_,_,_,_),
	verkauft(PIdn,Jahr,_,Anzahl2),
	sum_list(Liste, Anzahl3),
	Anzahl is Anzahl2 + Anzahl3.

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
unmittelbar_rechts_von(punkt5,punkt1).
unmittelbar_unterhalb_von(punkt2,punkt4).
unmittelbar_unterhalb_von(punkt1,punkt6).
unmittelbar_rechts_von(punkt7,punkt6).



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
	unmittelbar_unterhalb_von(Ebene,B),
	liegt_unterhalb_von(A,Ebene).

liegt_oberhalb_von(A,B):-
	unmittelbar_unterhalb_von(B,A);
	unmittelbar_unterhalb_von(Ebene,A),
	liegt_oberhalb_von(A,Ebene).

ist_unmittelbar_benachbart_mit(A,B):-
	unmittelbar_rechts_von(A,B);
	unmittelbar_unterhalb_von(A,B);
	unmittelbar_rechts_von(B,A);
	unmittelbar_unterhalb_von(A,B).

%
%---------Aufgabe 4-----------

% Da es unserer Meinung nach mindestens 2 Interpretationsmöglichkeiten gibt,
% haben wir 2 Implementationen geschrieben.

% Definition der Relationsmenge:
% A steht in Relation zu B
% relation(A,B)
relation(a,b).
relation(b,c).
relation(a,c).
relation(b,d).
relation(a,d).
relation(c,e).
relation(e,f).
relation(d,e).
relation(d,f).

% transistiv(?A,?C)
% Gibt alle vorhanden Relationen A->C aus der Relationsmenge zurück für die
% A->B & B->C gilt. (Bestehende transistive Abhängigkeit)

% transistiv(?A,C)
% Gibt alle Elemente A zurueck die transistiv auf C zeigen. (inkl.
% relation(A,C))

% transistiv(A,?C)
% Gibt alle Elemente C auf die A transistiv zeigt. (inkl. relation(A,C))

transistiv(A,C):-
	relation(A,B),
	relation(B,C),
	relation(A,C).

% add_transistiv(?A,?C)
% Gibt alle noch hinzuzufuegenden Relationen A->C an um die
% Relationsmengen transistiv zu machen

% add_transistiv(?A,C)
% Gibt alle Elemente A zurueck die transistiv auf C zeigen. (exkl.
% relation(A,C))

% add_transistiv(A,?C)
% Gibt alle Elemente C auf die A transistiv zeigt. (exkl. relation(A,C))

add_transistiv(A,C):-
	relation(A,B),
	relation(B,C).




