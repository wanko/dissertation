
_heuristic(box(X,Y,T), mod, T) :- square(X,Y), time(T), not boxes(0).     
                                                  
#show _heuristic/3.   
#show box/3.    