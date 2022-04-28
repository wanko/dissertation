   
_heuristic(put(T,X), mod, T) :- disk(X;X+1), time(T), not steps(T).     
_heuristic(move(T,Y), mod, T) :- disk(Y), Y > 3, time(T), not steps(T).    
                                                                 
#show _heuristic/3.           
#show put/2.         
#show move/2.
