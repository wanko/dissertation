% heuristic
_heuristic(on(T-1,N1,N),true,S-T+10)  :- on(T,N1,N), T>0, steps(S).
_heuristic(on(T-1,N1,N),false,S-T+10) :- not on(T,N1,N), 
                                         disk(N1;N), N1<N, time(T), T>0, steps(S).
#show _heuristic/3.
#show on/3.
