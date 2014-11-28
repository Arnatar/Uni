%possible:
%prob(n1?, n2?, n3?, starter?, pump?, engine?, filter?, tank?, ignation_key?, regulation?, battery?).
%gewünscht:
%prob(n1+, n2+, n3+, starter-, pump-, engine-, filter-, tank-, ignation_key-, regulation-, battery-).
%true == Geräusch hörbar / Bauteil funktioniert
%false == Geräusch weg / Bauteil potentiell defekt

%bsp-aufruf
%prob(1, 1, 1, Result).


prob(1, 1, 1, []).

%n1
prob(1, 0, 0, Result):-
	Starter = 1,
	battery(Battery, Key, Regulation),
	starter(Starter, Key, Engine),
	pump(Pump, Tank),
	filter(Filter, Pump, Regulation),
	engine(Engine, Filter, Starter),
	constraints([Starter, Pump, Engine, Filter, Tank, Key, Regulation, Battery], 
				[starter, pump, engine, filter, tank, key, regulation, battery], 
				Result).

%n2
prob(0, 1, 0, Result):-
	Pump = 1,
	battery(Battery, Key, Regulation),
	starter(Starter, Key, Engine),
	pump(Pump, Tank),
	filter(Filter, Pump, Regulation),
	engine(Engine, Filter, Starter),
	constraints([Starter, Pump, Engine, Filter, Tank, Key, Regulation, Battery], 
				[starter, pump, engine, filter, tank, key, regulation, battery], 
				Result).

%n1 & n2
prob(1, 1, 0, Result):-
	Starter = 1,
	Pump = 1,
	battery(Battery, Key, Regulation),
	starter(Starter, Key, Engine),
	pump(Pump, Tank),
	filter(Filter, Pump, Regulation),
	engine(Engine, Filter, Starter),
	constraints([Starter, Pump, Engine, Filter, Tank, Key, Regulation, Battery], 
				[starter, pump, engine, filter, tank, key, regulation, battery], 
				Result).



%keine Geräusche =>  
prob(0, 0, 0, Result):-
	battery(Battery, Key, Regulation),
	starter(Starter, Key, Engine),
	pump(Pump, Tank),
	filter(Filter, Pump, Regulation),
	engine(Engine, Filter, Starter),
	constraints([Starter, Pump, Engine, Filter, Tank, Key, Regulation, Battery], 
				[starter, pump, engine, filter, tank, key, regulation, battery], 
				Result).


constraints(List1, List2, Result):-
	constraints(List1, List2, Result, []).

constraints([],[], X, X).
constraints([H1|T1], [H2|T2], Result, Acc):- 
	(H1 = 0 ->  constraints(T1, T2, Result, [H2|Acc]); 
				constraints(T1, T2, Result, Acc)).

%battery(battery?, key?, regulation?).
battery(0, 0, 0).
battery(0, 0, 1).
battery(0, 1, 0).
battery(0, 1, 1).
battery(1, 0, 0).
battery(1, 1, 0).
battery(1, 0, 1).
battery(1, 1, 1).


%starter(starter?, key?, engine?).
starter(0, 0, 0).
starter(1, 0, 0).
starter(0, 1, 0).
starter(1, 1, 0).
starter(0, 0, 1).
starter(1, 0, 1).
starter(0, 1, 1).
starter(1, 1, 1).


%pump(pump?, tank?, Regulation?).
pump(1, 1, 1).
pump(0, 1, 1).
pump(0, 0, 1).
pump(0, 1, 0).
pump(0, 0, 0).


%filter(filter?, pump?, Regulation?).
filter(1, 1).
filter(0, 1).
filter(0, 0).


%engine(engine?, filter?, starter?).
engine(1, 1, 1).
engine(0, 1, 1).
engine(0, 1, 0).
engine(0, 0, 1).
engine(0, 0, 0).
