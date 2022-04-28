absDiff(X, Y, Z):- X>=Y, Z = X - Y, X=1..S, Z=1..S, Y=1..S, steps(S).
absDiff(X, Y, Z):- X< Y, Z = Y - X, X=1..S, Z=1..S, Y=1..S, steps(S).
 
_heuristic(put(T,X), mod, S/2 - Val) :- disk(X;X+1), time(T), not steps(T), absDiff(T, S/2, Val), steps(S).     
_heuristic(move(T,Y), mod, S/2 - Val) :- disk(Y), Y > 3, time(T), not steps(T), absDiff(T, S/2, Val), steps(S).       
                                                                 
#show _heuristic/3.                             
#show put/2.         
#show move/2.