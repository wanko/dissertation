% branch first on ab, with 8 different priorities
_heuristic(ab(O),false,(O #mod 8)+1) :- gate(O).

#show _heuristic/3.
#show ab/1.
