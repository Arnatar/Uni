:- dynamic(rule/2).
:- multifile(rule/2).

%rule(+pattern, -answer)

rule([Hi|Restfilled],[hallo|Restunfilled]):-
	member(Hi,[hi,hallo,moin,morgen,nabend]),
	stop(S),
	delstop(Restfilled,S,Restunfilled),!.

rule([Reason|_],[gut]):-
	member(Reason,[weil,da]),!.

rule([Reason|_],[gut]):-
	member(Reason,[weil,da]),!.

rule([Q|Rest],[deine,unterhaltung,ein,chatbot]):-
	 member(Q,[wer,was]),
	 member('?',Rest),
	 member(bist,Rest),!.



rule([_|_],[dazu,weiﬂ,ich,nichts]).


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
