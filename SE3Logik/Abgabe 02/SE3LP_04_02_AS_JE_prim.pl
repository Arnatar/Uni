  %Abgabe 02 Arne Struck, Jan Esdonk

%Präsentationsbereitschaft: ????


%----------Aufgabe 1-------------
/*
1.P1 ist der Großvater von P2

2.P1 ist ein (Halb-)geschwisterkind von P2. Halb deshalb, weil die
Mutter nicht geklärt ist.

3.P2 ist der Onkel von P1.

4.P2 ist der Schwager von P1.

5.P2 ist ein Halbgeschwisterkind von P1 (sie haben unterschiedliche
Väter).
*/




%----------Aufgabe 2--------------

%?-[SE3LP_04_02_AS_JE_medien].

%1.:
/*
Gesucht sind die PId, der Titel und der Autor der Produkte,
welche in der Kategorie hoerbuch zu finden sind und als
Erscheinungsjahr 2012 aufweisen.

?- produkt(PId,hoerbuch,Titel,Autor,_,2012,_).
false.

?- asserta(produkt(34569,hoerbuch,ruf_des_cthulhu,h_p_lovecraft,audio,2012,30)).
true.

?- produkt(PId,hoerbuch,Titel,Autor,_,2012,_).PId = 34569,
Titel = ruf_des_cthulhu,
Autor = h_p_lovecraft.
*/

%2.:
/*
Gesucht ist eine Belegung von produkt/7 für die gilt, dass sie
ein dvdFilm und einen Lagerzähler (Anzahl) besitzt, der größer
als 100 ist.

?- produkt(PId,dvdFilm,Titel,Autor,_,_,Anzahl),Anzahl>100.
false.

?- asserta(produkt(45672,dvdFilm,filmRichtig,autorRichtig,produzentRichtig,2013,101)).
True.

?- produkt(PId,dvdFilm,Titel,Autor,_,_,Anzahl),Anzahl>100.
PId = 45672,
Titel = filmRichtig,
Autor = autorRichtig,
Anzahl = 101.
*/

%3.:
/*
Es muss eine ProduktID zu einem Buch gefunden werden, nun
müssen Preise für 2011 und 2012 durch verkauft/4 herausgefunden
und danach verglichen werden.

?- produkt(PId,buch,Titel,_,_,_,_),verkauft(PId,2012,P2012,_),verkauft(PId,2011,P2011,_),P2012<P2011.
PId = 12345,
Titel = sonnenuntergang,
P2012 = 23,
P2011 = 29 ;
PId = 12347,
Titel = winterzeit,
P2012 = 9,
P2011 = 19 ;
PId = 12349,
Titel = winterzeit,
P2012 = 14,
P2011 = 19 ;
false.
*/

%4.

/*
Gesucht ist ein Abgleich der Autoren und Titel der buecher und ebuecher.

?-produkt(PIdBuch,buch,Titel,Autor,_,_,_),produkt(Ebuch,ebuch,Titel,Autor,_,_,_).
PIdBuch = 12345,
Titel = sonnenuntergang,
Autor = hoffmann_susanne,
Ebuch = 23456 ;
PIdBuch = 12348,
Titel = blutrache,
Autor = wolf_michael,
Ebuch = 23458 ;
false.

*/

%5.:

/*
Gesucht sind die Autoren,Titel der buecher, welche keine
Entsprechung in den hoerbuechern haben.

?- produkt(PIdBuch,buch,Titel,Autor,_,_,_),(\+ produkt(PIdebuch,ebuch,Titel,Autor,_,_,_)).
PIdBuch = 12346,
Titel = hoffnung,
Autor = sand_molly ;
PIdBuch = 12347,
Titel = winterzeit,
Autor = wolf_michael ;
PIdBuch = 12349,
Titel = winterzeit,
Autor = wolf_michael.
*/

%6.:

/*
Als erstes müssen die PIds aller buecher gefunden werden, dann werden
die Verkaufsstatistiken (verkauft) für die PIds im Zeitraum von 2012
herausgefunden werden, die Anzahl der Verkäufe werden, den PIds
zugeordnet in eine neu geschaffene Datenbasis (anzahl(PId,Anzahl))
eingelesen. Diese Datenbasis wird dann mit sich selber abgeglichen und
jeder Eintrag, bis auf den größten wird gelöscht. Darauf wird dieser
größte ausgegeben und auch aus der Basis gelöscht, damit diese für
weitere bearbeitung zur Verfügung steht.

?- produkt(PId,buch,_,_,_,_,_),verkauft(PId,2012,_,Anzahl),
assertz(anzahl(PId,Anzahl));
anzahl(_,Anzahl1),anzahl(_,Anzahl2),Anzahl1\=Anzahl2,maxVerkauf(Anzahl1,Anzahl2);
anzahl(ErgebnisPId,ErgebnisAnzahl),retract(anzahl(_,_)).

PId = 12345, Anzahl = 8 ;
PId = 12346, Anzahl = 2 ;
PId = 12347, Anzahl = 0 ;
PId = 12348, Anzahl = 12 ;
PId = 12349, Anzahl = 83 ;
Anzahl1 = 8, Anzahl2 = 2 ;
Anzahl1 = 8, Anzahl2 = 0 ;
Anzahl1 = 8, Anzahl2 = 12 ;
Anzahl1 = 12, Anzahl2 = 83 ;
ErgebnisPId = 12349, ErgebnisAnzahl = 83.

*/

%-----------Aufgabe 3-----------
/*
?-[SE3LP_04_02_AS_JE_Aufgabe3]

Beispielanfragen:

Alle Schüler Ids die in dem Fach Sport mit einer 2 abgeschnitten haben:
note(ZeugnisId, sport, 2), zeugnis(ZeugnisId, SchuelerId).

Alle Noten des Faches Englisch:
note(ZeugnisId, englisch, Note).

Alle Noten des Schülers 3:
zeugnis(ZeugnisId, 3), note(ZeugnisId, Fach, Note).

Alle Schüler die mit 2 oder besser in Englisch abgeschnitten haben:
note(ZeugnisId, englisch, Note), Note =< 2, zeugnis(ZeugnisId, SchuelerId).

Alle Zeugnisse des Schülers 2:
zeugnis(ZeugnisId, 2).

*/



%-----------Aufgabe 4-----------


/*
Prädikat
Ein Prädikat ist eine Menge von Klauseln, welche den selben Namen haben.

Beispiel:
uni(hamburg).
uni(bremen).

Diese Klauseln gehören zum Prädikat uni

Klausel
Klauseln können Regeln und Fakten definieren. Diese Klauseln bilden das
Prolog Programm, welches einen Sachverhalt beschreibt.

Beispiel:
uni(hamburg).
uni(bremen).
austausch_moeglich(X, Y):- uni(X), uni(y).


Struktur
Eine Struktur hat einen Namen und mindestens ein Element. Die Elemente
sind jeweils Terme. Eine häufig verwendete Struktur ist die Liste.

Beispiel:
se3(uni('hamburg'), studiengang('informatik'))
*/















