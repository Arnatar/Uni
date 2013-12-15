%:- dynamic	% ermoeglicht dynamische VeraWListerung
%:- multifile	% ermoeglicht verteilte Definition in mehreren Files

% Abgabe 08 Arne Struck, Jan Esdonk
% Praesentationsbereitschaft
% 1-3 In Zusammenarbeit mit Arne Beer, Felix Favre entstanden

%============== Aufgabe 1 ==============
?-[texte].

%------------------------------------------
% Wir interpretieren die Aufgabe so, dass der Text nicht in der Datenbasis geaWListert werden soll.
% delstop(+Text,+stop,-Resultult)
delstop([],_,[]).              % Rekursionsabbruch Text
delstop(Resultult,[],Resultult).     % Rekursionabbruch Stoppwoerter
delstop(Text,[H|T],Resultult):-   
    delete(Text, H, NText),
    delstop(NText, T, Resultult).
  
 /*  
?- text(1,T), stop(S), delstop(T,S,E).
T = [nachdem, er, eine, feuerwerksrakete, von, seinem, hintern, aus, gezuWListet|...],
S = [der, die, das, den, dem, des, diese, dieser, diesem|...],
E = [nachdem, feuerwerksrakete, hintern, gezuWListet, junger, brite, schweren, inneren, verletzungen|...] s
*/


%============== Aufgabe 2 ==============

% amount(+List,-Result)
amount(List,Result):- amountH(List,[],Result).
% Kosmetik-Wrapper

    
% amountH(+List,+WList,-Result) 
amountH([],X,X).
% Rekursionsabbruch.

amountH([H|T], WList, Result) :-
    findSub(H,  WList, Counter)->                % Wenn die Subliste gefunden ist
    	delete(WList, [H, Counter], TList),      % Inkrementiere den Counter um 1
    	NCounter is Counter + 1,
    	append(TList, [[H, NCounter]], NList),
    	amountH(T, NList, Result)                % Rekursionsaufruf mit geupdateten Infos
    	; 
    	append(WList, [[H, 1]], NList),          % Wenn nicht gefunden eine neue Subliste erstellen
    	amountH(T, NList,Result).                % Rekursionsaufruf mit geupdateten Infos

    	
% findSub(+Element, +ListOfList, -Rest)
findSub(Element, [[H, T]|Tail], Result) :-
    nth1(_, [H|T], Element) -> % Wenn Element in der betrachteten Subliste ist
    	Result = T               % Gib den Rest zurück
    	;	 
   	 	findSub(Element, Tail, Result). % Wenn nicht nimm den naechste Subliste
% Helperfunktion fuer finden der Sublisten & Counter
   	 	
   	 	
/*
?- amount([abc,abc,abc,e,e,f],Result).
Result = [[abc, 3], [e, 2], [f, 1]].

?- amount([],Result).
Result = [].

?- amount([abc,abc,abc,e,e,f,abc],Result).
Result = [[e, 2], [f, 1], [abc, 4]].
*/
 
 
 %============== Aufgabe 3 ==============
 
 %----------------- 1. ------------------
% wordIndex(+Text,+Index,?Result)
wordIndex([],X,X).
wordIndex([H|T],Index,Result) :-
	findSub(H, Index,_)-> % Ist ein Eintrag vorhanden?
	wordIndex(T,Index,Result)     % Wenn ja, ueberpruefe naechstes Wort
	;
	length(Index,Indice),         % Neuer Index ist Listenlaenge + 1
	NIndice is Indice + 1,
	append(Index,[[H,NIndice]],NIndex), % Neues Element einfuegen
	wordIndex(T,NIndex,Result).         % Naechstes Element

/*
?- wordIndex([abc,abc,abc,e,e,f],[],R).
R = [[abc, 1], [e, 2], [f, 3]].

?- wordIndex([abc,abc,abc,e,e,f],[[c,1],[d,2]],R).
R = [[c, 1], [d, 2], [abc, 3], [e, 4], [f, 5]].
*/

 
 %----------------- 2. ------------------
 % searchIndice(+Element, +Index, -Result)
 searchIndice(Element,Index,Result):- findSub(Element,Index,Result).
% Entspricht findSub.
 
 /*
 ?- searchIndice(d,[[c,1],[d,2],[abc,3],[e,4],[f,5]],R).
R = 2.

?- searchIndice(a,[[c,1],[d,2],[abc,3],[e,4],[f,5]],R).
false.
 */
 
 %----------------- 3. ------------------

% wordToIndice(+Text,+Index,?Result)
wordToIndice(Text,Index,Result):- wordToIndiceH(Text,Index,[],Result).
% Wrapper


% wordToIndice(+Text,+Index,+WorkingList,?Result)
wordToIndiceH([],_,X,X):-!.
% Rekursionsabbruch

wordToIndiceH([H|T],Index,X,Result):-
	findSub(H,Index,Indice)->	          % Ueberprueft, ob ein Index Existiert
		append(X,[Indice],NX),			  % Fuege den Indice zum Ergebnis hinzu
		wordToIndiceH(T,Index,NX,Result)  % Gehe zum naechsten Wort
		;
		wordToIndiceH(T,Index,X,Result).  % Wenn nicht gehe zum naechsten Wort
 
 
 /*
 ?- wordToIndice([asdasd,c,d,abc,abc,abc,e,e,f],[[c, 1], [d, 2], [abc, 3], [e, 4], [f, 5]],S).
	S = [1, 2, 3, 3, 3, 4, 4, 5].
 */
 
 %============== Aufgabe 4 ==============
 
 %----------------- 1. ------------------
 %----------------- 2. ------------------
 %----------------- 3. ------------------
 %----------------- 4. ------------------