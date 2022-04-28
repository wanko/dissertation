% branch first on ab, with 2 different priorities
_heuristic(ab(O),false,(O #mod 2)+1) :- gate(O).

#show _heuristic/3.
#show ab/1.
