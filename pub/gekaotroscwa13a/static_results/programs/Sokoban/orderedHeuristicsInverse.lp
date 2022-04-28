                              
_heuristic(move(f,X,Y,T), mod, m - T) :- square(X, Y), time(T).
_heuristic(move(t,X,Y,T), mod, m - T) :- square(X, Y), time(T).                                 
                                                                 
#show _heuristic/3.         
#show move/4.    