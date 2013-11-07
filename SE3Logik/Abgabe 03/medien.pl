:- dynamic produkt/7, verkauft/4.        % ermoeglicht dynamische Veraenderung
%:- multifile produkt/7, verkauft/4.      % ermoeglicht verteilte Definition in mehreren Files

%Wir interpretieren aktuell als 2012 (letzte Verkaufsdaten)

%---------Aufgabe 2----------
%1.:
%finde_preis(+Kategorie,+Titel,+Autor,+Verlag,-Preis)
finde_preis(Kategorie,Titel,Autor,Verlag,Preis) :-
% Die PId zu dem beschriebenen Produkt wird gefunden
	produkt(PId,Kategorie,Titel,Autor,Verlag,_,_),
% Durch die PId und das "aktuelle" Jahr kan der Preis ermittelt werden
	verkauft(PId,2012,Preis,_).

%2.:
%letzter_verkauf(+Kategorie,+Titel,+Autor,+Verlag,-Jahr)
letzter_verkauf(Kategorie,Titel,Autor,Verlag,Jahr) :-
% PId erkennen
	produkt(PId,Kategorie,Titel,Autor,Verlag,_,_),
% Ein Verkaufsjahr wird festgelegt
	verkauft(PId,Jahr,_,_),
% wie in 2.2.6 andere Jahre mit dem Ursprungsjahr vergleichen.
	\+ (verkauft(PId,Jahr2,_,_),
	Jahr < Jahr2).

%3.: Aus dem Katalog genommen wird interpretiert, als "aktuell"
% nicht verkauft.
%veraltet(-PId,+Titel,-Lager)
veraltet(PId,Titel,Lager):-
% Produkt finden, dessen Lager gr��er als 0 ist.
	produkt(PId,_,Titel,_,_,_,Lager),
	Lager > 0,
% Produkt darf nicht 2012 verkauft worden sein.
	\+ (verkauft(PId,2012,_,_)).

%---------Aufgabe 3-----------
%1.:
%produktAnzahl(+Kategorie,-Ergebnis)
produktAnzahl(Kategorie,Ergebnis):-
% Alle Produkte der Kategorie in einer Liste sammeln
	findall(Kategorie,produkt(_,Kategorie,_,_,_,_,_),List),
% L�nge der Liste ausgeben
	length(List,Ergebnis).


%2.:
k_Verkauft(Kategorie,Ergebnis):-
	produkt(PId,Kategorie,_,_,_,_,_),
	findall(Anzahl,verkauft(PId,_,_,Anzahl),List),
	sum_list(List,Ergebnis).

kategorieVerkauft(Kategorie,Ergebnis):-
	produkt(PId,Kategorie,_,_,_,_,_),
	findall(Anzahl,verkauft(PId,_,_,Anzahl),List),
	sum_list(List,Ergebnis).

sum_list([],0).
sum_list([Head | Tail], Total):-
    sum_list(Tail, Sum1),
    Total is Head + Sum1.


%3.:
%
gewinn(Jahr,PId,Ergebnis):-
	Jahr2 is Jahr - 1,
	verkauft(PId,Jahr,Preis1,Anzahl1),
	verkauft(PId,Jahr2,Preis2,Anzahl2),
	Ergebnis is (Preis2 * Anzahl2)-(Preis1 * Anzahl1).


% produkt(PId,Kategorie,Titel,Autor,Verlag,Jahr,Lagerbestand).
produkt(12345,buch,sonnenuntergang,hoffmann_susanne,meister,2005,23).
produkt(12346,buch,hoffnung,sand_molly,kasper,2004,319).
produkt(12347,buch,winterzeit,wolf_michael,meister,2002,204).
produkt(12348,buch,blutrache,wolf_michael,meister,2010,0).
produkt(12349,buch,winterzeit,wolf_michael,meister,2009,100).

produkt(23456,ebuch,sonnenuntergang,hoffmann_susanne,meister,2009,1).
produkt(23457,ebuch,spuren_im_schnee,wolf_michael,meister,2009,1).
produkt(23458,ebuch,blutrache,wolf_michael,meister,2010,1).

produkt(34567,hoerbuch,hoffnung,sand_molly,audio,2008,51).
produkt(34568,hoerbuch,winterzeit,wolf_michael,audio,2006,16).


% verkauft(PId,Jahr,Preis,Anzahl).
verkauft(12345,2006,39,71).
verkauft(12345,2007,39,23).
verkauft(12345,2008,39,11).
verkauft(12345,2009,29,15).
verkauft(12345,2010,29,17).
verkauft(12345,2011,29,9).
verkauft(12345,2012,23,8).
verkauft(12346,2005,24,391).
verkauft(12346,2006,24,129).
verkauft(12346,2007,24,270).
verkauft(12346,2008,24,350).
verkauft(12346,2009,24,168).
verkauft(12346,2010,24,89).
verkauft(12346,2011,24,30).
verkauft(12346,2012,24,2).
verkauft(12347,2002,29,430).
verkauft(12347,2003,34,380).
verkauft(12347,2004,39,137).
verkauft(12347,2005,39,24).
verkauft(12347,2006,39,0).
verkauft(12347,2007,39,0).
verkauft(12347,2008,29,0).
verkauft(12347,2009,29,0).
verkauft(12347,2010,29,0).
verkauft(12347,2011,19,0).
verkauft(12347,2012,9,0).
verkauft(12348,2010,29,412).
verkauft(12348,2011,29,257).
verkauft(12348,2012,29,12).
verkauft(12349,2009,17,213).
verkauft(12349,2010,19,45).
verkauft(12349,2011,19,137).
verkauft(12349,2012,14,83).

verkauft(23456,2009,13,0).
verkauft(23456,2010,13,1).
verkauft(23457,2009,13,1).
verkauft(23457,2010,13,2).
verkauft(23457,2010,13,1).
verkauft(23457,2010,2,70).
verkauft(23458,2010,13,12).
verkauft(23458,2011,13,21).
verkauft(23458,2012,13,13).

verkauft(34567,2008,21,99).
verkauft(34567,2009,21,124).
verkauft(34567,2010,21,89).
verkauft(34567,2011,21,52).
verkauft(34567,2012,21,39).
verkauft(34568,2006,16,4).
verkauft(34568,2007,16,28).
verkauft(34568,2008,16,3).
verkauft(34568,2009,3,112).
verkauft(34568,2010,3,89).
verkauft(34568,2011,3,75).
verkauft(34568,2012,3,23).



















