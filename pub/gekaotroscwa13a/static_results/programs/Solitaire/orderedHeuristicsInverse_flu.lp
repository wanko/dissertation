moves(S):- S={time(T)}.     
               
_heuristic(hold(f(c,X,Y),T), mod, S-T) :- gc(f(c,X,Y)), time(T), moves(S). 

#show hold/2.
#show _heuristic/3.