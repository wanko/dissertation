_heuristic(move(f(j,X,Y,XX,YY), T), level, 0) :- sort(f(j,X,Y,XX,YY)), time(T). 
_heuristic(move(f(j,X,Y,XX,YY), T), factor, 1) :- sort(f(j,X,Y,XX,YY)), time(T). 
_heuristic(move(f(j,X,Y,XX,YY), T), init, 0) :- sort(f(j,X,Y,XX,YY)), time(T). 

#show _heuristic/3.
