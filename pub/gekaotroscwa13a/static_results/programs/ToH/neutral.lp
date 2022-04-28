     
_heuristic(put(T,X), level, 0) :- disk(X;X+1), time(T), not steps(T).     
_heuristic(move(T,Y), level, 0) :- disk(Y), Y > 3, time(T), not steps(T).   
_heuristic(put(T,X), factor, 1) :- disk(X;X+1), time(T), not steps(T).     
_heuristic(move(T,Y), factor, 1) :- disk(Y), Y > 3, time(T), not steps(T).     
_heuristic(put(T,X), init, 0) :- disk(X;X+1), time(T), not steps(T).     
_heuristic(move(T,Y), init, 0) :- disk(Y), Y > 3, time(T), not steps(T).       
                                                                 
#show _heuristic/3.               
#show put/2.         
#show move/2.                      
