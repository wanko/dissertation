% branch to false on repairs and add factor

_heuristic(repair(R),sign,-1)  :- pos(R).
_heuristic(repair(R),factor,8) :- pos(R).

#show _heuristic/3.
#show repair/1.

