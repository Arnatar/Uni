%:- dynamic	% ermoeglicht dynamische VeraWListerung
:- multifile(chat/2).	% ermoeglicht verteilte Definition in mehreren Files

% Abgabe 09 Arne Struck, Jan Esdonk
% Praesentationsbereitschaft



%============== Aufgabe 1 ==============
?-['read_sent'].
?-['bot_base'].

%chat(+Input,-Output)
chat(Input,Output):- rule(Input,Output).

% Mit dem Chatbot lassen sich einfache Dialoge über das aktuelle Befinden
% fuehren.
%
% Chatbeispiel:
%?- chat([Moin],Answer).
%Moin = hi,
%Answer = [hallo].
%
%?- chat([wer,bist,du,?],Answer).
%Answer = [ein, chatbot].
%
%?- chat([wie,geht,es,dir,?],Answer).
%Answer = [mir, geht, es, gut, und, dir] 
%
%?- chat([mir,geht,es,leider,schlecht],Answer).
%Answer = [das, ist, schade, warum, geht, es, dir, nicht, gut|...].
%
%?- chat([ich,habe,muscheln,gegessen],Answer).
%Answer = [warum, hast, du, muscheln, gegessen, ?] .
%
%?- chat([weil,sie,lecker,aussahen],Answer).
%Answer = [aha, wirklich, ?].
%
%?- chat([ja],Answer).
%Answer = [bist, du, dir, da, wirklich, sicher, ?].
%
%?- chat([jo],Answer).
%Answer = [dazu, weiss, ich, nichts].

%============== Aufgabe 2 ==============
?-['grafik'].
