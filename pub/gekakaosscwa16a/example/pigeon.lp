#const p=6.
#const h=p-1.
pigeon(1..p).
hole(1..h).
1 { place(P,H) : hole(H) } 1 :- pigeon(P).

