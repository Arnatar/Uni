%Abgabe 1 Arne Struck, Jan Esdonk (ich kenne leider nur die Kennung, es
% ist möglich, dass der Name noch weiter geht, leider erreiche ich ihn
% zur Zeit nicht).
%
% Zum Verständniss: unter den Eingaben sind die Ausgaben und etwaige
% Erläuterungen als Kommentare zu finden.
%
%Aufgabe 1
%
%1.1:
consult('familie.pl').
%familie.pl compiled 0,00 sec, 15 clauses
%true.
%
[familie].
%führt wie erwartet zum gleichen Ergebnis
%
% da fehlerhaft ist das folgende Kommando auskommentiert:
%[C:/Users/Arne/Documents/Prolog/familie.pl].
% ERROR: Syntax error: Operator expected
% ERROR: [/
% ERROR: ** here **
% ERROR: home/arnatar/uni/se3Logik/familie] .
%
% Dies lässt vermuten, dass / als Operator interpretiert wird, dafür
% werden die '' vermutlich verwendet, dies würde auch die ' in
% consult('familie.pl'). erklären, da der . als Programmabbruch
% interpretiert werden könnte.
%
% 1.2:
listing.
%
%:- thread_local thread_message_hook/3.
%:- dynamic thread_message_hook/3.
%:- volatile thread_message_hook/3.
%
%
%:- dynamic vater_von/2.
%
%vater_von(otto, hans).
%vater_von(otto, helga).
%vater_von(gerd, otto).
%vater_von(johannes, klaus).
%vater_von(johannes, andrea).
%vater_von(walter, barbara).
%vater_von(walter, magdalena).
%
%:- dynamic mutter_von/2.
%
%mutter_von(marie, hans).
%mutter_von(marie, helga).
%mutter_von(julia, otto).
%mutter_von(barbara, klaus).
%mutter_von(barbara, andrea).
%mutter_von(charlotte, barbara).
%mutter_von(charlotte, magdalena).
%true.
%
listing(mutter_von).
%:- dynamic mutter_von/2.
%
% mutter_von(marie, hans).
% mutter_von(marie, helga).
% mutter_von(julia, otto).
% mutter_von(barbara, klaus).
% mutter_von(barbara, andrea).
% mutter_von(charlotte, barbara).
% mutter_von(charlotte, magdalena).
% true.
%
% listing/0 gibt also den Gesamtzustand wieder, während listing/1 den
% Zustand der definierten Funktion zurückgegeben wird. Es funktioniert
% also wie beschrieben.
%
%
%1.3:
%
assert(mutter_von(susanne, arne)).
%true.
%
assertz(mutter_von(anni, lea)).
%true.
%
asserta(mutter_von(baerbel, sven)).
%true.
%
listing(mutter_von).
%:- dynamic mutter_von/2.
%
%mutter_von(baerbel, sven).
%mutter_von(marie, hans).
%mutter_von(marie, helga).
%mutter_von(julia, otto).
%mutter_von(barbara, klaus).
%mutter_von(barbara, andrea).
%mutter_von(charlotte, barbara).
%mutter_von(charlotte, magdalena).
%mutter_von(susanne, arne).
%mutter_von(anni, lea).
%
%true.
%
% Exemplarisch (es wurde mehr getestet) ist hier zu sehen, dass assert
% und assertz Die neuen Fakten am Ende der Liste der definierenden
% Klauseln einfügt, asserta jedoch am Anfang. Der genaue Unterschied
% zwischen assert und asserta blieb uns jedoch verborgen.
%
% 2.1:
%
% Im folgenden lassen wir das Programm für sich sprechen und
% kommentieren nur nicht auf den ersten Blick ersichtliche Antworten:
%
%a)
vater_von(johannes, andrea).
%true.
%
%b)
mutter_von(helga,charlotte).
%false.
%
%c)
vater_von(Vater,magdalena).
%Vater = walter.
%
%d)
vater_von(Vater,walter).
%false.
%
%Walters Vater ist nicht in den Klauseln zu finden.
%
%e)
vater_von(otto,Kind).
%Kind = hans ;
%Kind = helga.
%
%Also hat Otto die Kinder Hans und Helga.
%
%f)
% Im folgenden sind die Elemente der zusammengehörigen Paare durch
% Kommata getrennt, die Paare durch Symikolons.
%
vater_von(Vater,Kind).
%Vater = otto,
%Kind = hans ;
%Vater = otto,
%Kind = helga ;
%Vater = gerd,
%Kind = otto ;
%Vater = johannes,
%Kind = klaus ;
%Vater = johannes,
%Kind = andrea ;
%Vater = walter,
%Kind = barbara ;
%Vater = walter,
%Kind = magdalena.

mutter_von(Mutter,Kind).
%Mutter = marie,
%Kind = hans ;
%Mutter = marie,
%Kind = helga ;
%Mutter = julia,
%Kind = otto ;
%Mutter = barbara,
%Kind = klaus ;
%Mutter = barbara,
%Kind = andrea ;
%Mutter = charlotte,
%Kind = barbara ;
%Mutter = charlotte,
%Kind = magdalena.
%
%
%g)
\+ vater_von(klaus, Kind).
%true.
%
% Die Negation der Aussage Klaus ist der Vater von Kind führt zu keiner
% wahren Belegung, also ist Klaus kinderlos.
%
%
%h)
\+ vater_von(otto, Kind).
%false.
%
%Wie oben, blos dass Otto Kinder hat.
%
%i)
\+ \+ vater_von(otto, Kind).
%true.
%
% Um hier einen boolean zu erhalten, muss die Aussage aus h)
% herangezogen werden. Allerdings ist die Aussage aus h) natürlich
% verneint, also wird eine zweite Negation benötigt.
%
% 2.2:
%
mutter_von(charlotte, Kind),(mutter_von(Kind, Enkel);vater_von(Kind, Enkel)).
%Kind = barbara,
%Enkel = klaus ;
%Kind = barbara,
%Enkel = andrea ;
%false.
%
% Die Definition eines Enkels ist, das Kind eines Kindes. Also muss
% Charlotte als erstes auf Kinder untersucht werden. Gefundene Kinder
% müssen nun auf eigene Kinder untersucht werden. Da das Geschlecht von
% Charlottes Kindern ungeklärt ist(für den Ausdruck), muss die
% Enkelsuche aus den veroderten (;) Teilen mutter_von(Kind, Enkel)
% und vater_von(Kind, Enkel) bestehen. Nun muss Kind noch das Kind von
% Charlotte sein, also muss mutter_von(charlotte, Kind) mit dem anderen
% Teilausdruck verundet (,) werden.
%
% 2.3:
% Vorweggenommen sei, dass im Gegensatz zum Skript nur erfolgreiche
% Aufrufe gelistet werden, es sei denn es existieren keine, dann wird
% der Abbruch gezeigt.
% Da es um grundsätzlich ähnliche Abläufe geht,
% bleiben wir bei Beispielen.
%
vater_von(johannes, andrea).
%   Call: (6) vater_von(johannes, andrea) ? creep
%   Exit: (6) vater_von(johannes, andrea) ? creep
%true.
%
% Es erfolgt ein Aufruf von vater_von mit den Argumenten johannes und
% andrea.Im zweiten Schritt wird gezeigt, dass eine Übereinstimmung
% gefunden wurde, es wird also zu true ausgewertet.
%
vater_von(Vater,walter).
%   Call: (6) vater_von(_G1511, walter) ? creep
%   Fail: (6) vater_von(_G1511, walter) ? creep
%false.
%
% Hier erfolgt ähnliches, bis auf die Auswertung und dass eine Variable
% (welche hier in ihrer Repräsentation dargestellt wird) verwendet wird.
%
%
vater_von(Vater,magdalena).
%   Call: (6) vater_von(_G1341, magdalena) ? creep
%   Exit: (6) vater_von(walter, magdalena) ? creep
%Vater = walter.
%
%
%Vielleicht noch interessant:
%
vater_von(otto, Kind).
%   Call: (6) vater_von(otto, _G1506) ? creep
%   Exit: (6) vater_von(otto, hans) ? creep
%Kind = hans ;
%   Redo: (6) vater_von(otto, _G1506) ? creep
%   Exit: (6) vater_von(otto, helga) ? creep
%Kind = helga.
%
% Als eine zulässige Belegung gefunden wurde, wird die Prozedur noch
% einmal von vorne gestartet.







