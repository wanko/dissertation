% branch first on ab, with 16 different priorities
_heuristic(ab(O),false,(O #mod 16)+1) :- gate(O).


#show _heuristic/3.
#show ab/1.
