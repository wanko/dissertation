moves(S):- S={time(T)}.     
                           
_heuristic(move(f(j,X,Y,XX,YY), T), mod, S-T) :- sort(f(j,X,Y,XX,YY)), time(T), moves(S). 

#show _heuristic/3.

