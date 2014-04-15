%:- dynamic	% ermoeglicht dynamische Veraenderung
%:- multifile	% ermoeglicht verteilte Definition in mehreren Files

%Abgabe 06 Arne Struck, Jan Esdonk
%Praesentationsbereitschaft

%-----------Aufgabe 1------------

%1.:
zins_rek(Anlagebetrag,Zinsfaktor,Anlagedauer,Endguthaben):-
	%Abbruch bei Ablauf der Anlagedauer
	Anlagedauer == 0,
	Endguthaben = Anlagebetrag;
	\+ Anlagedauer == 0,
	%Berechnung fuer ein Jahr
	Guthaben is (1 + Zinsfaktor) * Anlagebetrag,
	Restdauer is Anlagedauer - 1,
	%Rekursiver Aufruf
	zins_rek(Guthaben,Zinsfaktor,Restdauer,Endguthaben).

%Beispiel
%?- zins_rek(100,0.05,3,Guthaben).
%Guthaben = 115.7625

%2.:
zins_iter(Anlagebetrag,Zinsfaktor,Anlagedauer,Endguthaben):-
	Zinssatz is 1 + Zinsfaktor,
	Zinsen is Zinssatz ** Anlagedauer,
	%Abschluss der Zinsformel K * 1 + z^t
	Endguthaben is Anlagebetrag * Zinsen.
	
%Beispiel
%?- zins_iter(100,0.05,3,Guthaben).
%Guthaben = 115.76250000000002.

%3.:


%4.:
% muss mit einem Zinsfaktor und einem Bonuszinzfaktor initialisiert werden
% im Beispiel der Aufgabe sind die Werte 0.01 und 0.02
zins_steigend(Anlagebetrag,Zinsfaktor,Bonuszins,Anlagedauer,Endguthaben):-
	Anlagedauer == 0,
	Endguthaben = Anlagebetrag;
	\+ Anlagedauer == 0,
	%Aufsummierung von Zins + Bonus
	NeuerZins is Zinsfaktor + Bonuszins,
	Guthaben is (1 + NeuerZins) * Anlagebetrag,
	Restdauer is Anlagedauer - 1,
	%Halbierung des Bonus pro Jahr
	NeuerBonus is Bonuszins / 2,
	%Rekursiver Aufruf
	zins_steigend(Guthaben,NeuerZins,NeuerBonus,Restdauer,Endguthaben).

%Beispiel
%?- zins_steigend(100,0.01,0.02,2,Guthaben).
%Guthaben = 107.12

%5.:
% Das Anlegen mit steigendem Zinssatz lohnt sich ab einer Dauer von 4 Jahren.

%?- zins_rek(100,0.04,4,Guthaben).
%Guthaben = 116.98585600000001 ;
%?- zins_steigend(100,0.01,0.02,4,Guthaben).
%Guthaben = 117.257569 ;

%-----------Aufgabe 2------------

%1.:
% Nicht endrekursiv
% Abbruchbedingung: (Wenn 4 ereicht ist, wird abgebrochen)
pi(1, 4) :- !.

pi(Steps, Result) :-
% Steps mit jeder Rekursion um 1 reduzieren
    NSteps is Steps - 1,
    pi(NSteps, NResult),
% Result ist das entsprechende Level der Reihe zu dem Rest addiert
    Result is NResult + (4 * (-1 ** (Steps+1))/((2*Steps) - 1)).

/*
?- pi(20,Result).
Result = 3.09162380666784.

?- pi(0,Result).
ERROR: Out of local stack
?- pi(1,Result).
Result = 4.
*/

%Endrekursiv:
% wrapper-praedikat
endRekPi(Steps,Result):-
	endRekPi(Steps,0,Result).

% Abbruchbedingung
endRekPi(0,PriorResult,PriorResult):-!.

% Rekursion
endRekPi(Steps,Prior,Result):-
% NResult ist die bisherige Reihe.
	NResult is Prior + (4 * (-1 ** (Steps + 1))/((2 * Steps)-1)),
% Steps um 1 reduzieren.
	NSteps is Steps -1,
	endRekPi(NSteps,NResult,Result).

/*
?- endRekPi(139001,R).
R = 3.141599847782641.

?- endRekPi(139000,R).
R = 3.141585459345189.
*/

%2.:
/*
Die Nicht endrekursive Loesung ist verstaendlicher, da es eine eifache
Abarbeitung von Schritten ist und ohne Zwischenspeicher auskommt.
Die Endrekursive Loesung ist bei der Berechnungszeit deutlich schneller
(bei 500000 und 1000000 Schritten braucht pi/2 eine gewisse
Berechnungszeit, endRekPi/2 dagegen berechnet dies in deutlich weniger
Zeit)
*/

%3.:
%
/*
?- endRekPi(139001,R).
R = 3.141599847782641.

?- endRekPi(139000,R).
R = 3.141585459345189.

Damit ist gezeigt, dass bei 139000 Schritten die 5 nicht mehr hin und
her springt.
*/



%-----------Aufgabe 3------------

%1.:
%natN(-Resultat)
natN(Resultat):-
    natNH(Resultat, 0).

natNH(Result, Max):-
    Result is Max + 1;
    NewMax is Max + 1,
    natNH(Result, NewMax).

% ?- natN(R).
% R = 1 ;
% R = 2 ;
% R = 3 ;
% R = 4 ;
% R = 5 ;
% R = 6 ;
% R = 7 ;
% R = 8 ;
% R = 9 ;
% R = 10


%2.:
% natN2(-Resultat, +Limit)
natN2(Result, Limit):-
    natN2H(Result, 0, Limit).
natN2H(Result, Max, Limit):-
    Result is Max + 1, Result =< Limit; %<- OR
    NewMax is Max + 1,
    NewMax =< Limit,
    natN2H(Result, NewMax, Limit).

% ?- natN2(R, 6).
% R = 1 ;
% R = 2 ;
% R = 3 ;
% R = 4 ;
% R = 5 ;
% R = 6 ;
% false.

%3.:
pi_incr(Steps,Pi):-
% Fuer alle Zahlen aus den Natuerlichen Zahlen wird eine Piberechnung
% ausgef�hrt mit den Zahlen als Schritte.
	natN2(PiSteps,Steps),
	endRekPi(PiSteps,Pi).
/*
?- pi_incr(4,Pi).
Pi = 4 ;
Pi = 2.666666666666667 ;
Pi = 3.466666666666667 ;
Pi = 2.8952380952380956 ;
false.
*/

%4.:
[display].
%?- findall(X,pi_incr(119,X),L),display('pi',L).
% Damit wird durch 119 der Anfang einer Linie erreicht, also sind nach
% 119 Approximationen die Approximationsfehler unter die Genauigkeiten
% der Darstellung gesunken.


%-----------Aufgabe 4------------

%1.:
% In den ersten 3 Klauseln werden die Rechenregeln
% zur Koeffizienzberechnung definiert. Die 4. Klausel
% führt die Rekursion aus und addiert die jeweiligen
% Ergebnisse zum finalen Ergebnis.
% Abbruch für n = 0
 binomial(0,_,0):- !.
% Abbruch für k = 1
 binomial(N,1,N):- !.
% Wenn k = n, dann ist R = 1
 binomial(X,X,1):- !.
% Hauptklausel: 
 binomial(N,K,Result):-
	 % Dekrementierung
	 N1 is N-1,
	 K1 is K-1,
	 % Erster Teil der Binomialkoeffizients Gleichung
	 binomial(P1,K,R1),
	 % Zweiter Teil der Binomialkoeffizients Gleichung
	 binomial(P1,K1,R2),
	 % Addition der Teilergebnisse zum Abschluss der Berechnung
	 Result is R1 + R2.

% Beispiel:	 
%?- binomial(8,2,Result).
%Result = 28.