                         
_heuristic(hold(f(c,X,Y),T), level, 0) :- gc(f(c,X,Y)), time(T).                                
_heuristic(hold(f(c,X,Y),T), factor, 1) :- gc(f(c,X,Y)), time(T).                            
_heuristic(hold(f(c,X,Y),T), init, 0) :- gc(f(c,X,Y)), time(T). 

#show hold/2.
#show _heuristic/3.