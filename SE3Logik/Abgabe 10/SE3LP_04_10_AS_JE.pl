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
% TODO

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

% skalarproduk2(+Vektor1,+Vektor2,-R)
skalarprodukt2(Vektor1,Vektor2,R):-
	skalarprodukt2H(Vektor1,Vektor2,0,R).

% skalarprodukt2H (+Vektor1,+Vektor2,?Temp,-R)
skalarprodukt2H([],[],X,X).
skalarprodukt2H([Key1,_|T1],[Key2,_|T2],X,R):-
	not(Key1 = Key2),
	skalarprodukt2H(T1,T2,X,R).
skalarprodukt2H([Key,Worth1|T1],[Key,Worth2|T2],X,R):-
	NX is X + Worth1 * Worth2,
	skalarprodukt2H(T1,T2,NX,R).

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