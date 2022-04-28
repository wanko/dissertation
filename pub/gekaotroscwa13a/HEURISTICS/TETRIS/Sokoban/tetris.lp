_heuristic(box(X,Y,T-1),true,m-T+1)  :- box(X,Y,T).
_heuristic(box(X,Y,T-1),false,m-T+1) :- not box(X,Y,T), 
					square(X,Y), time(T).
#show _heuristic/3.
#show box/3.

