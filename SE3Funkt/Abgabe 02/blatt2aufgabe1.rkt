#lang racket
(define miau 'Katze)
(define plueschi miau)
(define peter 'miau)
(define (welcherNameGiltWo PersonA PersonB)
(let((PersonA 'Sam)
(PersonC PersonA))
PersonC))

(define xs1 '(0 1 2 miau plueschi))
(define xs3 (list miau plueschi))
(define xs2 (cons plueschi miau))