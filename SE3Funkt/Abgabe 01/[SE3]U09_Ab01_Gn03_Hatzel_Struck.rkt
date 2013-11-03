#lang racket

;Funktional SE3 Arne Struck, Hans Ole Hatzel myVersion

;Aufgabe 1.1: 
;Rad->Deg
(define
  (radToDeg rad)
  (/ (* rad 180) pi)
)

;Deg->Rad
(define
  (degToRad deg)
  (/ (* deg pi) 180)
)

;Aufgabe 1.2:
(define
  (my-acos a)
  (cond
    [(= a 0) (degToRad 90)]
    [(> a 0)
       (atan (/ (sqrt(- 1 (* a a))) a ))
    ]
    [(< a 0)
       (+ (atan (/ (sqrt (- 1 (* a a))) a )) (degToRad 180)) 
    ]
  )  
)

;Aufgabe 1.3:
(define
  (nmToKm nm)
  (* nm 1.852)
)

;Aufgabe 2.1: 
(define
  (distanceAB Ba La Bb Lb)
  (nmToKm
   (* 60
      (radToDeg
       (Dg Ba La Bb Lb)
      )
   )
  )
)

;ausgelagert, da später verwendbar
(define
  (Dg Ba La Bb Lb)
  (acos
   (+
    (* (sin (degToRad Ba)) (sin (degToRad Bb)))
    (*
     (cos (degToRad Ba))
     (cos (degToRad Bb))
     (cos(- (degToRad Lb) (degToRad)))
   )
  )
 )
)

(display "Aufgabe 2.1: \n \n")
(display "Oslo to Hongkong: ")
(distanceAB 59.93 10.75 22.20 114.10)

(display "\n")
(display "SF to Honululu: ")
(distanceAB 37.75 -122.45 21.32 -157.83)

(display "\n")
(display "Osterinsel to Lima: ")
(distanceAB -27.10 109.40 -12.10 77.05)

(display "\n \n \n")

(display "Aufgabe 2.2 \n \n")

;Aufgabe 2.2

(define
  (course Ba La Bb Lb)
  (define deg 
    (radToDeg
      (acos
        (/
          (-
            ; Winkel in Radiant

            (*
              (cos (Dg Ba La Bb Lb))
              (sin (degToRad Ba))
            )
          )
          (*
            (cos (degToRad Bb))
            (sin (Dg Ba La Bb Lb))
          )
        )
      )
    )
  )
  (if (> deg 180) (- 360 deg) deg)
)

(define
  (degToDirection grad)
  (cond
  [(< grad 11.25) "N"]
  [(< grad 33.75) "NNE"]
  [(< grad 56.25) "NE"]
  [(< grad 78.75) "ENE"]
  [(< grad 101.25) "E"]
  [(< grad 123.75) "ESE"]
  [(< grad 146.25) "SE"]
  [(< grad 168.75) "SSE"]
  [(< grad 191.25) "S"]
  [(< grad 213.75) "SSW"]
  [(< grad 236.25) "SW"]
  [(< grad 258.75) "WSW"]
  [(< grad 281.25) "W"]
  [(< grad 303.75) "WNW"]
  [(< grad 326.25) "NW"]
  [(< grad 348.75) "NNW"]
  ["N"]
  )
)
(define
  (directionToDeg dir)
  (cond
  [(eqv? dir "N") 0]
  [(eqv?  dir "NNE") 22.5]
  [(eqv?  dir "NE") 45.0]
  [(eqv?  dir "ENE") 67.5]
  [(eqv?  dir "E") 90.0]
  [(eqv?  dir "ESE") 112.5]
  [(eqv?  dir "SE") 135.0]
  [(eqv?  dir "SSE") 157.5]
  [(eqv?  dir "S") 180.0]
  [(eqv?  dir "SSW") 202.5]
  [(eqv?  dir "SW") 225.0]
  [(eqv?  dir "WSW") 247.5]
  [(eqv?  dir "W") 270.0]
  [(eqv?  dir "WNW") 292.5]
  [(eqv?  dir "NW") 315.0]
  [(eqv?  dir "NNW") 337.5]
  [error "Keine Himelsrichtung"]
  )
)

(course 250 10.75 22.20 114.10)