

_heuristic(put(T,X), mod, S - T) :- disk(X;X+1), time(T), not steps(T), steps(S).     
_heuristic(move(T,Y), mod, S - T) :- disk(Y), Y > 3, time(T), not steps(T), steps(S).      
                                                                 
#show _heuristic/3.
#show put/2.         
#show move/2.

