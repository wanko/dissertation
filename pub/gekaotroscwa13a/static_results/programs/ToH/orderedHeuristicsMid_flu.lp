absDiff(X, Y, Z):- X>=Y, Z = X - Y, X=1..S, Z=1..S, Y=1..S, steps(S).
absDiff(X, Y, Z):- X< Y, Z = Y - X, X=1..S, Z=1..S, Y=1..S, steps(S).
                                                             
_heuristic(on(T,X,Y), mod, S/2 - Val) :- disk(X;Y), X < Y, time(T), not steps(T), absDiff(T, S/2, Val), steps(S).
_heuristic(blocked(T,X), mod, S/2 - Val) :- disk(X;Y), X < Y, time(T), not steps(T), absDiff(T, S/2, Val), steps(S).
                                                                 
#show _heuristic/3.
#show on/3.         
#show blocked/2.
