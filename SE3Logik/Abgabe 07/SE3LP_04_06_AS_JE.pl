%:- dynamic	% ermoeglicht dynamische Veraenderung
%:- multifile	% ermoeglicht verteilte Definition in mehreren Files

%Abgabe 07 Arne Struck, Jan Esdonk
%Praesentationsbereitschaft

%============== Aufgabe 1 ==============
/*
[X,X,x] = [y,Y,Y].
Kann nicht unifiziert werden, da komponenetenweise unifiziert wird und bei der 3. Komponente 
schon eine Bindung von Y an x vorhanden ist.

------------------------------------------

[1,[A,1,A],B,[1,B,1]] = [F,G,[F,1,G],H,[1,1,1]].
Kann nicht unifiziert werden, da die Listen unterschiedlich lang sind und daher lassen sich nicht immer
Paare zur Unifizierung finden.

------------------------------------------

[[M,M,M]] = [[d|L]].
M = d, L = [d, d]
Unifizierbar, da M an d gebunden wird und zu dem Head d noch ein beliebiger
Tail gehoert, dieser besteht aus 2 weiteren Ms, also ds

------------------------------------------

[R,R|S] = [[X,b],[a|Y],[X,Y],[Y|X]].
R = [a, b],
S = [[a, [b]], [[b]|a]],
X = a,
Y = [b].
Unifizierbar, da fuer den Tail eindeutige belegungen gefunden werden koennen.
*/


%============== Aufgabe 2 ==============

% last/2 implementieren (letztes Element einer Liste)
% last(?List,?Last)

% Abbruch mit dem letzten Element
last([Last|[]],Last).

% Header rekursiv abtrennen und mit dem Rest der Liste ein rekursiver Aufruf.
last([_|Rest],Last) :- 
		last(Rest,Last).
		
/*
?- last([a,b,c],L).
L = c ;
false.

?- last([c],L).
L = c .

?- last([],L).
false.
*/
% Stellt die gleichen Funktionalitäten bereit.


%------------------------------------------

% nextto/3 neu Implementieren
% nextto(?Element,?Follower,?List)

% Abbruch, der Follower ist in der Liste gefunden.
nextto(Element,Follower,[Element,Follower|_]).

% Liste immer um den Header verkleinert
nextto(Element,Follower,[_|Rest]):-
		nextto(Element,Follower,Rest).
		
/*
?- nextto(a,F,[a,b,c]).
F = b ;
false.

?- nextto(a,F,[a,b,a]).
F = b ;
false.

?- nextto(a,F,[c,b,a]).
false.

?- nextto(a,F,[c,a,a]).
F = a ;
false.

?- nextto(a,F,[a,a,a,b]).
F = a ;
F = a ;
F = b ;
false.

?- nextto(a,F,[]).
false.
*/

%------------------------------------------

% nth/1 neu Implementieren.
% nth1(+Index,?List,?Element)

% Abbruch bei Index = 1 und Element erstes in der Liste
nth1(1,[Element|_],Element).
% 
nth1(Index,[_|Rest],Element):-
% Index abbauend bis 1 gezaehlt, gleichzeitig immer der Header abgetrennt.
		IndexN is Index - 1,
		nth1(IndexN,Rest,Element).
/*
?- nth1(I,[a,b,c],b).
ERROR: [Thread pdt_console_client_0_Default Process] nth1/3: Arguments are not sufficiently instantiated
?- nth1(2,[a,b,c],b).
true .
*/
% Verhaelt sich nicht identisch zu dem Vorbild, da der Index instanziiert sein muss
% (rueckfuehrbar auf den abbauenden Charakter)

% nth1N(?Index,?List,?Element)
% Wrapper, Start mit 1.
nth1N(Index,List,Element):-
		nth1N(Index,List,Element,1).

% Abbruch, Index = Run und Element = Head
nth1N(X,[Element|_],Element,X).
% 
nth1N(Index,[_|Rest],Element,Run):-
% Aufbauende Funktionalitaet, ansonsten wie oben.
		RunN is Run + 1,
		nth1N(Index,Rest,Element,RunN).

/*
?- nth1N(2,[a,b,c],b).
true .

?- nth1N(I,[a,b,c],b).
I = 2 ;
false.
*/
% Funktioniert so wie das Vorbild, allerdings wird ein Hilfspraedikat benoetigt

%------------------------------------------

% sub_atomN(+Atom, ?Before, ?Length, ?After, ?Sub)

%------------------------------------------

%intersection/3
%============== Aufgabe 2 ==============

%------------------------------------------
%1.:

%------------------------------------------
%2.:

%------------------------------------------
%3.: