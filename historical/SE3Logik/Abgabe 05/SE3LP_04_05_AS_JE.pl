%:- dynamic      % ermoeglicht dynamische Veraenderung
%:- multifile   % ermoeglicht verteilte Definition in mehreren Files

%Abgabe 05 Arne Struck, Jan Esdonk
%Praesentationbereitschaft:

%---------Aufgabe 1-----------
/*
a(B,C) = a(m,p).
B = m, C = p.
Die Variablen (B,C) werden mit den Konstanten (m,p) unifiziert.

s(1,2) = s(P,P).
false.
P kann nicht sowohl mit 1 als auch mit 2 unifiziert werden.

g(f(s,R),f(R,s)) = g(f(S,s(T)),f(t(t)),S).
false.
g/2 laesst sich nicht mit g/3 unifizieren, da es 2 unterschiedliche
Pr�dikate darstellt.

true = not(not(True)).
false.
true ist eine Konstante und kann damit nicht mit einem kompletten
ausdruck unifiziert werden.

True = not(false).
True = not(false).
Die Variable True ist unifizierbar mit einem Audruck.
*/

%---------Aufgabe 2-----------
%Aus der Vorlesung:
%Typtest:
peano(0).
peano(s(X)):- peano(X).

%Lesser-Than:
lt(0,s(_)).
lt(s(X),s(Y)):-lt(X,Y).

%1.:
%Wir nehmen am Anfang einen Typtest vor, damit wir sicher
%Peano-Zahlen behandeln.

%Nachfolgerberechnung:
%nachfolger(?Input,?Ergebnis)
nachfolger(Input,Ergebnis):-
	peano(Input),
% Der Nachfolger ist der Vorg�nger ummantelt mit dem Fakt s().
	Ergebnis = s(Input).

%Test:
%?- nachfolger(s(0),Out).
%Out = s(s(0)).


%Vorgaengerberechnung:
%vorgaenger(?Input,?Ergebnis)
vorgaenger(s(Input),Ergebnis):-
	peano(Input),
% Der Vorgaenger ist das innere einer Peano-Zahl.
	Ergebnis = Input.
% Moeglich, da die 0 keinen Vorgaenger besitzt.
%Test:
%?- vorgaenger(s(s(0)),Out).
%Out = s(0).

%?- vorgaenger(s(s(1)),Out).
%false.

%?- vorgaenger(0,Out).
%false.

%Subtrahieren:
%
%sub(?Minuend,?Subtrahend,?Ergebnis)
sub(X,0,X).
sub(s(Minuend),s(Subtrahend),Ergebnis):-
% Subtrahend und Minuend muessen Peano-Zahlen sein.
	peano(Minuend),
	peano(Subtrahend),
% Der Subtrahend muss kleiner sein, als der Minuend, damit das Ergebnis
% eine Peano-Zahl ist.
	lt(Subtrahend,Minuend),
	sub(Minuend,Subtrahend,Ergebnis).
%?- sub(s(s(s(0))),s(s(0)),X).
%X = s(0) ;


%max(?Peano1,?Peano2,?PeanoMax)
max(X,X,X).
max(Peano1,Peano2,PeanoMax):-
% Typtest:
	peano(Peano1),
	peano(Peano2),
% Wenn Peano1 kleiner als Peano2 ist, dann ist PeanoMax mit Peano2 zu
% unifizieren, wenn nicht mit Peano1
	(lt(Peano1,Peano2) -> PeanoMax = Peano2; PeanoMax = Peano1).
/*
?- max(s(s(s(0))),s(s(0)),X).
X = s(s(s(0))).

?- max(s(0),s(s(0)),X).
X = s(s(0)).

?- max(s(0),s(0),X).
X = s(0) ;
X = s(0).
*/
% mod(?Dividend, ?Divisor, ?Ergebnis)
mod(X,X,0).
mod(Dividend, Divisor, Ergebnis) :-
% Typtest:
	peano(Dividend),
	peano(Divisor),
% Wenn Dividend kleiner als Divisor ist
	(lt(Dividend,Divisor) ->
% Dann ist der Modulo schon der Dividend
	Ergebnis = Dividend; %<- OR
% Wenn nicht, wird der Divisor einmal Subtrahiert
	sub(Dividend,Divisor,X),
% Und mod neu aufgerufen
	mod(X, Divisor, Ergebnis)).
/*
?- mod(s(0),s(0),X).
X = 0 ;
false.

?- mod(s(s(s(0))),s(s(0)),X).
X = s(0) ;
false.
*/

% peano_to_int(?Peano, ?Int)
peano_to_int(0,0).
peano_to_int(s(Peano), Int) :-
% Typtest:
	peano(s(Peano)),
% rekursiver Aufruf der Zahl
        peano_to_int(Peano, X),
% F�r jeden Aufruf eine Addition mit 1
        Int is X + 1.


%2.:

ltTyped(0,s(_)).
ltTyped(s(X),s(Y)):-
%Typtest:
	peano(s(X)),
	peano(s(Y)),
	lt(X,Y).
/*
?- ltTyped(s(s(0)),s(s(s(0)))).
true.

?- ltTyped(s(s(0)),s(0)).
false.
*/
%Es wird false sowohl f�r nein, als auch f�r falsche Typen
%ausgegeben.

addTyped(0,X,X).
addTyped(s(X),Y,s(R)):-
	peano(Y),
	peano(s(X)),
	addTyped(X,Y,R).
/*
?- addTyped(s(s(0)),s(0),X).
X = s(s(s(0))).

77 ?- addTyped(s(s(1)),s(0),X).
false.
*/
% Wir stellen keine Ver�nderung fest (false wenn falsche Eingabe),
% Ergebnis wenn richtige.


%---------Aufgabe 3-----------
%1.:
?- [medien2].
%find_all_unterprodukte(?KId,?PId)
find_all_unterprodukte(KId, PId) :-
    produkt(PId, KId, _, _, _, _, _);
    kategorie(UKId, _, KId),
    find_all_unterprodukte(UKId, PId).

verkaufspreis(PId,KId,Jahr,Preis):-
	%Finde alle Unterprodukte einer Kategorie
	find_all_unterprodukte(KId, PId),
	%Ermittel den jeweiligen Verkaufspreis
	verkauft(PId,Jahr,Preis,_).

%avg_verkaufspreis(?KId,Jahr,Avg_preis
avg_verkaufspreis(KId,Jahr,Avg_preis):-
	%Finde alle Preise einer Kategorie
	findall(Preis,verkaufspreis(PId,KId,Jahr,Preis),Preisliste),
	%Summiere die Preise auf
	sum_list(Preisliste, Preis_summe),
	%Anzahl der Preise
	length(Preisliste, Laenge),
	\+ Laenge == 0,
	%Berechnung des Durchschnitts
	Avg_preis is Preis_summe / Laenge.

%Beispiel:
%?-avg_verkaufspreis(0,2012,Avg).
%Avg = 19.

%2.:
%Hilfsfunktion zum Finden des Maximums einer Liste
max([X],X).
max([X|Xs],X):- max(Xs,Y), X >=Y.
max([X|Xs],N):- max(Xs,N), N > X.

%teuerstes_produkt(?PId,KId,Jahr)
teuerstes_produkt(PId,KId,Jahr):-
	%Finde alle Preise
	findall(Preis,verkaufspreis(PId,KId,Jahr,Preis),Verkaufsliste),
	%Finde den maximalen Preis
	max(Verkaufsliste,MaxPreis),
	%Suche nachen den Produkt mit den höchsten Preis
	verkaufspreis(PId,KId,Jahr,MaxPreis).
	
%Beispiel:
%?-teuerstes_produkt(PId,KId,2010).
%	


%---------Aufgabe 4-----------

%Beispiel Datenbank für Voraussetzungen
%A ist Voraussetzung für B
ist_voraussetzung_fuer(anfang,beton_anmischen).
ist_voraussetzung_fuer(anfang,grundriss).
ist_voraussetzung_fuer(dachstuhl_errichten,dach_decken).
ist_voraussetzung_fuer(dach_decken,dauchausbau).
ist_voraussetzung_fuer(mauerbau,dachstuhl).
ist_voraussetzung_fuer(fundament,mauerbau).
ist_voraussetzung_fuer(mauerbau,fenster_einsetzen).
ist_voraussetzung_fuer(fenster_einsetzen,heizungs_installation).
ist_voraussetzung_fuer(grundriss,mauerbau).
ist_voraussetzung_fuer(beton_anmischen,fundament).

ist_voraussetzung_fuer(A,B):-
	ist_voraussetzung_fuer(C,A).
