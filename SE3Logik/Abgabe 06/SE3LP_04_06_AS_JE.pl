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
	%Berechnung für ein Jahr
	Guthaben is (1 + Zinsfaktor) * Anlagebetrag,
	Restdauer is Anlagedauer - 1,
	%Rekursiver Aufruf
	zins(Guthaben,Zinsfaktor,Restdauer,Endguthaben).

%2.:
zins_iter(Anlagebetrag,Zinsfaktor,Anlagedauer,Endguthaben):-
	Zinssatz is 1 + Zinsfaktor,
	Zinsen is Zinssatz ** Anlagedauer,
	%Abschluss der Zinsformel K * 1 + z^t
	Endguthaben is Anlagebetrag * Zinsen.
	
%3.:
% noch nicht fertig

%4.:
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
	

%5.:


%-----------Aufgabe 2------------

%1.:

%2.:

%3.:


%-----------Aufgabe 3------------

%1.:

%2.:

%3.:

%4.:


%-----------Aufgabe 4------------

%1.:
