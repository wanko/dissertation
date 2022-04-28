                                                           
_heuristic(on(T,X,Y), mod, n) :- disk(X;Y), X < Y, time(T), not steps(T), steps(S).
_heuristic(blocked(T,X), mod, n) :- disk(X;Y), X < Y, time(T), not steps(T), steps(S).
                                                                 
#show _heuristic/3.
#show on/3.         
#show blocked/2.
                         
