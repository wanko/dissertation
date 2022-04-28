% give ab factor 16, and on b hoose sign false
_heuristic(ab(O),sign,-1)   :- gate(O).
_heuristic(ab(O),factor,16) :- gate(O).

#show _heuristic/3.
#show ab/1.
