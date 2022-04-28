
_heuristic(box(X,Y,T), level, 0) :- square(X,Y), time(T), not boxes(0).    
_heuristic(box(X,Y,T), factor, 1) :- square(X,Y), time(T), not boxes(0).    
_heuristic(box(X,Y,T), init, 0) :- square(X,Y), time(T), not boxes(0).                                                    
                                                                 
#show _heuristic/3.   
#show box/3.  