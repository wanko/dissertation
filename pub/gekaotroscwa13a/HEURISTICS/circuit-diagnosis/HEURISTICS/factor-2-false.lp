% give ab factor 2, and on ab choose sign false
_heuristic(ab(O),sign,-1)  :- gate(O).
_heuristic(ab(O),factor,2) :- gate(O).

#show _heuristic/3.
#show ab/1.
