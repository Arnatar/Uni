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
mylast([Last|[]],Last).

% Header rekursiv abtrennen und mit dem Rest der Liste ein rekursiver Aufruf.
mylast([_|Rest],Last) :- 
		mylast(Rest,Last).
		
/*
?- mylast([a,b,c],L).
L = c ;
false.

?- mylast([c],L).
L = c .

?- mylast([],L).
false.
*/
% Stellt die gleichen Funktionalitäten bereit.


%------------------------------------------

% nextto/3 neu Implementieren
% nextto(?Element,?Follower,?List)

% Abbruch, der Follower ist in der Liste gefunden.
mynextto(Element,Follower,[Element,Follower|_]).

% Liste immer um den Header verkleinert
mynextto(Element,Follower,[_|Rest]):-
		mynextto(Element,Follower,Rest).
		
/*
?- mynextto(a,F,[a,b,c]).
F = b ;
false.

?- mynextto(a,F,[a,b,a]).
F = b ;
false.

?- mynextto(a,F,[c,b,a]).
false.

?- mynextto(a,F,[c,a,a]).
F = a ;
false.

?- mynextto(a,F,[a,a,a,b]).
F = a ;
F = a ;
F = b ;
false.

?- mynextto(a,F,[]).
false.
*/

% Stellt die gleichen Funktionalitäten bereit.

%------------------------------------------

% nth/1 neu Implementieren.
% nth1(+Index,?List,?Element)

% Abbruch bei Index = 1 und Element erstes in der Liste
mynth1(1,[Element|_],Element).
% 
mynth1(Index,[_|Rest],Element):-
% Index abbauend bis 1 gezaehlt, gleichzeitig immer der Header abgetrennt.
		IndexN is Index - 1,
		mynth1(IndexN,Rest,Element).
/*
?- mynth1(I,[a,b,c],b).
ERROR: [Thread pdt_console_client_0_Default Process] mynth1/3: Arguments are not sufficiently instantiated
?- mynth1(2,[a,b,c],b).
true .
*/
% Verhaelt sich nicht identisch zu dem Vorbild, da der Index instanziiert sein muss
% (rueckfuehrbar auf den abbauenden Charakter)

% nth1N(?Index,?List,?Element)
% Wrapper, Start mit 1.
mynth1N(Index,List,Element):-
		mynth1N(Index,List,Element,1).

% Abbruch, Index = Run und Element = Head
mynth1N(X,[Element|_],Element,X).
% 
mynth1N(Index,[_|Rest],Element,Run):-
% Aufbauende Funktionalitaet, ansonsten wie oben.
		RunN is Run + 1,
		mynth1N(Index,Rest,Element,RunN).

/*
?- mynth1N(2,[a,b,c],b).
true .

?- mynth1N(I,[a,b,c],b).
I = 2 ;
false.

?- mynth1N(2,[a,b,c],A).
A = b ;
false.
*/
% Funktioniert so wie das Vorbild, allerdings wird ein Hilfspraedikat benoetigt


%------------------------------------------

% sub_atom(+Atom, ?Before, ?Length, ?After, ?Sub)
% wrapper
mysub_atom(Atom,Before,Length,After,Sub):-
                atom_chars(Atom,AtomList),
% Abbruchwert errechnen
                X is Before + Length,
% Helper aufrufen.
                mysub_atomH(AtomList,Before,Length,After,Sub,X).

% Abbruchbedingung fuer Rekursion, wenn alle angeforderten Elemente erreicht sind.
mysub_atomH(_,X,_,_,_,X).

mysub_atomH(AtomList,Before,Length,After,List,X):-
% Element auf das Before zeigt aus der Liste lesen.
                mynth1N(Before,AtomList,E),
% Before wird um 1 inkrementiert.
                NBefore is Before + 1,
% Rekursionsaufruf mit der Liste und Rest.
                mysub_atomH(AtomList,NBefore,Length,After,NList,X),
% Element zu NList hinzugefuegt.
                append(List,[E],NList).
                
/*
?- mysub_atom(abc,1,1,A,S).
S = [] ;
S = [_G929] ;
S = [_G929, _G935] ;
S = [_G929, _G935, _G941] ;
S = [_G929, _G935, _G941, _G947] ;
S = [_G929, _G935, _G941, _G947, _G953] ;
S = [_G929, _G935, _G941, _G947, _G953, _G959] ;
S = [_G929, _G935, _G941, _G947, _G953, _G959, _G965] ;
S = [_G929, _G935, _G941, _G947, _G953, _G959, _G965, _G971] ;
S = [_G929, _G935, _G941, _G947, _G953, _G959, _G965, _G971, _G977] ;
S = [_G929, _G935, _G941, _G947, _G953, _G959, _G965, _G971, _G977|...] . <- Manuell abgebrochen da anscheinend
Endlosrekursion.

Wir wissen nicht, warum die Abbruchbedingung nie erreicht wird.
*/
                

%------------------------------------------
% intersection(+Set1, +Set2, -Set3)
                
% Abbruch
myintersection([],_,[]).
% Wenn X ein Element von Set2 ist, wird X an T3 als Header gehaengt und dann Set1 um den Header verkuerzt.
myintersection([X|T1],Set2,[X|T3]):- member(X,Set2), myintersection(T1,Set2,T3).
% Wenn X kein Element von Set2 ist, dann wird Set1 um einen verringert.
myintersection([_|T1],Set2,Set3):- myintersection(T1,Set2,Set3).

/*
?- intersection([a,b,c],[a,b,c],I).
I = [a, b, c].
?- myintersection([a,b,c],[a,b,c],I).
I = [a, b, c] ;
I = [a, b] ;
I = [a, c] ;
I = [a] ;
I = [b, c] ;
I = [b] ;
I = [c] ;
I = [].

Es wird das richtige Ergebnis gefunden, allerdings werden durch die Rekursion
auch die restlichen Teilergebnisse Zurueckgegeben. 
*/

%============== Aufgabe 3 ==============

%------------------------------------------
?- [medien2].
%1.:
kUmsatz(KID, Jahr, Umsatz):-
    produkt(PID, KID, _, _, _, _, _),
    aggregate_all(sum(X), (verkauft(PID, Jahr, Preis, Anzahl), X is Preis * Anzahl), Umsatz).
    
/*
?- kUmsatz(10,2012,I).
I = 184.
*/
    

%------------------------------------------
%2.:

%------------------------------------------
%3.: