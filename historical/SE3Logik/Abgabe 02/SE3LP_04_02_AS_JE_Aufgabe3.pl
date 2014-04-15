/*
Aufgabe 3
Das Datenmodell besteht aus Fächern, Schälern, Noten und Zeugnissen.
Die Noten stehen in einer Relation zu den Zeugnissen und Fächern. Die
Zeugnisse wiederum stehen in einer Relation zu den vorhanden Schülern.
Diese zusätzliche Relation ist nötig um einem Schüler mehrer
Zeugnisse zuordnen zu können (für mehrere Schuljahre). Über diese
Datenbank lassen sich nun Anfragen stellen um etwas über die Zeugnisse
der Schüler zu erfahren.
*/

% fach(fachName, fach_note)
fach(erdkunde).
fach(englisch).
fach(deutsch).
fach(mathe).
fach(sport).
fach(physik).

% schueler(schuelerId)
schueler(1).
schueler(2).
schueler(3).
schueler(4).
schueler(5).

% note(zeugnisId, fachName, fach_note)
note(1, erdkunde, 2).
note(1, englisch, 3).
note(1, deutsch, 2).
note(1, mathe, 1).
note(1, sport, 4).
note(1, physik, 2).

note(2, erdkunde, 3).
note(2, englisch, 1).
note(2, deutsch, 4).
note(2, mathe, 2).
note(2, sport, 2).
note(2, physik, 1).

note(3, erdkunde, 1).
note(3, englisch, 2).
note(3, deutsch, 3).
note(3, mathe, 4).
note(3, sport, 5).
note(3, physik, 4).

note(4, erdkunde, 3).
note(4, englisch, 3).
note(4, deutsch, 4).
note(4, mathe, 4).
note(4, sport, 3).
note(4, physik, 2).

note(5, erdkunde, 1).
note(5, englisch, 2).
note(5, deutsch, 1).
note(5, mathe, 2).
note(5, sport, 3).
note(5, physik, 1).

% zeugnis(zeugnisId, schuelerId)
zeugnis(1, 1).
zeugnis(2, 2).
zeugnis(3, 3).
zeugnis(4, 4).
zeugnis(5, 5).
