% heuristic
_heuristic(on(T-1,N1,N),true,S-T+10)  :- on(T,N1,N), T>0, steps(S).
_heuristic(on(T-1,N1,N),false,S-T+10) :- not on(T,N1,N), 
                                         disk(N1;N), N1<N, time(T), T>0, steps(S).

_heuristic(blocked(T-1,X),true,S-T+10)  :- blocked(T,X),     T>0, steps(S).
_heuristic(blocked(T-1,X),false,S-T+10) :- not blocked(T,X), T>0, steps(S),
					   time(T), disk(X).

#show blocked/2.
#show _heuristic/3.
#show on/3.
