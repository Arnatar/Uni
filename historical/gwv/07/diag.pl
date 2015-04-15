%possible:
%prob(n1?, n2?, n3?, result?).
%gewünscht:
%prob(n1+, n2+, n3+, Result-).
%1 = Geräusch hörbar
%0 = Geräusch weg
%Ergebnisse in result-Liste repräsentieren mögliche Fehlerquellen. Diese zu gewichten bleibt dem Menschen überlassen.


prob(Starter, Pump, Engine, Result):-
	findall(OneResult ,
		(
		battery(Battery, Key, Regulation),
		key(Key, Battery, Regulation, Starter),
		starter(Starter, Key, Engine),
		pump(Pump, Tank, Regulation),
		filter(Filter, Pump),
		engine(Engine, Filter, Starter),
		constraints([Starter, Pump, Engine, Filter, Tank, Key, Regulation, Battery], 
					[starter, pump, engine, filter, tank, key, regulation, battery], 
					OneResult)
		), 
		AllResults),
	get_max_el(AllResults,Result).


constraints(List1, List2, Result):-
	constraints(List1, List2, Result, []).

constraints([],[], X, X).
constraints([H1|T1], [H2|T2], Result, Acc):- 
	(H1 = 0 ->  
		constraints(T1, T2, Result, [H2|Acc]); 
		constraints(T1, T2, Result, Acc)).

get_max_el(List, Result):-
	get_max_el(List, [], Result).

get_max_el([], X, X).

get_max_el([H|T], Temp, Result):-
	length(H,LH),
	length(Temp, LTemp),
	(LH < LTemp ->
		get_max_el(T, Temp, Result);
		get_max_el(T, H, Result)). 


%battery(battery?, key?, regulation?).
battery(0, 0, 0).
battery(0, 0, 1).
battery(0, 1, 0).
battery(0, 1, 1).
battery(1, 0, 0).
battery(1, 1, 0).
battery(1, 0, 1).
battery(1, 1, 1).

%key(key?, battery?, regulation?, starter?).
key(1, 1, 1, 1).
key(1, 1, 0, 1).
key(0, 1, 1, 1).
key(0, 1, 0, 1).
key(0, 0, 0, 1).
key(0, 1, 1, 0).
key(0, 1, 0, 0).
key(0, 0, 0, 0).


%starter(starter?, key?, engine?).
starter(0, 0, 0).
starter(0, 1, 0).
starter(1, 1, 0).
starter(0, 0, 1).
starter(0, 1, 1).
starter(1, 1, 1).


%pump(pump?, tank?, Regulation?).
pump(1, 1, 1).
pump(0, 1, 1).
pump(0, 1, 0).
pump(0, 0, 1).
pump(0, 0, 0).


%filter(filter?, pump?).
filter(1, 1).
filter(0, 1).
filter(0, 0).


%engine(engine?, filter?, starter?).
engine(1, 1, 1).
engine(0, 1, 1).
engine(0, 1, 0).
engine(0, 0, 1).
engine(0, 0, 0).
