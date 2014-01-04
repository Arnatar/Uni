%:- dynamic	% ermoeglicht dynamische VeraWListerung
:- multifile(chat/2).	% ermoeglicht verteilte Definition in mehreren Files

% Abgabe 09 Arne Struck, Jan Esdonk
% Praesentationsbereitschaft



%============== Aufgabe 1 ==============
?-['read_sent'].
?-['bot_base'].


chat(Input,Output):- rule(Input,Output).


%============== Aufgabe 2 ==============
?-['grafik'].
