                                                        
_heuristic(on(T,X,Y), level, 0) :- disk(X;Y), X < Y, time(T), not steps(T), steps(S).
_heuristic(blocked(T,X), level, 0) :- disk(X;Y), X < Y, time(T), not steps(T), steps(S).   
_heuristic(on(T,X,Y), factor, 1) :- disk(X;Y), X < Y, time(T), not steps(T), steps(S).
_heuristic(blocked(T,X), factor, 1) :- disk(X;Y), X < Y, time(T), not steps(T), steps(S).
_heuristic(on(T,X,Y), init, 0) :- disk(X;Y), X < Y, time(T), not steps(T), steps(S).
_heuristic(blocked(T,X), init, 0) :- disk(X;Y), X < Y, time(T), not steps(T), steps(S).
                                                                 
#show _heuristic/3.
#show on/3.         
#show blocked/2.
            
