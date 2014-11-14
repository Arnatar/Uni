# Sequentieller Lauf
Sequentiell, ohne `-fopenmp`:

`./partdiff-seq 1 2 512 2 2 200` braucht **120.29s**.

1 Thread, mit `-fopenmp`:
`./partdiff-seq 1 2 512 2 2 200` braucht **120.65s**.

12 Threads, mit `-fopenmp`:
`./partdiff-seq 1 2 512 2 2 200` braucht **14.9s**.

Mit verschiedenen Schedulings, jw 12 Threads.

`schedule(dynamic, 1)`:

`./partdiff-seq 1 2 512 2 2 200` braucht **11.39s**. Speedup zu ohne OMP: **10.59**. The winner! :)

`schedule(dynamic, 4)`:

`./partdiff-seq 1 2 512 2 2 200` braucht **14.2s**. Speedup zu ohne OMP: **~8.5**.

`schedule(guided)`:

`./partdiff-seq 1 2 512 2 2 200` braucht **12.3s**. Speedup zu ohne OMP: **9.8**.

`schedule(static, 1)`:
`./partdiff-seq 1 2 512 2 2 200` braucht **14.1s**.

`schedule(static, 2)`:
`./partdiff-seq 1 2 512 2 2 200` braucht **14.7s**.

`schedule(static, 16)`:
`./partdiff-seq 1 2 512 2 2 200` braucht **14.57s**.



Zeit benötigt: 2h. Fehlersuche? Ja, zuerst haben wir die simple interference function geenommen und dadurch nur ein Speedup von 4 erreicht.
