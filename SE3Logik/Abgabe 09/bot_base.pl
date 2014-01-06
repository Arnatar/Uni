:- dynamic(rule/2).
:- multifile(rule/2).

%Ein Pattern ist eine Liste von Wörter, in der auch Variablen vorkommen dürfen

%rule(+pattern, -answer)

rule([Hi|Restfilled],[hallo|Restunfilled]):-
	member(Hi,[hi,hallo,moin,morgen,nabend]),
	stop(S),
	delstop(Restfilled,S,Restunfilled),!.

% Pattern ohne Variablenbindung für einfache Antworten
rule([Reason|_],[aha,wirklich,?]):-
	member(Reason,[weil,da]),!.

rule([Ja|Rest],[bist,du,dir,da,wirklich,sicher,?]):-
	member(Ja,[ja]),!.
	
rule([Q|Rest],[ein,chatbot]):-
	 member(Q,[wer,was]),
	 member('?',Rest),
	 member(bist,Rest),!.

rule([Q|Rest],[mir,geht,es,gut,und,dir]):-
	member(Q,[wie]),
	member('geht',Rest),
	member('?',Rest),!.
	
rule(Answer,[bitteschoen]):-
	member('danke',Answer);
	member('dankeschoen',Answer),!.
	
rule([A|Rest],[das,ist,schoen]):-
	member('mir',Rest),
	member('geht',Rest),
	member('gut',Rest),!.
	
rule(Rest,[das,ist,schade,warum,geht,es,dir,nicht,gut,'?']):-
	member('mir',Rest),
	member('geht',Rest),
	member('schlecht',Rest),!.
	
rule([Q|Rest],[ich,bin,ein,paar,tage,alt,und,du,'?']):-
	member('wie',Q),
	member('alt',Rest),
	member('bist',Rest),
	member('?',Rest),!.

% Pattern mit Variablenbindung
rule([ich,habe,Food,gegessen],[warum,hast,du,Food,gegessen,'?']).

rule([ich,bin,Jahre,jahre,alt,_],[Jahre,'?',das,ist,alt,'!']).


% Antwort wenn keine passende Antwort vorhanden ist
rule([_|_],[dazu,weiss,ich,nichts]).


delstop([],_,[]).
delstop(Result,[],Result).
delstop(Text,[H|T],Result):-
    delete(Text, H, NText),
    delstop(NText, T, Result).


stop(
[der, die, das, den, dem, des, diese, dieser, diesem, deren, ein, eine, eines, einer, einen, einem, eines, kein, keine, keinen, keinem, keines, keiner,
ist, sind, sei, war, waren, haben, habe, hat, hatte, hatten, will, wollen, wollte, wollten, werden, wird, wurde, wurden, worden, machen, macht, mache, koennen, koennte, koennten,
soll, sollen, sollte, muessten, muesste, muesse,
und, oder,
da, weil,
er, sie, es, sich,
sein, seine, seinen, seinem, seiner, ihr, ihre, ihrer, ihren, ihrem, ihres,
weiter, weiteren, weitere, weiterer, weiteres,
einige, einigen, mehreren, mehrere, andere, anderen,
ob, dass, obwohl,
am, an, auf, aus, bei, beim, bis, durch, fuer, gegen, im, in, ins, mit, nahe, nach, seit, trotz, ueber, ums, unter, vom, von, vor, wegen, zu, zum, zur,
oft, auch, so, nur, noch, wieder, erst, sehr, dafuer, zurueck, einander, mehr, als, nicht, wie, wann, wo, dann, mal, vorbei,
null, eins, zwei, drei, vier, fuenf, sechs, sieben, acht, neun, zehn, elf, zwoelf,
ich,bin,mein,name,
'.', ',']).
