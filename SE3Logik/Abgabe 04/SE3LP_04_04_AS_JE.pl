%:- dynamic      % ermoeglicht dynamische Veraenderung
%:- multifile   % ermoeglicht verteilte Definition in mehreren Files

%Abgabe 03 Arne Struck, Jan Esdonk
%Praesentationbereitschaft: 1, 2, 4


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
%[medien2]
%
%1.:
%Da sowohl die direkten parents, als auch die derer parents ausgegeben
%werden sollen, muessen alle berechnet werden.
%ueberkat(?UId,?Kategorie,?Total)
ueberkat(UId,Kategorie,Ergebnis):-
	kategorie(UId,Kategorie,Id),
	kategorie(Id,Ergebnis,_).

%ueberkat(15,Kategorie,Ergebnis).
%Kategorie = bilderbuch,
%Ergebnis = kinder.

%2.:
%
%Abbruchbedingungen:
path(1,buch,[buch]).
path(2,ebuch,[ebuch]).
path(3,hoerbuch,[hoerbuch]).

%path(ID?,Kategorie?,Total?)
path(ID,Kategorie,Total):-
%Kategorie und Unterkategorie bestimmen
	kategorie(ID,Kategorie,UId),
	kategorie(UId,Kategorie2,_),
	path(UId,Kategorie2,List),
	append(List,[Kategorie],Total).

%path(15,Kategorie,Total).
%Kategorie = bilderbuch,
%Total = [bilderbuch, kinder, buch] ;

%3.:
%

%find_all_unterprodukte(?KId,?PId)
find_all_unterprodukte(KId, PId) :-
    produkt(PId, KId, _, _, _, _, _);
    kategorie(UKId, _, KId),
    find_all_unterprodukte(UKId, PId).

%find_all_unterprodukte(2, PId).
%PId = 23458 ;
%PId = 23456 ;
%PId = 23457 ;

%4.:
%

%produktanzahl(?KId,?Anzahl)
produktanzahl(KId, Anzahl):-
	findall(PId,find_all_unterprodukte(KId,PId),List),
	length(List, Anzahl).

%produktanzahl(7, Anzahl).
%Anzahl = 3.

%5.:
%

%verkaufsanzahl(?KId,?Jahr,?Anzahl)
verkaufsanzahl(KId, Jahr, Anzahl):-
	findall(Verkauf,verkaufsanzahl_helper(KId,Jahr,Verkauf),Liste),
	sum_list(Liste, Anzahl).

%Gibt die Verkaufsanzahl eines Produktes in einem bestimmten Jahr zurück
%verkaufsanzahl(?KId,?Jahr,?Anzahl)
verkaufsanzahl_helper(KId, Jahr, Anzahl):-
	find_all_unterprodukte(KId, PId),
	verkauft(PId,Jahr,_,Anzahl).

%verkaufsanzahl(7,2012,Anzahl).
%Anzahl = 95.

%6.:
%

%zyklenfrei
zyklenfrei:-
	\+ (
	kategorie(KId,_,UId),
	kategorie(UId,_,KId)
	).
	
%zyklenfrei.
%true.
% nach hinzufügen vom Zyklus
%kategorie(22,kreis,23).
%kategorie(23,kreis,22).
%zyklenfrei.
%false.

%---------Aufgabe 3-----------
%

% Definition des Raumes: A ist [Praedikat] B
unmittelbar_rechts_von(punkt1,punkt2).
unmittelbar_rechts_von(punkt2,punkt3).
unmittelbar_rechts_von(punkt7,punkt6).
unmittelbar_rechts_von(punkt5,punkt1).
unmittelbar_unterhalb_von(punkt2,punkt4).
unmittelbar_unterhalb_von(punkt7,punkt2).
unmittelbar_unterhalb_von(punkt8,punkt7).

%unmittelbar_unterhalb_von(A,B):-
%	unmittelbar_rechts_von(C,A),
%	unmittelbar_unterhalb_von(C,D),
%	unmittelbar_rechts_von(D,B).
%	unmittelbar_rechts_von(A,C),
%	unmittelbar_unterhalb_von(C,D),
%	unmittelbar_rechts_von(B,D).

%liegt_rechts_von(?A,?B)
liegt_rechts_von(A,B):-
	unmittelbar_rechts_von(A,B);
	(unmittelbar_rechts_von(Ebene,B),
	\+ Ebene = A),
	liegt_rechts_von(A,Ebene).

%liegt_links_von(?A,?B)
liegt_links_von(A,B):-
	unmittelbar_rechts_von(B,A);
	(unmittelbar_rechts_von(Ebene,A),
	\+ Ebene = B),
	liegt_links_von(A,Ebene).

%liegt_unterhalb_von(?A,?B)
liegt_unterhalb_von(A,B):-
	unmittelbar_unterhalb_von(A,B);
	(unmittelbar_unterhalb_von(Ebene,B),
	\+ Ebene = A),
	liegt_unterhalb_von(A,Ebene).

%liegt_oberhalb_von(?A,?B)
liegt_oberhalb_von(A,B):-
	unmittelbar_unterhalb_von(B,A);
	(unmittelbar_unterhalb_von(Ebene,A),
	\+ Ebene = B),
	liegt_oberhalb_von(A,Ebene).

%ist_unmittelbar_benachbart_mit(?A,?B)
ist_unmittelbar_benachbart_mit(A,B):-
	unmittelbar_rechts_von(A,B);
	unmittelbar_unterhalb_von(A,B);
	unmittelbar_rechts_von(B,A);
	unmittelbar_unterhalb_von(A,B).

%
%---------Aufgabe 4-----------

% Da es unserer Meinung nach mindestens 2 Interpretationsmoeglichkeiten
% gibt, haben wir 2 Implementationen geschrieben.

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
% Gibt alle vorhanden Relationen A->C aus der Relationsmenge zurueck
% fuer die A->B & B->C gilt. (Bestehende transistive Abhaengigkeit)

%Beispiel:
%transistiv(A,C).
%A = a,
%C = c ;
%A = a,
%C = d ;
%A = d,
%C = f ;

% transistiv(?A,C)
% Gibt alle Elemente A zurueck die transistiv auf C zeigen. (inkl.
% relation(A,C))

%Beispiel:
%transistiv(A,c).
%A = a ;

% transistiv(A,?C)
% Gibt alle Elemente C auf die A transistiv zeigt. (inkl. relation(A,C))

%Beispiel:
%transistiv(a,C).
%C = c ;
%C = d ;

transistiv(A,C):-
	relation(A,B),
	relation(B,C),
	relation(A,C).

% add_transistiv(?A,?C)
% Gibt alle noch hinzuzufuegenden und bestehende Relationen A->C an um die
% Relationsmengen transistiv zu machen

%Beispiel:
%A = a,
%C = c ;
%A = a,
%C = d ;
%...

% add_transistiv(?A,C)
% Gibt alle Elemente A zurueck die transistiv auf C zeigen. (exkl.
% relation(A,C))

%Beispiel:
%add_transistiv(A,c).
%A = a ;

% add_transistiv(A,?C)
% Gibt alle Elemente C auf die A transistiv zeigt. (exkl. relation(A,C))

%Beispiel:
%add_transistiv(a,C).
%C = c ;
%C = d ;
%C = e ;
%C = e ;
%C = f.

add_transistiv(A,C):-
	relation(A,B),
	relation(B,C).




