#!/usr/bin/env python3

punkte_liste = [
        (200,170),
        (310,300),
        (325,400),
        (240,240)
        ]

schnitt = sum(punkte / gesamt for punkte, gesamt in punkte_liste) / len(punkte_liste)
print('{}% insgesamt'.format((round(schnitt,2))*100))
