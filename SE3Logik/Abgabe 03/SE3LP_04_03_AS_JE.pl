%:- dynamic      % ermoeglicht dynamische Veraenderung
%:- multifile   % ermoeglicht verteilte Definition in mehreren Files

%Abgabe 03 Arne Struck, Jan Esdonk
%Präsentationbereitschaft: 2.x,3.x,4.1-4.3


%---------Aufgabe 1-----------
/*
Variablen wird ihr Wert in der logischen Programmierung durch
Unifikation übergeben. Diese Werte werden ausschließlich über Backtracking
aufgelöst, der Scope ist also nur lokal beziehungsweise in der momentanen Ebene
des Backtrackings. Bei dem objektorientierten Paradigma werden Variablen hingegen im physikalischem Speicher bereiche zugewiesen, eine Variable in der
Objektorientierung entspricht also einem Speicherbereich.
In der funktionalen Programmierung wird die Variable zur Wertübergabe an
Funktionen verwendet, der Scope ist hier also nur lokal.
*/




%---------Aufgabe 2----------
%
%[medien].
%
%Wir interpretieren aktuell als 2012 (letzte Verkaufsdaten)
%
%1.:
%finde_preis(+Kategorie,+Titel,+Autor,+Verlag,-Preis)
finde_preis(Kategorie,Titel,Autor,Verlag,Preis) :-
% Die PId zu dem beschriebenen Produkt wird gefunden
	produkt(PId,Kategorie,Titel,Autor,Verlag,_,_),
% Durch die PId und das "aktuelle" Jahr kan der Preis ermittelt werden
	verkauft(PId,2012,Preis,_).

%2.:
%letzter_verkauf(+Kategorie,+Titel,+Autor,+Verlag,-Jahr)
letzter_verkauf(Kategorie,Titel,Autor,Verlag,Jahr) :-
% PId erkennen
	produkt(PId,Kategorie,Titel,Autor,Verlag,_,_),
% Ein Verkaufsjahr wird festgelegt
	verkauft(PId,Jahr,_,_),
% wie in 2.2.6 andere Jahre mit dem Ursprungsjahr vergleichen.
	\+ (verkauft(PId,Jahr2,_,_),
	Jahr < Jahr2).

%3.: Aus dem Katalog genommen wird interpretiert, als "aktuell"
% nicht verkauft.
%veraltet(-PId,+Titel,-Lager)
veraltet(PId,Titel,Lager):-
% Produkt finden, dessen Lager grÃ¶ÃŸer als 0 ist.
	produkt(PId,_,Titel,_,_,_,Lager),
	Lager > 0,
% Produkt darf nicht 2012 verkauft worden sein.
	\+ (verkauft(PId,2012,_,_)).




%---------Aufgabe 3-----------
%
%[medien].
%
%1.:
%produktAnzahl(+Kategorie,-Ergebnis)
produktAnzahl(Kategorie,Ergebnis):-
% Alle Produkte der Kategorie in einer Liste sammeln
	findall(Kategorie,produkt(_,Kategorie,_,_,_,_,_),List),
% Länge der Liste ausgeben
	length(List,Ergebnis).


%2.:

% Berechnung der Verkaufszahlen einer Kategorie
% kategorieVerkauft(+Kategorie,-Ergebnis)
kategorieVerkauft(Kategorie,Ergebnis):-
% Fasst Zwischenergebnisse zusammen und summiert sie
	findall(Anzahl, kVerkauft(Kategorie,Anzahl), List),
	sum_list(List,Ergebnis).

% Hilfsfunktion zum durchgehen der Kategorie
kVerkauft(Kategorie,Ergebnis):-
	produkt(PId,Kategorie,_,_,_,_,_),
% Findet verkäufe für das durch PId spezifizierte Produkt und speichert
% es in einer Liste
	findall(Anzahl,verkauft(PId,_,_,Anzahl),List),
	sum_list(List,Ergebnis).

% Summiert Werte einer Liste durch Rekursion auf.
sum_list([],0).
sum_list([Head | Tail], Total):-
    sum_list(Tail, Sum1),
    Total is Head + Sum1.


%3.:

% Wir interpretieren die Aufgabenstellung so, dass es um die Differenz
% geht von dem Umsatz vom Jahr zu dem Umsatz der erzielt worden wÃ¤re
% mit den Preis aus dem vorherigen Jahr und den Verkaufszahlen des
% angegebenen Jahres.
% nachlass (+Jahr,-Ergebnis)
nachlass(Jahr,Ergebnis):-
% Alle Differenzen Summieren
	findall(X,ein_nachlass(Jahr,X),List),
	sum_list(List,Ergebnis).

ein_nachlass(Jahr,Differenz):-
% Berechnung des Vorjahres
	Jahr2 is Jahr - 1,
% Preise im Jahr und Vorjahr herausfinden.
	verkauft(PId,Jahr,Preis1,Anzahl),
	verkauft(PId,Jahr2,Preis2,_),
% Differenz der Preise Berechnen.
	Differenz is (Preis2 * Anzahl - Preis1 * Anzahl).





%----------Aufgabe 4-------------
%
%[medien2].
%
%1.:
% find_unterkat(+Kategorie,-Ergebnis)
find_unterkat(Kategorie,Ergebnis):-
% Zusammentragen
        findall(Subkat,find_unterkatH(Kategorie,Subkat),Ergebnis).

find_unterkatH(Kategorie,Ergebnis):-
% Findet die UIds zur Kategorie
        kategorie(UId,Kategorie,_),
% Sucht alle Subkategorien (UId ist gleich der der Oberkategorie)
        kategorie(_,Ergebnis,UId).



%2.:
find_double_name(Ergebnis):-
% Alle Ergebnisse Zusammentragen und Dublikate löschen.
        findall(HList,fdnhelper(HList),List),
        sort(List, Ergebnis).

% Hilfsfunktion.
fdnhelper(Ergebnis):-
% Aufgenommen werden alle gleichen Kategorien
        kategorie(UId1,Ergebnis,_),
        kategorie(UId2,Kategorie2,_),
        Ergebnis = Kategorie2,
% Kein Selbstabgleich.
        \+ UId1 = UId2.


%3.:
no_unterkat(UId,Kategorie):-
% Kategorie und UId herausfinden.
        kategorie(UId,Kategorie,_),
% keine Unterkategorie bedeutet als Ergebnis für find_unterkat eine
% leere Liste.
        (find_unterkat(Kategorie,List),
        List = []).


%4.:
