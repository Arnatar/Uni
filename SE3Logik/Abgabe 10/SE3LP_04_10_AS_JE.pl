%:- dynamic	% ermoeglicht dynamische VeraWListerung
%:- multifile	% ermoeglicht verteilte Definition in mehreren Files

% Abgabe 08 Arne Struck, Jan Esdonk
% Praesentationsbereitschaft
% 1-3 In Zusammenarbeit mit Arne Beer, Felix Favre entstanden

?-[texte].

%============== Aufgabe 1 ==============

%----------------- 1 -------------------

% skalarprodukt(+Vektor1,+Vektor2,-R)
skalarprodukt(Vektor1,Vektor2,R):-
	skalarproduktH(Vektor1,Vektor2,0,R).

% skalarprodukt(+Vektor1,+Vektor2,?Temp,-R)
skalarproduktH([],[],X,X).
skalarproduktH([H1|T1],[H2|T2],X,R):-
	NX is X + H1 * H2,
	skalarproduktH(T1,T2,NX,R).

/*
?- skalarprodukt([1,1,1],[1,1,1],R).
R = 3.

?- skalarprodukt([2,2,2],[2,2,2],R).
R = 12.

?- skalarprodukt([1,2,3],[1,2,3],R).
R = 14.
*/

%----------------- 2 -------------------

% vektorbetrag(+Vector,-Result)
vektorbetrag(Vektor,R):-
	vektorbetragH(Vektor,0,R).
	
% vektorbetragH(+Vector,+Temp,-Result)
vektorbetragH([],X,R):- sqrt(X,R).
vektorbetragH([H|T],X,R):-
	NX is X + H^2,
	vektorbetragH(T,NX,R).
	
/*
?- vektorbetrag([4,4],X).
X = 5.656854249492381.

?- vektorbetrag([2,2],X).
X = 2.8284271247461903.

?- vektorbetrag([3],X).
X = 3.0.

?- vektorbetrag([3,3,3,3],X).
X = 6.0.
*/
	
%----------------- 3 -------------------

% vektorcos(+Vektor1,+Vektor2,-R)
vektorcos(Vektor1,Vektor2,R):-
	skalarprodukt(Vektor1,Vektor2,SP),
	vektorbetrag(Vektor1,Betrag1),
	vektorbetrag(Vektor2,Betrag2),
	R is SP / (Betrag1 * Betrag2).
	
/*
?- vektorcos([1,2,3],[1,2,3],R).
R = 1.0.

?- vektorcos([3,2,1],[1,2,3],R).
R = 0.7142857142857143.

?- vektorcos([0,0,1],[1,0,0],R).
R = 0.0.
*/

%============== Aufgabe 2 ==============

%----------------- 1 -------------------
% Wenn die Setzungsdichte größer als n/2 ist,
% wobei n der Anzahl der Listenelemente entspricht. 

%----------------- 2 -------------------

% komprTermV(+Vektor,-Result)
komprTermV(Vektor,Result):-
	komprTermVH(Vektor,1,[],Temp),
	reverse(Temp,Result).

% komprTermV(+Vektor,?Count,+TempList,-Result)	
komprTermVH([],_,X,X).
komprTermVH([0|T],Count,X,R):-
	NCount is Count + 1,
	komprTermVH(T,NCount,X,R).
komprTermVH([H|T],Count,X,R):-
	not(H = 0),
	NCount is Count + 1,
	append([H,Count],X,NX),
	komprTermVH(T,NCount,NX,R).
	
/*
?- komprTermV([3,0,0,5,0,0,0,2,0,0],R).
R = [1, 3, 4, 5, 8, 2] ;
false.

?- komprTermV([3,0,0,5,0,0,0,2,0,0,0],R).
R = [1, 3, 4, 5, 8, 2] ;
false.

?- komprTermV([3,0,0,5,0,0,0,2,0,0,0,1],R).
R = [1, 3, 4, 5, 8, 2, 12, 1] ;
false.
*/


%----------------- 3 -------------------

skalarprodukt2(Vektor1, Vektor2, Result) :-
    skalarprodukt2H(Vektor1, Vektor2, 1, Result).
    
skalarprodukt2H([Key1, Worth1 | T1], [Key2, Worth2 | T2], X, Result) :-
    (Key1 = X ->
        (NWorth1 = Worth1,
            NT1 = T1);
        (NWorth1 = 0,
            NT1 = [Key1, Worth1 | T1])),
    (Key2 = X ->
        (NWorth2 = Worth2,
            NT2 = T2);
        (NWorth2 = 0,
            NT2 = [Key2, Worth2 | T2])),
    NX is X + 1,
    skalarprodukt2H(NT1, NT2, NX, Temp),
    Result is Temp + NWorth1 * NWorth2.
    
/*
?- skalarprodukt2([1,3,4,5],[1,3,4,5],R).
R = 34.

?- skalarprodukt2([1,3,4,5],[1,3,5,5],R).
R = 9 ;
false.

?- skalarprodukt2([1,3,4,5],[2,3,5,5],R).
R = 0 ;
false.
*/

% vektorbetrag2(+Vector,-Result)
vektorbetrag2(Vektor,R):-
	vektorbetrag2H(Vektor,0,R).
	
% vektorbetrag2H(+Vector,+Temp,-Result)
vektorbetrag2H([],X,R):- sqrt(X,R).
vektorbetrag2H([_,Worth|T],X,R):-
	NX is X + Worth^2,
	vektorbetrag2H(T,NX,R).

/*
?- vektorbetrag2([1,1,2,2,15,3],R).
R = 3.7416573867739413.

?- vektorbetrag2([1,2,2,2],R).
R = 2.8284271247461903.

?- vektorbetrag2([1,2,2,4],R).
R = 4.47213595499958.

?- vektorbetrag2([1,3,2,3,14,3,15,3],R).
R = 6.0.
*/

% vektorcos2(+Vektor1,+Vektor2,-R)
vektorcos2(Vektor1,Vektor2,R):-
	skalarprodukt2(Vektor1,Vektor2,SP),
	vektorbetrag2(Vektor1,Betrag1),
	vektorbetrag2(Vektor2,Betrag2),
	R is SP / (Betrag1 * Betrag2).

%----------------- 4 -------------------

% Consulting Blatt 8 für die Textverarbeitung
?- ['SE3LP_04_08_AS_JE.pl'].

% Hilfsfunktion zum flatten von Listen
% remove_depth(+Liste, -Result).
remove_depth([],[]):- !.
remove_depth([H|T],[H|R]):- \+ is_list(H), !, remove_depth(T,R).
remove_depth([H|T],L):- remove_depth(H,L1), remove_depth(T,L2),
append(L1,L2,L).

% Erstellung des Indexes zur Textsammlung
% index_textsammlung(-Index).
index_textsammlung(Index):-
	findall(Text,text(Number, Text),Textliste),	% finde alle Texte
	remove_depth(Textliste,New),				% Vereinigung zu einer Liste
	stop(Stop),
	delstop(New, Stop, Result),					% Entfernung der Stopwörter
	wordIndex(Result,[],Index).					% Erzeugung des Index

%----------------- 5 -------------------

% Erstellung eines komprimierten Termvektors
% termvektor(+Text,-Vektor)
termvektor(Text,Vektor):-
	stop(Stop),									
	delstop(Text,Stop,DText),					% Entfernung der Stopwörter
	index_textsammlung(Index),					% Erzeugen des Text Index
	wordToIndice(Text,Index,Result),			% Ersetzen der Wörter
	amount(Result,Liste),						% Index Zählung
	sort(Liste,VektorListe),					% Sortierung nach Index
	remove_depth(VektorListe,Vektor).			% Erstellung des Vektors

%----------------- 6 -------------------

% Das Speicherplatzmaximum ist festgelegt durch die Anzahl der
% unterschiedlichen Wörter in den Texten. Bei einer geringen Anzahl
% von unterschiedlichen Wörtern in einem Text, spart man besonders
% viel Speicherplatz durch Kompression, da man alle Wörter ignorieren kann
% die im Index sind, aber nicht im gegebenen Text vorkommen.
