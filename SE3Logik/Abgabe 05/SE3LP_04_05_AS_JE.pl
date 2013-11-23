%:- dynamic      % ermoeglicht dynamische Veraenderung
%:- multifile   % ermoeglicht verteilte Definition in mehreren Files

%Abgabe 05 Arne Struck, Jan Esdonk
%Praesentationbereitschaft:

%---------Aufgabe 1-----------

%---------Aufgabe 2-----------
%1.:

%2.:

%---------Aufgabe 3-----------
%1.:

%find_all_unterprodukte(?KId,?PId)
find_all_unterprodukte(KId, PId) :-
    produkt(PId, KId, _, _, _, _, _);
    kategorie(UKId, _, KId),
    find_all_unterprodukte(UKId, PId).
    
verkaufspreis(KId,Jahr,Preis):-
	find_all_unterprodukte(KId, PId),
	verkauft(PId,Jahr,Preis,_).
	
avg_verkaufspreis(KId,Jahr,Avg_preis):-
	findall(Preis,verkaufspreis(KId,Jahr,Preis),Preisliste),
	sum_list(Preisliste, Preis_summe),
	length(Preisliste, Laenge),
	\+ Laenge == 0,
	Avg_preis is Preis_summe / Laenge.

%Beispiel:	
%avg_verkaufspreis(0,2012,Avg).
%Avg = 19.

%2.:



%---------Aufgabe 4-----------

%Beispiel Datenbank
ist_voraussetzung_fuer(anfang,beton_anmischen).
ist_voraussetzung_fuer(anfang,grundriss).
ist_voraussetzung_fuer(dachstuhl_errichten,dach_decken).
ist_voraussetzung_fuer(dach_decken,dauchausbau).
ist_voraussetzung_fuer(mauerbau,dachstuhl).
ist_voraussetzung_fuer(fundament,mauerbau).
ist_voraussetzung_fuer(mauerbau,fenster_einsetzen).
ist_voraussetzung_fuer(fenster_einsetzen,heizungs_installation).
ist_voraussetzung_fuer(grundriss,mauerbau).
ist_voraussetzung_fuer(beton_anmischen,fundament).
