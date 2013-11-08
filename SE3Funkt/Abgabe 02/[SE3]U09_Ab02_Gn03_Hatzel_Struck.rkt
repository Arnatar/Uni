#lang racket
; Aufgabe 1:

; 1: 
; in: miau
; out: 'Katze
; Die Variable miau hat den Wert 'Katze wobei 'Katze ein Symbol ist. 
; Durch ' wird zu erkennengegben das es sich nicht um den Funktionsaufruf 
; Katze sondern um ein Symbol handelt.
;
; 2: 
; in: plueschi
; out: 'Katze
; Die Variable plueschi verweist auf die Variable miau somit ist die Ausgabe 
; der von 1 enstpechend.
;
; 3:
; in: peter
; out: 'miau
; Annalog zu 1 wird 'miau ausgegeben.
;
; 4:
; in: (quote plueschi)
; out: 'plueschi
; (quote a) ist gleichbedeutend mit 'a, somit ist (quote plueschi) 
; die Anforderung ein Symbol zu erstellen.
;
; 5:
; in: (eval peter)
; out:'Katze
; Hier wird zunächst wie in 3 'miau gelesen allerdings wird die Bedeutung des 
; Symbols 'miau durch den eval Aufruf beachtet und somit wird der Wert den
; miau zugewiesen bekommen hat ausgegeben.
;
; 6:
; in: (eval plueschi)
; out: Katze: undefined
; plueschi verweist auf miau, findet da 'Katze und versucht das Literal 
; auszuwertern. Katze ist allerdings nicht definiert.
;
; 7.:
; in: (eval 'plueschi)
; out: 'Katze
; Nun wird plueschi ausgewertet und findet auf dem in 6. beschriebenen Weg 
; 'Katze
;
; 8.:
; in: (welcherNameGiltWo 'Ich 'Du)
; out: 'Ich
; let-Ausdrücke bestehen in ihrem Rumpf aus (id expr)-Paaren. Woraus folgt, 
; dass für die Berechnung von PersonC (Ausgabe) nur das 2. Paar relevant ist.
; Deswegen wird immer PersonA ausgegeben.
;
; 9.: (Nochmal über die Ausdruckweise schauen)
; in: (cdddr xs1)
; out: '(miau plueschi)
; (cdddr '(n-Tupel)) entfernt aus dem Symbol die ersten 3 Elemente und gibt
; den Rest als Literal zurück.
;
; 10.:
; in: (cdr xs2)
; out: 'Katze
; cdr addressiert das zweite Element eines allozierten Paares. cons alloziert 
; 2 Elemente zu einem Paar, somit wir miau addressiert, welches als 'Katze
; definiert wurde.
;
; 11.:
; in: (cdr xs3)
; out: '(Katze)
; Wie bei 10. wird auch hier das zweite Element addressiert, allerdings hier 
; einer Liste. plueschi bildet auf miau ab, daraus resultiert Katze, die 
; Klammern resultieren aus der Listendarstellung.
;
; 12.:
; in: (eval (sin 3))
; out: 0.1411200080598672
; Die Funktion sin mit dem Argument 3 wird ausgeführt.
;
; 13.:
; in: (eval '(welcherNameGiltWo 'peter 'plueschi))
; out: 'peter
; Analog zu 7. wird das Literal '(welcherNameGiltWo 'peter 'plueschi) als 
; Anweisung betrachtet, welche (analog zu 8.) 'peter zurückgibt.
;
; 14.:
; in: (eval (welcherNameGiltWo 'peter 'plueschi))
; out: 'miau
; Hier wird durch eval 'peter nicht mehr als Literal interpretiert und somit
; wird die Definition von peter ausgegeben.


; Aufgabe 2.1:
(define (fac n)
  (if (= n 0) 
    1
    (* n (fac (- n 1)))
  )
)

(fac 3)

; Aufgabe 2.2:
(define (power r n)
  (if (= n 0) 
    1
    (if (odd? n)
    (*
      (power r (- n 1))
      r
    )
    (sqr
      (power r (/ n 2))
    )
    )
  )
)

(power 2.35 5)

; Aufgabe 2.3:

(define limit (expt 10 1000)) ;Hier wird das Limit gesetzt welches die Genauigkeit bestimmt.
;Zwecks optimierung wird das Limit als Konstante zuvor berechnet sodass es nicht in jedem rekursiven Aufruf neu berechnet wird.
(define (eul n)
  (if (< (fac n) limit) 
    (+
      (/ 1 (fac n))
      (eul (+ n 1))
    )
    0
  )
)

;
(*(eul 0) (expt 10 1001))


; Aufgabe 2.4:

(define (leibnizRow n)
  (if (= n 0)
    1
    (+
      (/ 
        (expt -1 n)
          (+ 
          (* 2 n) 
          1
        )
      )
      (leibnizRow(- n 1))
    )  
  )
)

;Die Lebniz-Reihe nähert sich leider nur sehr langsam pi an, daher sind nur die
;ersten stellen identisch.
(define (pistart n)
  (*(leibnizRow (- n 1)) 4 (expt 10 1001))
)

(pistart 5000)


;Aufgabe 3:

(define (type-of n)
  (cond
    [(boolean? n) 'boolean]
    [(pair? n) 'pair]
    [(symbol? n) 'symbol]
    [(number? n) 'number]
    [(char? n) 'char]
    [(string? n) 'string]
    [(vector? n) 'vector]
    [(procedure? n) 'procedure]
    [else 'noneOfThem]
  )
)

;Tests:
(type-of (+ 3 7))
;out: 'number 
;da (+ 3 7) zu erst zu number auswertet.

(type-of type-of)
;out: 'procedure
;da es sich bei type of um eine procedure handelt.

(type-of (type-of type-of))
;out: 'symbol
;Das Ergebnis von (type-of type-of), welches 'procedure ist wird untersucht und
;bei 'procedure handelt es sich um ein symbol

(type-of (string-ref "Schneewitchen_und_die_7_Zwerge" 2))
;out: 'char
;string-ref gibt ein char an der Position x (hier 2) zurück, es dürfte
;sich also um die Untersuchung von #\h handeln.

(type-of (lambda (x) x))
;out: 'procedure
;lambda erstellt eine Funktion, welche als procedure erkannt wird (ich hätte 
;mit 'noneOfThem gerechnet).

(define (id z) z)
(type-of (id cos))
;out: 'procedure
;id ruft eine weitere Funktion, die cos-Funktion auf.

(type-of '(1 2 3))
;out: 'pair
;wird korrekt erkannt.

(type-of '())
;out: 'noneOfThem
;'() ist ein leeres "Symbol", daher hat es keinen Typ.